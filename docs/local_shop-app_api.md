---
# 📘 **Shop-App Documentation**

## 📋 **Table of Contents**
1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Installation](#installation)
4. [Project Structure](#project-structure)
5. [Environment Variables](#environment-variables)
6. [Usage](#usage)
7. [API Endpoints](#api-endpoints)
8. [Authentication](#authentication)
9. [Data Models](#data-models)
10. [Scripts](#scripts)
11. [Commands](#commands)
12. [Contributing](#contributing)
13. [License](#license)

---

## 📘 **Overview**

The **Shop-App** is a simple e-commerce backend API built using **Golang**, **Gin**, and **PostgreSQL**. It allows users to register, login, create products, manage categories, add items to baskets, and place orders. This app follows industry best practices for JWT-based authentication and Dockerized deployments.

---

## 📦 **Prerequisites**

1. **Docker** (v20+)
2. **Docker Compose** (v2+)
3. **Go** (v1.23+)
4. **PostgreSQL** (v15+)

---

## ⚙️ **Installation**

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Amiche02/junia-isen-project-example-api.git
   cd junia-isen-project-example-api/shop-app
   ```

2. **Generate a new JWT secret:**
   ```bash
   python3 update_jwt_secret.py
   ```
   This command will generate a secure JWT secret and automatically update the `.env` file.

3. **Set up the .env file:**
   ```bash
   cp .env.example .env
   ```
   Ensure the values of **POSTGRES_USER**, **POSTGRES_PASSWORD**, and **JWT_SECRET** are properly configured.

4. **Run the application using Docker Compose:**
   ```bash
   docker compose up --build -d
   ```

5. **Check if the containers are running:**
   ```bash
   docker ps
   ```
   You should see two containers:
   - `shop-app-backend`
   - `shop-app-db`

---

## 📁 **Project Structure**
```
shop-app/
├── api/
│   ├── controllers/
│   ├── helpers/
│   └── middleware/
├── database/
├── models/
├── volumes/
├── Dockerfile
├── docker-compose.yml
├── .env
├── go.mod
├── go.sum
└── main.go
```

---

## 🌐 **Environment Variables**

The app requires a `.env` file to store important configuration details. Below is an explanation of each environment variable:

| **Variable**       | **Description**                       |
|-------------------|---------------------------------------|
| `POSTGRES_USER`    | Username for PostgreSQL database      |
| `POSTGRES_PASSWORD`| Password for PostgreSQL database      |
| `POSTGRES_DB`      | Name of the database                  |
| `DB_CONNECTION_TYPE` | local or azure, depending on the setup |
| `POSTGRES_HOST`    | Hostname for PostgreSQL (container name) |
| `POSTGRES_PORT`    | Port to access the PostgreSQL DB      |
| `JWT_SECRET`       | Secret key for JWT token generation   |

---

## 🚀 **Usage**

1. **Run the app**
   ```bash
   docker compose up --build -d
   ```

2. **Access the API**
   The API will be available at: `http://localhost:8080`

3. **Test the API using Postman or cURL**

---

## 📡 **API Endpoints**

### **Authentication**
| **Method** | **Endpoint**  | **Description**         |
|-----------|---------------|-------------------------|
| **POST**  | `/register`    | Register a new user     |
| **POST**  | `/login`       | Login and get JWT token |

### **User Management**
| **Method** | **Endpoint**  | **Description**         |
|-----------|---------------|-------------------------|
| **GET**   | `/users`       | Get all users (auth required) |

### **Item Management**
| **Method** | **Endpoint**  | **Description**         |
|-----------|---------------|-------------------------|
| **GET**   | `/items`       | Get all items (auth required) |
| **GET**   | `/items/:id`   | Get an item by ID (auth required) |
| **POST**  | `/items`       | Create a new item (auth required) |
| **DELETE**| `/items/:id`   | Delete an item (auth required) |

### **Basket Management**
| **Method** | **Endpoint**  | **Description**         |
|-----------|---------------|-------------------------|
| **GET**   | `/baskets`     | Get the user's basket (auth required) |
| **POST**  | `/baskets`     | Add an item to basket (auth required) |
| **DELETE**| `/baskets/:item_id` | Remove an item from basket (auth required) |

---

## 🔐 **Authentication**

- The app uses **JWT tokens** for authentication. After logging in, you'll receive a token.
- Add the token to the `Authorization` header for all requests.
- Example of **Authorization header**:
  ```
  Authorization: Bearer <your_jwt_token>
  ```

---

## 🗃️ **Data Models**

**User**
```json
{
  "user_id": "uuid",
  "name": "string",
  "email": "string",
  "password": "string"
}
```

**Item**
```json
{
  "item_id": "uuid",
  "name": "string",
  "description": "string",
  "price": "float",
  "stock": "int",
  "category_id": "uuid"
}
```

**Basket**
```json
{
  "basket_id": "uuid",
  "user_id": "uuid"
}
```

---

## 📜 **Scripts**

- **Generate a new JWT secret:**
  ```bash
  python3 update_jwt_secret.py
  ```
  This script updates the `.env` file with a new `JWT_SECRET` value.

---

## 💻 **Commands**

| **Action**        | **Command**                            |
|-------------------|---------------------------------------|
| Generate JWT secret | `python3 update_jwt_secret.py`       |
| Start the app     | `docker compose up --build -d`        |
| Stop the app      | `docker compose down`                 |
| View logs         | `docker compose logs -f`              |

