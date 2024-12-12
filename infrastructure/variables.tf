variable "resource_group_name" {
  default = "rg" # Name of the Resource Group
}

variable "location" {
  default = "France Central" # Set to France Central
}

variable "prefix" {
  default = "flask-api" # Prefix for resource names
}

variable "sql_server_name" {
  description = "The name of the SQL server"
  type        = string
}

variable "sql_database_name" {
  description = "The name of the SQL database"
  type        = string
}

variable "admin_username" {
  description = "The admin username for the SQL server"
  type        = string
}

variable "admin_password" {
  description = "The admin password for the SQL server"
  type        = string
}

variable "storage_account_name" {
  description = "The name of the storage account"
  type        = string
}
variable "storage_container_name" {
  description = "The name of the storage container"
  type        = string
}

variable "storage_blob_name" {
  description = "The name of the storage blob"
  type        = string
}

variable "storage_blob_source" {
  description = "The source file for the storage blob"
  type        = string
}