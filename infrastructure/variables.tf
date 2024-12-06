variable "prefix" {
  description = "Prefix for naming resources"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  default     = "shop-app-rg"
}

variable "location" {
  description = "Azure region for resource deployment"
  default     = "East US"
}

variable "admin_username" {
  description = "Admin username for Azure Container Registry"
}

variable "admin_password" {
  description = "Admin password for Azure Container Registry"
}

variable "sql_server_name" {
  description = "Name of the SQL Server"
}

variable "sql_database_name" {
  description = "Name of the SQL Database"
}
