require 'jwt'

class AuthMiddleware
  HMAC_SECRET = ENV.fetch('JWT_SECRET', 'super-secret-key-1234')

  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)

    # Allow health checks and public endpoints without auth
    return @app.call(env) if request.path_info == '/health'

    auth_header = env['HTTP_AUTHORIZATION']
    
    unless auth_header && auth_header.start_with?('Bearer ')
      Db.log_error('Unauthorized Access Attempt', 'Missing or malformed Authorization header')
      return [401, { 'Content-Type' => 'application/json' }, [{ error: 'Unauthorized: Missing token' }.to_json]]
    end

    token = auth_header.split(' ').last

    begin
      # Decode token and verify signature using the symmetric secret
      decoded_token = JWT.decode(token, HMAC_SECRET, true, { algorithm: 'HS256' })
      env['jwt.payload'] = decoded_token.first
    rescue JWT::DecodeError => e
      Db.log_error('Invalid Auth Token', "Reason: #{e.message}")
      return [401, { 'Content-Type' => 'application/json' }, [{ error: 'Unauthorized: Invalid token' }.to_json]]
    end

    @app.call(env)
  end
end
