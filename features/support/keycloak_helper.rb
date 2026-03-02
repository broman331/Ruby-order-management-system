require 'faraday'
require 'json'

module KeycloakHelper
  def self.get_token
    @token ||= fetch_token
  end

  def self.fetch_token
    url = ENV.fetch('KEYCLOAK_TOKEN_URL', 'http://localhost:18080/realms/master/protocol/openid-connect/token')
    client_id = ENV.fetch('KEYCLOAK_CLIENT_ID', 'test-client')
    client_secret = ENV.fetch('KEYCLOAK_CLIENT_SECRET', 'test-secret')

    conn = Faraday.new(url: url) do |f|
      f.headers['Host'] = 'localhost'
      f.request :url_encoded
      f.response :logger, nil, { headers: false, bodies: false } # Minimize noise from auth logs
      f.adapter Faraday.default_adapter
    end

    response = conn.post do |req|
      req.body = {
        grant_type: 'client_credentials',
        client_id: client_id,
        client_secret: client_secret
      }
    end

    unless response.success?
      raise "Failed to get token from Keycloak. Status: #{response.status}, Body: #{response.body}"
    end

    JSON.parse(response.body)['access_token']
  end

  def self.clear_token!
    @token = nil
  end
end
