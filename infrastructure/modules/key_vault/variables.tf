variable "location" {
  description = "Azure region for the Key Vault"
  type        = string
}

variable "unique_suffix" {
  description = "Unique suffix for resource naming"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group where the Key Vault will be created"
  type        = string
}

variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "admin_password" {
  description = "Administrator password for PostgreSQL server"
  type        = string
  sensitive   = true
}

variable "admin_username" {
  description = "Administrator username for PostgreSQL server"
  type        = string
}

variable "database_name" {
  description = "Name of the PostgreSQL database"
  type        = string
}

variable "vpn_client_root_certificate_public_cert_data" {
  description = "VPN client root certificate public cert data"
  type        = string
}

variable "tags" {
  description = "Tags to be applied to resources"
  type        = map(string)
}

variable "object_id" {
  description = "The Object ID of the Service Principal or Managed Identity that will access the Key Vault"
  type        = string
}
