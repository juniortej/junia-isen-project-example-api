# 🌐 **Azure Infrastructure Deployment Guide** 🌐

---

## 🚀 **Overview**

This repository contains **Terraform configurations** and **Bash scripts** to deploy a fully functional **Azure cloud infrastructure**. The deployment follows a modular structure with two main layers:

1. **🔹 Base Layer**: Sets up the foundational resources required to manage infrastructure.  
   - 🌐 **Resource Group**: For backend infrastructure.  
   - 📦 **Storage Account & Container**: For Terraform state storage.  
   - 🔐 **Key Vault**: For managing sensitive information.  
   - 👤 **Azure AD User**: A user for GitHub Actions with the **Contributor role**.

2. **🔹 Core Layer**: Deploys the primary application infrastructure.  
   - 🌐 **Virtual Network (VNet) & Subnets**: Segregated subnets for application and database.  
   - 🗄️ **PostgreSQL Flexible Server**: Database for the application.  
   - 🔐 **Key Vault**: For securely storing app secrets, VPN certs, and DB credentials.  
   - 🌉 **VPN Gateway**: For secure remote access.  

The **scripts** folder contains useful **Bash scripts** to automate deployments, certificate generation, and cleanup processes.

---

## 📁 **Folder Structure**

```
📁 infrastructure
├── 📁 base
│   ├── main.tf
│   ├── provider.tf
│   ├── variables.tf
│   └── outputs.tf
│
├── 📁 core
│   ├── main.tf
│   ├── provider.tf
│   ├── variables.tf
│   └── outputs.tf
│
├── 📁 modules
│   ├── 📁 vnet
│   │    ├── vnet.tf
│   │    ├── variables.tf
│   │    └── outputs.tf
│   ├── 📁 database
│   │    ├── database.tf
│   │    ├── variables.tf
│   │    └── outputs.tf
│   ├── 📁 vpn_gateway
│   │    ├── vpn.tf
│   │    ├── variables.tf
│   │    └── outputs.tf
│   ├── 📁 app_service
│   │    ├── app.tf
│   │    ├── variables.tf
│   │    └── outputs.tf
│   └── 📁 key_vault
│        ├── key_vault.tf
│        ├── variables.tf
│        └── outputs.tf
│
├── 📁 scripts
│   ├── generate_certificates.sh
│   ├── deploy.sh
│   ├── destroy.sh
│   ├── run_base.sh
│   └── run_core.sh
│
├── README.md
```

---

## 📋 **Prerequisites**

Before starting, make sure you have the following tools installed and configured:

- **📘 Azure CLI**:  
  ```sh
  az login
  ```

