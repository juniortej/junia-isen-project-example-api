variable "sql_server_name" {
  description = "Name of the SQL Server"
}

variable "sql_database_name" {
  description = "Name of the SQL Database"
}

variable "admin_username" {
  description = "Admin username for the SQL Server"
}

variable "admin_password" {
  description = "Admin password for the SQL Server"
}

variable "sql_sku_name" {
  description = "SKU Name for the SQL Database"
}

variable "resource_group_name" {
  description = "Azure Resource Group for the SQL Database"
}

variable "location" {
  description = "Location for the SQL Database"
}
