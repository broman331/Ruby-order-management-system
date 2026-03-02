require 'faraday'
require 'faraday/retry'
require 'json'
require 'jsonpath'

class ApiClient
  def initialize(base_url: ENV.fetch('API_BASE_URL', 'http://localhost:18081'))
    @conn = Faraday.new(url: base_url) do |f|
      f.headers['Host'] = 'localhost'
      f.request :json
      f.response :json, content_type: /\bjson$/
      f.request :retry, max: 2, interval: 0.05, interval_randomness: 0.5, backoff_factor: 2
      f.response :logger, nil, { headers: true, bodies: true }
      f.adapter Faraday.default_adapter
    end
  end

  def get(path, params = {})
    @conn.get(path, params) do |req|
      set_auth_header(req)
    end
  end

  def post(path, body = {})
    @conn.post(path) do |req|
      set_auth_header(req)
      req.body = body.to_json unless body.empty?
    end
  end

  # Returns an array of matched nodes against a given JSON payload
  def evaluate_jsonpath(payload, path)
    payload_hash = payload.is_a?(String) ? JSON.parse(payload) : payload
    JsonPath.on(payload_hash, path)
  end

  private

  def set_auth_header(req)
    token = KeycloakHelper.get_token
    req.headers['Authorization'] = "Bearer #{token}"
  end
end
