# **Infrastructure Documentation for the Shop App Project**


## **🗂️ Directory Structure**

Here is the complete directory structure of the **infrastructure** folder for the Shop App project. Each file and folder has a specific role in the provisioning, configuration, and management of the cloud resources.

```
infrastructure/
├── core/
│   ├── main.tf                   # Main configuration for core resources
│   ├── provider.tf               # Definition of providers (Azure, TLS, Random, etc.)
│   ├── variables.tf              # Variables used in core Terraform configurations
│   ├── outputs.tf                # Outputs of core infrastructure (URLs, credentials, etc.)
│
├── modules/
│   ├── app_service/
│   │   ├── main.tf               # Main configuration for App Service
│   │   ├── variables.tf          # Variables used in App Service module
│   │   └── outputs.tf            # Outputs of App Service module (App URL, ID, etc.)
│   │
│   ├── database/
│   │   ├── main.tf               # Main configuration for PostgreSQL Flexible Server
│   │   ├── variables.tf          # Variables used in Database module
│   │   └── outputs.tf            # Outputs of Database module (FQDN, server name, etc.)
│   │
│   ├── vnet/
│   │   ├── main.tf               # Main configuration for Virtual Network (VNet)
│   │   ├── variables.tf          # Variables used in VNet module
│   │   └── outputs.tf            # Outputs of VNet module (Subnet IDs, VNet ID, etc.)
│   │
│   └── vpn_gateway/
│       ├── main.tf               # Main configuration for VPN Gateway
│       ├── variables.tf          # Variables used in VPN Gateway module
│       └── outputs.tf            # Outputs of VPN Gateway module (Public IP, VPN Gateway ID, etc.)
│
├── scripts/
│   ├── run_core.sh               # Script to initialize and apply the core infrastructure
│   ├── clean_up.sh               # Script to clean up and destroy the infrastructure
│   ├── create_identity.sh        # Script to create Service Principals (SPs) and store credentials
│   └── delete_identity.sh        # Script to delete Service Principals (SPs) and clean .env variables
│
└── .env                          # File for storing environment variables (not in version control)
```

---

## **📚 Module Descriptions**

Each module in the `infrastructure/modules/` folder is designed to manage specific Azure services. Below is a description of each module and its purpose.

---

### **1️⃣ Core Module**
**Location**: `infrastructure/core/`

#### **Files**
- **provider.tf**: Defines the providers (Azure, Random, TLS, Azure AD) used for resource provisioning.
- **main.tf**: Core configuration file to define the Azure Resource Group, Private DNS, VPN, ACR, Role Assignments, and link modules like VNet, Database, and VPN Gateway.
- **variables.tf**: Contains the list of input variables to customize the deployment.
- **outputs.tf**: Exposes useful output variables (e.g., App Service URL, VPN Public IP, Database FQDN) after the Terraform plan is applied.

#### **Resources Managed**
- **Resource Group**: Centralized logical grouping of all the cloud resources.
- **Azure Container Registry (ACR)**: Stores Docker images for the Shop App.
- **App Service**: Runs the Shop App API using the container from ACR.
- **Private DNS**: Used for private name resolution.
- **Role Assignments**: Grants roles to Service Principals (SPs) like Contributor and Owner.
- **Random Resources**: Random names, passwords, and secrets are generated.

---

### **2️⃣ Virtual Network (VNet) Module**
**Location**: `infrastructure/modules/vnet/`

#### **Files**
- **main.tf**: Contains the full configuration of the Virtual Network (VNet) and subnets.
- **variables.tf**: Input variables used to parameterize the VNet module.
- **outputs.tf**: Outputs VNet ID, Subnet IDs, and Gateway Subnet ID.

#### **Resources Managed**
- **VNet**: A logical isolation of the Azure network.
- **Subnets**: Split network into App, Database, and Gateway subnets.
- **NSG (Network Security Group)**: Security rules for inbound/outbound traffic.
- **Subnet-NSG Association**: Links the NSG to the database subnet.

---

### **3️⃣ Database Module**
**Location**: `infrastructure/modules/database/`

