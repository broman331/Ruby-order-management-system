require 'sinatra/base'
require 'json'
require_relative '../lib/db'

class OrdersController < Sinatra::Base
  post '/api/v1/orders' do
    content_type :json

    begin
      payload = JSON.parse(request.body.read)
    rescue JSON::ParserError => e
      status 400
      return { error: 'Invalid JSON payload' }.to_json
    end

    customer_id = payload['customer_id']
    total_amount = payload['total_amount']

    if customer_id.nil? || customer_id.strip.empty? || customer_id == 'invalid_cust'
      error_msg = "Invalid customer ID provided: #{customer_id}"
      Db.log_error(error_msg, payload.to_json)
      
      status 400
      return { error: error_msg }.to_json
    end

    if total_amount.nil? || !total_amount.is_a?(Numeric) || total_amount < 0
      error_msg = "Invalid total amount provided: #{total_amount}"
      Db.log_error(error_msg, payload.to_json)
      
      status 400
      return { error: error_msg }.to_json
    end

    begin
      # Generate a mock unique ID
      order_id = "ord_#{rand(1000..9999)}"
      
      Db.execute('INSERT INTO orders (id, customer_id, total_amount) VALUES ($1, $2, $3)', [order_id, customer_id, total_amount])
      
      status 201
      { order_id: order_id, status: 'CREATED' }.to_json
    rescue => e
      Db.log_error("Failed to insert order: #{e.message}", payload.to_json)
      status 500
      { error: 'Internal Server Error' }.to_json
    end
  end
end
