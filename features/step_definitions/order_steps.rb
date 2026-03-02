Given('the external system has a valid Keycloak token') do
  @token = KeycloakHelper.get_token
  expect(@token).to_not be_nil, "Expected to retrieve a valid token from Keycloak"
end

When('a POST request is made to {string} with payload:') do |path, payload|
  @response = @api_client.post(path, JSON.parse(payload))
end

Then('the response status should be {int}') do |expected_status|
  expect(@response.status).to eq(expected_status)
end

Then('the response should contain a valid {string}') do |json_path|
  payload = @response.body
  matches = @api_client.evaluate_jsonpath(payload, json_path)
  expect(matches).to_not be_empty, "Expected to find value for JSON path #{json_path}"
  @order_id = matches.first
end

Then('the order should be successfully persisted in the database') do
  expect(@order_id).to_not be_nil, "Order ID was not captured from the previous step"
  
  db_order = @db_helper.get_order_by_id(@order_id)
  expect(db_order).to_not be_nil, "Order was not found in database for ID #{@order_id}"
  expect(db_order['id']).to eq(@order_id)
end
