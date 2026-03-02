require 'sinatra'
require 'sinatra/json'
require 'jwt'

set :bind, '0.0.0.0'
set :port, 8080
set :protection, :except => [:host_authorization]

# A shared symmetric key that our Order API will also use to verify tokens
HMAC_SECRET = ENV.fetch('JWT_SECRET', 'super-secret-key-1234')

# Fake Keycloak Token Endpoint
post '/realms/master/protocol/openid-connect/token' do
  # JWT Payload
  payload = {
    exp: Time.now.to_i + 3600, # Expires in 1 hour
    iat: Time.now.to_i,
    iss: 'http://auth_mock:8080/realms/master',
    sub: 'test-client',
    aud: 'account'
  }

  token = JWT.encode(payload, HMAC_SECRET, 'HS256')

  json access_token: token, expires_in: 3600, token_type: "Bearer"
end

# Fake User Info / Healthcheck endpoint
get '/health' do
  json status: "Auth Mock is running"
end
