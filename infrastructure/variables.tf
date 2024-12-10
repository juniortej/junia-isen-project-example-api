variable "prefix" {
  description = "Prefix for naming resources"
  default     = "shopapp"
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
  description = "Admin username for Azure SQL Database and ACR"
}

variable "admin_password" {
  description = "Admin password for Azure SQL Database and ACR"
}

variable "sql_server_name" {
  description = "Name of the SQL Server"
  default     = "shop-sql-server"
}

variable "sql_database_name" {
  description = "Name of the SQL Database"
  default     = "shopdb"
}

variable "storage_account_name" {
  description = "Name of the Azure Storage Account"
  default     = "shopstorageacct"
}
