---
# 📘 **Shop-App General Documentation**

Welcome to the **Shop-App** documentation. This document serves as an overview and guide on how to use, set up, and deploy the Shop-App API.

## 📋 **Table of Contents**
1. [Overview](#overview)
2. [Getting Started](#getting-started)
3. [Documentation Links](#documentation-links)
4. [Key Features](#key-features)
5. [Project Structure](#project-structure)
6. [Contributing](#contributing)
7. [License](#license)

---

## 📘 **Overview**

The **Shop-App** is a robust e-commerce backend API built using **Golang**, **Gin**, **PostgreSQL**, and **Docker**. It allows users to register, login, create products, manage categories, add items to baskets, and place orders. This API uses JWT-based authentication and supports a fully containerized deployment process.

With this project, users can learn about key concepts such as:
- **API Development**
- **Authentication with JWT**
- **Infrastructure as Code (IaC) with Terraform**
- **CI/CD with GitHub Actions**

---

## 🚀 **Getting Started**

To get started with the **Shop-App**, follow these steps:

1. **Generate a new JWT secret**
   ```bash
   python3 update_jwt_secret.py
   ```
   This command generates a new JWT secret and automatically updates the `.env` file.

2. **Run the app using Docker Compose**
   ```bash
   docker compose up --build -d
   ```
   This command will build and start the Docker containers for the backend and database.

3. **Access the API**
   Visit the API at: `http://localhost:8080`

For more details on environment variable configuration, check out the [local environment setup documentation](./docs/local_shop-app_api.md).

---

## 📚 **Documentation Links**

- **[Local API Usage Guide](./docs/local_shop-app_api.md)**
  Learn how to use the Shop-App locally. This guide walks you through available API routes, authentication, and how to interact with the API.

- **[Deploy Infrastructure on Azure](./docs/DeployInfrastructure.md)**
  This document explains how to deploy the Shop-App infrastructure on Azure using **Terraform** and **GitHub Actions** for CI/CD. It includes instructions for setting up Azure resources, configuring your CI/CD pipelines, and ensuring proper security.

---

## 🚀 **Key Features**

- **User Authentication**: Register, login, and manage users.
- **Item Management**: Add, update, delete, and view items.
- **Basket Management**: Users can add, view, and remove items from their basket.
- **Order Management**: Place and track orders.
- **JWT Authentication**: Secure access to endpoints using JWT tokens.
- **Infrastructure as Code**: Full infrastructure deployment using **Terraform**.
- **CI/CD**: GitHub Actions are used for automated testing and deployment.

---

## 📁 **Project Structure**

```
shop-app/
├── api/
│   ├── controllers/      # API route controllers
│   ├── helpers/          # Helper functions and utilities
│   └── middleware/       # Authentication and other middleware
├── database/             # Database connection logic
├── docs/                 # Documentation for API and infrastructure
├── models/               # Data models and GORM models
├── volumes/              # Volume storage for database persistence
├── Dockerfile            # Dockerfile for building the application image
├── docker-compose.yml    # Docker Compose file for multi-container setup
├── .env                  # Environment variable file
├── go.mod                # Go module dependencies
├── go.sum                # Go module checksum file
├── update_jwt_secret.py  # Script to update the JWT secret in the .env file
└── main.go               # Main entry point for the Go application
```

---

## 📜 **License**
This project is licensed under the MIT License.

