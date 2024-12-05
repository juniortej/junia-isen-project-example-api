variable subscription_id {
  description = "The Azure subscription ID"
  type        = string
  sensitive   = true
}

# Resource Group Variables

variable resource_group_name {
  description = "The name of the resource group"
  type        = string
  default     = "shop-app-atnmm"
}

variable resource_group_location {
  description = "The location of the resource group"
  type        = string
  default     = "France Central"
}

# Virtual Network Variables

variable virtual_network_name {
  description = "The name of the virtual network"
  type        = string
  default     = "vnet-atnmm"
}

variable virtual_network_address_space {
  description = "The address space that is used by the virtual network"
  type        = list(string)
  default     = ["192.168.0.0/16"]
}

variable database_subnet_name {
  description = "The name of the database subnet"
  type        = string
  default     = "database-subnet"
}

variable database_subnet_address_space {
  description = "The address space that is used by the database subnet"
  type        = list(string)
  default     = ["192.168.1.0/24"]
}

variable python_app_subnet_name {
  description = "The name of the Python app subnet"
  type        = string
  default     = "python-app-subnet"
}

variable python_app_subnet_address_space {
  description = "The address space that is used by the Python app subnet"
  type        = list(string)
  default     = ["192.168.2.0/24"]
}

# Database Variables

variable dns_zone_name {
  description = "The name of the DNS zone"
  type        = string
  default     = "shop-app-atnmm-dns.postgres.database.azure.com"
}

variable dns_zone_link_name {
  description = "The name of the DNS zone link"
  type        = string
  default     = "shop-app-atnmm-dns"
}

variable database_admin_username {
  description = "The username of the database admin"
  type        = string
  sensitive   = true
  default     = "adminuser" // Utiliser un nom d'utilisateur valide
}

variable database_admin_password {
  description = "The password of the database admin"
  type        = string
  sensitive   = true
}

variable database_name {
  description = "The name of the database"
  type        = string
  default     = "shop-app-atnmm-db"
}

variable server_name {
  description = "The name of the database server"
  type        = string
  default     = "shop-app-atnmm-srv"
}

# Blob Storage Variables
variable storage_account_name {
  description = "The name of the storage account"
  type        = string
  default     = null
}

# App Service Variables

variable app_service_name {
  description = "The name of the App Service"
  type        = string
  default     = "bondon-grousseau-mallet-plot-python-app-service"
}

variable app_service_plan_name {
  description = "The name of the App Service Plan"
  type        = string
  default     = "python-app-service-plan"
}


locals {
  blob_storage = {
    name = "blobstorageatnmm"
  }
}