- **📗 Terraform**:  
  Install **Terraform v1.x or later**. [Download Terraform](https://www.terraform.io/downloads.html)

- **📙 OpenSSL**:  
  Required for generating VPN certificates.  
  - **Linux (Debian/Ubuntu)**:
    ```sh
    sudo apt-get install openssl
    ```
  - **macOS (via Homebrew)**:
    ```sh
    brew install openssl
    ```
  - **Windows**:
    - Download from [OpenSSL for Windows](https://slproweb.com/products/Win32OpenSSL.html)

- **🔐 Azure Tenant Domain** & **Subscription**:  
  Your **Azure Tenant Domain** (e.g., `yourtenant.onmicrosoft.com`) and a valid subscription with proper permissions.

---

## ⚙️ **Deployment Workflow**

### **1️⃣ Configure Base Layer Variables**

Edit `infrastructure/base/variables.tf` and set:

```hcl
variable "tfstate_rg_name" {
  description = "Name of the Resource Group for Terraform backend"
  type        = string
  default     = "juniashop-rg"
}

variable "tfstate_sa_name" {
  description = "Prefix for the Storage Account name"
  type        = string
  default     = "juniashop"
}

variable "azure_tenant_domain" {
  description = "Azure tenant domain (e.g., yourtenant.onmicrosoft.com)"
  type        = string
}
```

---

### **2️⃣ Deploy Base Layer**

Run the base deployment script:

```sh
cd infrastructure/scripts
./run_base.sh
```

🛠️ **What it does:**
- Creates **Resource Group**, **Storage Account**, **Container**, **Key Vault**, and an **Azure AD user**.  
- The **Azure AD user** will be used by **GitHub Actions** to deploy infrastructure later.  

🔍 **Key Outputs:**
- `github_action_user_principal_name`: User Principal Name for GitHub Action user.  
- `key_vault_name`: The Key Vault name.  

---

### **3️⃣ Generate and Store VPN Certificates**

Generate and store the VPN root certificate in the **Key Vault**:

```sh
cd infrastructure/scripts
./generate_certificates.sh
```

📜 **What it does:**
- Generates a **self-signed VPN root certificate**.  
- Converts it to Base64.  
- Stores it in the Key Vault as `vpn-client-root-cert-data`.  

---

### **4️⃣ Configure Core Layer Variables**

Set variables in `infrastructure/core/variables.tf`. Here are some key variables to set:

```hcl
variable "admin_username" {
  description = "Administrator username for PostgreSQL server"
  type        = string
}

variable "admin_password" {
  description = "Administrator password for PostgreSQL server"
  type        = string
  sensitive   = true
}

variable "database_name" {
  description = "Name of the PostgreSQL database"
  type        = string
}

variable "vpn_client_root_certificate_public_cert_data" {
  description = "Public cert data for VPN"
  type        = string
}
```

---

### **5️⃣ Deploy Core Layer**

Deploy the core infrastructure using the script:

```sh
cd infrastructure/scripts
./run_core.sh
```

🔍 **What it does:**
- Deploys **VNet**, **Subnets**, **PostgreSQL DB**, **VPN Gateway**, and **Key Vault**.  

📋 **Important Outputs:**
- `postgresql_server_name`  
- `postgresql_server_fqdn`  
- `vpn_gateway_public_ip`  
- `key_vault_name`  

---

### **6️⃣ Accessing Resources**

🔐 **PostgreSQL**:  
- **Host**: `postgresql_server_fqdn`  
- **Database**: `postgresql_database_name`  
- **User**: `postgresql_administrator_login`  
- **Password**: Retrieved from Key Vault.  

🔐 **VPN Gateway**:  
- **Public IP**: `vpn_gateway_public_ip`  
- **Client Certificate**: Available as `vpn-client-root-cert-data` in the Key Vault.  

---

### **7️⃣ Destroy Infrastructure**

To clean up all resources:

```sh
cd infrastructure/scripts
./destroy.sh
```

🛠️ **What it does:**
- Destroys core infrastructure first.  
- Then destroys base infrastructure.  

---

## 📜 **Scripts Breakdown**

| 📄 **Script**                | 🔧 **Functionality**                          |
|-----------------------------|-----------------------------------------------|
| `run_base.sh`               | Deploys **Base Layer** infrastructure         |
| `run_core.sh`               | Deploys **Core Layer** infrastructure         |
| `generate_certificates.sh`  | Generates VPN certificates                    |
| `deploy.sh`                 | Runs both **Base and Core layers**            |
| `destroy.sh`                | Destroys all infrastructure (core & base)    |

---

## 📢 **Tips & Troubleshooting**

💡 **State Backend**:  
- Ensure `tfstate_rg_name`, `tfstate_sa_name`, and `tfstate_container_name` match **base layer outputs**.  

💡 **Authentication**:  
- Run `az login` before executing any scripts.  
- Ensure Azure AD user has proper permissions on **Key Vault** and **Subscription**.  

💡 **Variable Changes**:  
- If you change variables, re-run **`run_base.sh`** or **`run_core.sh`**.  

💡 **OpenSSL Errors**:  
- Run `openssl version` to ensure it's installed.  
- On macOS, you might need to link it:  
  ```sh
  brew link openssl --force
  ```

---

## 📚 **Resources**

- **[Terraform Docs](https://www.terraform.io/docs)**  
- **[Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)**  
- **[Azure CLI Docs](https://docs.microsoft.com/cli/azure)**  
- **[OpenSSL](https://www.openssl.org/)**  

---

🎉 **Congratulations!** You've just built a complete Azure infrastructure using a **modular, reusable, and maintainable design**. For any questions or issues, feel free to reach out.