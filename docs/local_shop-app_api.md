# **Shop-App Backend Documentation**

## **1. Overview**
The **Shop-App** is a backend service for managing an e-commerce platform. It provides functionality for user authentication, item management, basket management, and more. This backend is built using **Go (Golang)** with the **Gin framework** and **GORM** as the ORM. It supports both **local PostgreSQL** and **Azure PostgreSQL** for database storage.

---

## **2. Project Structure**
The backend codebase follows a modular structure for better maintainability and scalability.

```
shop-app/
  ├── api/
  │   ├── controllers/        # Request controllers for routes
  │   ├── helpers/            # Helper functions for controllers
  │   └── middleware/         # JWT Authentication middleware
  ├── database/
  │   ├── db.go               # Main database connection logic
  │   ├── db_azure.go         # Azure PostgreSQL connection logic
  │   └── db_local.go         # Local PostgreSQL connection logic
  ├── models/
  │   └── models.go           # Data models (User, Basket, Item, Order, etc.)
  ├── .env                    # Environment variables for configuration
  ├── docker-compose.yml      # Docker Compose for local development
  ├── docker-compose.prod.yml # Docker Compose for production (Azure PostgreSQL)
  ├── Dockerfile              # Dockerfile for backend containerization
  ├── main.go                 # Entry point for the Gin web server
  └── update_jwt_secret.py    # Script to update the JWT secret in the .env file
```

---

## **3. Environment Configuration**
Environment variables are set in a `.env` file at the root of the project. You can choose between a **local PostgreSQL database** or **Azure PostgreSQL**.

### **Generate a new JWT secret:**
   ```bash
   python3 update_jwt_secret.py
   ```
   This command will generate a secure JWT secret and automatically update the `.env` file.


### **Environment Variables**
```env
# Database Configuration
POSTGRES_USER=admin
POSTGRES_PASSWORD=admin123
POSTGRES_DB=shop_db
DB_CONNECTION_TYPE=local   # Set to 'azure' for Azure PostgreSQL

# Backend Configuration
POSTGRES_HOST=db
POSTGRES_PORT=5432

# JWT Configuration
JWT_SECRET=<Generated secret using update_jwt_secret.py>
```

> **Note**: When using Azure, you will need to set `AZURE_POSTGRES_USER`, `AZURE_POSTGRES_PASSWORD`, `AZURE_POSTGRES_DB`, and `AZURE_POSTGRES_HOST` in the `.env` file.

---

## **4. Database Setup**

### **Local PostgreSQL**
- The `docker-compose.yml` file will automatically set up a PostgreSQL instance for you.

### **Azure PostgreSQL**
1. Set up an Azure PostgreSQL instance.
2. Set the following environment variables in `.env`:
   ```env
   AZURE_POSTGRES_USER=<your_azure_user>
   AZURE_POSTGRES_PASSWORD=<your_azure_password>
   AZURE_POSTGRES_DB=<your_azure_database_name>
   AZURE_POSTGRES_HOST=<your_azure_host>
   DB_CONNECTION_TYPE=azure
   ````

---

## **5. How to Run Locally**
### **Step 1: Clone the Repository**
```bash
git clone https://github.com/Amiche02/junia-isen-project-example-api
cd junia-isen-project-example-api/shop-app
```

### **Step 2: Run Docker Compose**
Run the following command to start the backend and database services.
```bash
docker-compose up --build
```

This will:
- Launch the backend API at **http://localhost:8080**
- Launch a local PostgreSQL database at port **5432**

> **Note**: If you want to use Azure PostgreSQL, update `docker-compose.prod.yml` with your Azure configurations and run:
```bash
docker-compose -f docker-compose.prod.yml up --build
```

### **Step 3: API Documentation**
After running the app, you can access the API at **http://localhost:8080**.

---

## **6. API Endpoints**
Here are the main endpoints provided by the API.

### **1. Health Check**
- **Endpoint**: `GET /`
- **Description**: Check if the API is running.
- **Example**:
  ```bash
  curl http://localhost:8080/
  ```

### **2. User Authentication**

#### **Register**
- **Endpoint**: `POST /register`
- **Payload**:
  ```json
  {
    "name": "John Doe",
    "email": "john@example.com",
    "password": "password123"
  }
  ```
- **Example**:
  ```bash
  curl -X POST http://localhost:8080/register -H 'Content-Type: application/json' \
  -d '{"name": "John Doe", "email": "john@example.com", "password": "password123"}'
  ```

#### **Login**
- **Endpoint**: `POST /login`
- **Payload**:
  ```json
  {
    "email": "john@example.com",
    "password": "password123"
  }
  ```
- **Example**:
  ```bash
  curl -X POST http://localhost:8080/login -H 'Content-Type: application/json' \
  -d '{"email": "john@example.com", "password": "password123"}'
  ```

---

## **7. Protected Endpoints**
> **Note**: You must include a valid JWT token in the `Authorization` header for these requests.

### **1. Items Management**
- **GET /items**
  ```bash
  curl -H "Authorization: Bearer <token>" http://localhost:8080/items
  ```
- **GET /items/:id**
  ```bash
  curl -H "Authorization: Bearer <token>" http://localhost:8080/items/ITEM_ID
  ```
- **POST /items**
  ```bash
  curl -X POST http://localhost:8080/items -H 'Content-Type: application/json' \
  -H "Authorization: Bearer <token>" \
  -d '{"name": "Laptop", "description": "A gaming laptop", "price": 1000, "stock": 10, "category_name": "Electronics"}'
  ```
- **DELETE /items/:id**
  ```bash
  curl -X DELETE -H "Authorization: Bearer <token>" http://localhost:8080/items/ITEM_ID
  ```

### **2. Basket Management**
- **GET /baskets**
  ```bash
  curl -H "Authorization: Bearer <token>" http://localhost:8080/baskets
  ```
- **POST /baskets**
  ```bash
  curl -X POST http://localhost:8080/baskets -H 'Content-Type: application/json' \
  -H "Authorization: Bearer <token>" \
  -d '{"item_id": "ITEM_ID", "quantity": 2}'
  ```
- **DELETE /baskets/:item_id**
  ```bash
  curl -X DELETE -H "Authorization: Bearer <token>" http://localhost:8080/baskets/ITEM_ID
  ```

---

## **8. Notes**
- Ensure you run `update_jwt_secret.py` to set a secure JWT secret.
- Always use HTTPS in production to secure token transmission.
