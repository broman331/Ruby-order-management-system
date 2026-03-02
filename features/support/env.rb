require 'dotenv/load'
require 'rspec/expectations'
require 'cucumber'
require 'faraday'
require 'faraday/retry'
require 'jsonpath'
require 'pg'

# Add lib directory to load path
$LOAD_PATH.unshift(File.expand_path('../../lib', __dir__))

# Require helpers and core framework components
require_relative 'keycloak_helper'
require_relative 'db_helper'
require 'api_client'

# Initialize global helpers Before the entire suite or specific tests
Before do
  @api_client = ApiClient.new
  @db_helper = DbHelper.new
end
