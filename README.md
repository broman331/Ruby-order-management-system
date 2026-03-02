# Ruby Order Management System

![CI Status](https://github.com/broman331/Ruby-order-management-system/actions/workflows/ci.yml/badge.svg)

> [!IMPORTANT]
> **CI/CD Pipeline Note**: The CI build for this project is **intentionally configured to fail**. 
> This is by design to demonstrate the **Agentic Self-Healing Hook**. 
> The suite includes a negative test scenario (`Attempt to create an invalid order`) that triggers a failure, which in turn showcases the framework's ability to automatically scrape and report database error logs directly in the CI console.

A production-grade Ruby Order Management API secured with Keycloak/JWT, featuring an 'Agentic' BDD automation framework that auto-extracts database error logs upon test failure.

## 🚀 About the Project

This is a complete, high-level Ruby ecosystem featuring:
*   **Structured REST API**: A Sinatra-based Order Management service with custom JWT/OAuth2 AuthMiddleware and PostgreSQL persistence.
*   **Security Emulation**: A dedicated `auth_mock` service that generates cryptographically signed JWTs, simulating a real-world Keycloak issuer.
*   **Agentic BDD Framework**: A Cucumber-based automation suite with a self-healing `After` hook that proactively retrieves PostgreSQL error logs on failure for instant root-cause analysis.
*   **Full Orchestration**: Entire stack (API, Auth Mock, DB, and Tests) containerized via Docker Compose for seamless E2E execution.

## 🚀 Architecture Overview

The system is composed of several micro-services orchestrated via Docker Compose:

1.  **Order API (`order_api/`)**: A Sinatra-based RESTful service.
    *   **Security**: Uses custom `AuthMiddleware` to validate JWT Bearer tokens.
    *   **Persistence**: Connects to PostgreSQL to store order records.
    *   **Logging**: Implements a structured error logging mechanism into a dedicated DB table for observability.
2.  **Auth Mock (`auth_mock/`)**: Emulates a Keycloak OIDC issuer.
    *   Generates cryptographically signed JWTs (HS256) for client credentials flow.
3.  **PostgreSQL**: Central database for orders and logs.
4.  **Cucumber Tests (`features/`)**: High-level BDD specifications.
    *   **ApiClient**: Reusable Faraday wrapper with automated token injection.
    *   **DbHelper**: Direct SQL verification of API side-effects.
    *   **Agentic Self-Healing Hook**: An `After` hook that automatically extracts DB error logs upon test failure for immediate root-cause analysis.

## 🛠️ Tech Stack

*   **Language**: Ruby 3.2
*   **API Framework**: Sinatra
*   **Web Server**: Puma
*   **Database**: PostgreSQL
*   **Testing**: Cucumber, RSpec-Expectations, Faraday
*   **Containerization**: Docker, Docker Compose

## 🏁 Getting Started

### Prerequisites
*   Docker & Docker Compose

### Running the System & Tests
To spin up the entire environment and execute the BDD suite, simply run:

```bash
docker-compose up --build --exit-code-from tests
```

This will:
1.  Initialize the database via `init.sql`.
2.  Start the Auth Mock and Order API.
3.  Run the Cucumber tests and output results to the console.

## 🔍 Agentic Debugging Feature
If a test scenario fails, the framework automatically queries the `error_logs` table in PostgreSQL. It captures the specific error message and payload details injected by the API during the failure and appends it to the test report. This eliminates the need to manually check logs or DB state during debugging.

## 📁 Project Structure

```text
.
├── auth_mock/           # Keycloak Emulation
├── order_api/           # Order Management Service
│   ├── controllers/
│   └── lib/
├── features/            # BDD Specifications
│   ├── step_definitions/
│   └── support/         # Helpers & Hooks
├── lib/                 # Shared Test Components
├── init.sql             # DB Schema
└── docker-compose.yml   # Infrastructure Orchestration
```