#### **Files**
- **main.tf**: Manages PostgreSQL Flexible Server and creates the database.
- **variables.tf**: Defines input variables for customizing the database.
- **outputs.tf**: Outputs key database information like the server FQDN, admin password, and database name.

#### **Resources Managed**
- **PostgreSQL Flexible Server**: A secure PostgreSQL database instance.
- **Database**: A database within the PostgreSQL server.
- **Private DNS**: Ensures the database is discoverable in the private network.

---

### **4️⃣ VPN Gateway Module**
**Location**: `infrastructure/modules/vpn_gateway/`

#### **Files**
- **main.tf**: Sets up the VPN Gateway and VPN NAT Rules.
- **variables.tf**: Input variables for customizing the VPN gateway.
- **outputs.tf**: Outputs the VPN Gateway Public IP, VPN Gateway ID, and VNet Gateway Subnet ID.

#### **Resources Managed**
- **VPN Gateway**: Enables secure remote access to the VNet.
- **Public IP**: Assigns a public IP address for the VPN Gateway.
- **NAT Rules**: Allows address translation for VPN clients.

---

### **5️⃣ App Service Module**
**Location**: `infrastructure/modules/app_service/`

#### **Files**
- **main.tf**: Defines the App Service Plan and the Linux Web App.
- **variables.tf**: Contains customizable input variables for the App Service.
- **outputs.tf**: Outputs the App Service URL, hostname, and ID.

#### **Resources Managed**
- **App Service Plan**: Scales the web app according to SKU (B1, P1v2, etc.).
- **Linux Web App**: Deploys the Shop App container using ACR.
- **App Settings**: Passes environment variables like PostgreSQL credentials and JWT secrets.

---

## **📜 Scripts Description**

Scripts are used for automation, setup, and cleanup of the infrastructure.

### **1️⃣ run_core.sh**
- **Purpose**: 
  - Initializes, validates, plans, and applies the **core infrastructure**.
- **Actions**:
  - Checks for required tools (Terraform, Azure CLI, etc.).
  - Checks Azure authentication.
  - Runs `terraform init`, `terraform plan`, and `terraform apply`.
  - Extracts key outputs like VPN IP, DB FQDN, and stores them as environment variables.

---

### **2️⃣ clean_up.sh**
- **Purpose**: 
  - **Completely destroys the entire infrastructure.**
- **Actions**:
  - Runs `terraform destroy` to delete all cloud resources.
  - Deletes the Service Principals (SPs) created during setup.

---

### **3️⃣ create_identity.sh**
- **Purpose**: 
  - Creates **Service Principals (SPs)** with Owner and Developer roles.
- **Actions**:
  - Checks if SPs exist. If they do, deletes them.
  - Creates Owner SP and Developer SP.
  - Stores SP credentials (App ID, Password) in the `.env` file.
  - Grants roles (Owner, Contributor) to SPs.

---

### **4️⃣ delete_identity.sh**
- **Purpose**: 
  - Deletes the **Service Principals (SPs)**.
- **Actions**:
  - Deletes the Owner SP and Developer SP.
  - Removes SP variables from the `.env` file.

---

## **📦 Key Variables**

| **Variable**      | **Description**                 |
|-------------------|----------------------------------|
| `base_rg_name`    | Name of the resource group      |
| `location`        | Azure region (e.g., francecentral)|
| `developer_object_id` | ID of the Developer Service Principal|
| `owner_object_id`     | ID of the Owner Service Principal|
| `git_repo_url`       | URL of the repository for Docker builds|
| `git_branch`         | Branch to build from (default: master)|
| `context_access_token` | GitHub token to access private repos|

---

## **📤 Outputs**

| **Output**           | **Description**                         |
|----------------------|------------------------------------------|
| `resource_group_name`| Name of the resource group              |
| `postgresql_server_name` | PostgreSQL server name               |
| `vpn_gateway_public_ip`  | Public IP of the VPN Gateway         |
| `app_service_url`       | URL of the deployed app             |
| `database_password`    | Password for the PostgreSQL database |

---