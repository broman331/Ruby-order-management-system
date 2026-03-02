Feature: Order Management API
  As an external system
  I want to create orders via the API
  So that they are persisted securely in the database

  Background:
    Given the external system has a valid Keycloak token

  Scenario: Successfully create a valid order
    When a POST request is made to "/api/v1/orders" with payload:
      """
      {
        "customer_id": "cust_123",
        "total_amount": 150.00,
        "items": [
          { "product_id": "prod_1", "quantity": 2 }
        ]
      }
      """
    Then the response status should be 201
    And the response should contain a valid "$.order_id"
    And the order should be successfully persisted in the database

  Scenario: Attempt to create an invalid order triggers self-healing debug log
    # This scenario is designed to fail to demonstrate the Agentic After Hook automatically 
    # capturing database error logs.
    When a POST request is made to "/api/v1/orders" with payload:
      """
      {
        "customer_id": "invalid_cust",
        "total_amount": -50.00
      }
      """
    Then the response status should be 201
    And the response should contain a valid "$.order_id"
