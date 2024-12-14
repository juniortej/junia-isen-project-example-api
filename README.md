# 📘 **Shop-App General Documentation**

Welcome to the **Shop-App** documentation. This document serves as an overview and guide on how to use, set up, and deploy the Shop-App API and its associated infrastructure.

## 📋 **Table of Contents**
1. [Overview](#overview)
2. [Getting Started](#getting-started)
3. [Project Structure](#project-structure)
4. [Documentation Links](#documentation-links)
5. [Key Features](#key-features)
6. [Contributing](#contributing)
7. [License](#license)

---

## 📘 **Overview**

The **Shop-App** is a robust e-commerce backend API built using **Golang**, **Gin**, **PostgreSQL**, and **Docker**. It allows users to register, login, create products, manage categories, add items to baskets, and place orders. This API uses JWT-based authentication and supports a fully containerized deployment process.

Additionally, the project includes an **Infrastructure as Code (IaC)** setup using **Terraform** for provisioning and managing Azure cloud resources, ensuring scalable and maintainable deployment.

With this project, users can learn about key concepts such as:
- **API Development**
- **Authentication with JWT**
- **Infrastructure as Code (IaC) with Terraform**
- **CI/CD with GitHub Actions**

---

## 🚀 **Getting Started**

To get started with the **Shop-App**, follow these steps:

### 1. **Clone the Repository**

```bash
git clone https://github.com/Amiche02/junia-isen-project-example-api.git
cd junia-isen-project-example-api
```

### 2. **Generate a New JWT Secret**

Generate a secure JWT secret and update the `.env` file:

```bash
python3 update_jwt_secret.py
```

### 3. **Run the App Using Docker Compose**

Start the backend and database services:

```bash
docker compose up --build -d
```

This command will:
- Launch the backend API at **http://localhost:8080**
- Launch a local PostgreSQL database at port **5432**

> **Note**: If you want to use Azure PostgreSQL, update `docker-compose.prod.yml` with your Azure configurations and run:

```bash
docker-compose -f docker-compose.prod.yml up --build -d
```

### 4. **Access the API**

Visit the API at: [http://localhost:8080](http://localhost:8080)

For more details on environment variable configuration, check out the [Local API Usage Guide](./docs/local_shop-app_api.md).

### 5. **Deploy Infrastructure on Azure**

Refer to the [Deploy Infrastructure on Azure](./docs/DeployInfrastructure.md) documentation for instructions on setting up Azure resources using Terraform and configuring CI/CD pipelines with GitHub Actions.

---

## 📁 **Project Structure**

Here is the complete directory structure of the **Shop-App** project, including both the backend API and the infrastructure setup.

```
junia-isen-project-example-api/
├── infrastructure/
│   ├── core/
│   │   ├── main.tf                   # Main configuration for core resources
│   │   ├── provider.tf               # Definition of providers (Azure, TLS, Random, etc.)
│   │   ├── variables.tf              # Variables used in core Terraform configurations
│   │   └── outputs.tf                # Outputs of core infrastructure (URLs, credentials, etc.)
│   │
│   ├── modules/
│   │   ├── app_service/
│   │   │   ├── main.tf               # Main configuration for App Service
│   │   │   ├── variables.tf          # Variables used in App Service module
│   │   │   └── outputs.tf            # Outputs of App Service module (App URL, ID, etc.)
│   │   │
│   │   ├── database/
│   │   │   ├── main.tf               # Main configuration for PostgreSQL Flexible Server
│   │   │   ├── variables.tf          # Variables used in Database module
│   │   │   └── outputs.tf            # Outputs of Database module (FQDN, server name, etc.)
│   │   │
│   │   ├── vnet/
│   │   │   ├── main.tf               # Main configuration for Virtual Network (VNet)
│   │   │   ├── variables.tf          # Variables used in VNet module
│   │   │   └── outputs.tf            # Outputs of VNet module (Subnet IDs, VNet ID, etc.)
│   │   │
│   │   └── vpn_gateway/
│   │       ├── main.tf               # Main configuration for VPN Gateway
│   │       ├── variables.tf          # Variables used in VPN Gateway module
│   │       └── outputs.tf            # Outputs of VPN Gateway module (Public IP, VPN Gateway ID, etc.)
│   │
│   ├── scripts/
│   │   ├── run_core.sh               # Script to initialize and apply the core infrastructure
│   │   ├── clean_up.sh               # Script to clean up and destroy the infrastructure
│   │   ├── create_identity.sh        # Script to create Service Principals (SPs) and store credentials
│   │   └── delete_identity.sh        # Script to delete Service Principals (SPs) and clean .env variables
│   │
│   └── .env                          # File for storing environment variables (not in version control)
│
├── shop-app/
│   ├── api/
│   │   ├── controllers/              # Request controllers for routes
│   │   ├── helpers/                  # Helper functions for controllers
│   │   └── middleware/               # JWT Authentication middleware
│   ├── database/
│   │   ├── db.go                     # Main database connection logic
│   │   ├── db_azure.go               # Azure PostgreSQL connection logic
│   │   └── db_local.go               # Local PostgreSQL connection logic
│   ├── models/
│   │   └── models.go                 # Data models (User, Basket, Item, Order, etc.)
│   ├── docs/
│   │   ├── DeployInfrastructure.md   # Infrastructure deployment documentation
│   │   └── local_shop-app_api.md     # Local API usage documentation
│   ├── volumes/                      # Volume storage for database persistence
│   ├── Dockerfile                    # Dockerfile for backend containerization
│   ├── docker-compose.yml            # Docker Compose file for multi-container setup
│   ├── docker-compose.prod.yml       # Docker Compose file for production setup (Azure PostgreSQL)
│   ├── .env                          # Environment variable file
│   ├── go.mod                        # Go module dependencies
│   ├── go.sum                        # Go module checksum file
│   ├── update_jwt_secret.py          # Script to update the JWT secret in the .env file
│   └── main.go                       # Entry point for the Gin web server
│
├── .gitignore                        # Git ignore file
├── README.md                         # This documentation file
└── LICENSE                           # License information
```

---

## 📚 **Documentation Links**

- **[Local API Usage Guide](./shop-app/docs/local_shop-app_api.md)**
  Learn how to use the Shop-App locally. This guide walks you through available API routes, authentication, and how to interact with the API.

- **[Deploy Infrastructure on Azure](./shop-app/docs/DeployInfrastructure.md)**
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
- **Dockerization**: Containerized backend and database for easy deployment and scalability.

---

## 📜 **Additional Documentation**

### Infrastructure Deployment Documentation

Refer to [DeployInfrastructure.md](./shop-app/docs/DeployInfrastructure.md) for detailed instructions on setting up and managing the infrastructure using Terraform.

### Local API Usage Documentation

Refer to [local_shop-app_api.md](./shop-app/docs/local_shop-app_api.md) for comprehensive guidance on running and interacting with the Shop-App API locally.
