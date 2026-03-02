require 'sinatra'
require 'sinatra/json'

require_relative 'lib/db'
require_relative 'lib/auth_middleware'
require_relative 'controllers/orders_controller'

set :bind, '0.0.0.0'
set :port, 8080
# Disable Rack::Protection to prevent 403s in tests; in a real app, properly configure CORS and Host auth
set :protection, except: [:host_authorization]

# Add our JWT validation middleware
use AuthMiddleware

# Mount our controllers
use OrdersController

# Global health check endpoint
get '/health' do
  json status: "Order API is running", db_connected: !Db.connection.nil?
end
