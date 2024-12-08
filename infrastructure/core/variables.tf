variable "location" {
  description = "Azure region for the resources"
  type        = string
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment tag (e.g., dev, staging, prod)"
  type        = string
}

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

variable "vnet_address_space" {
  description = "Address space of the Virtual Network"
  type        = list(string)
}

variable "db_subnet_prefix" {
  description = "CIDR prefix for the Database Subnet"
  type        = string
}

variable "app_subnet_prefix" {
  description = "CIDR prefix for the Application Subnet"
  type        = string
}

variable "gateway_subnet_prefix" {
  description = "CIDR prefix for the Gateway Subnet"
  type        = string
}

variable "vpn_client_address_pool" {
  description = "Address pool for VPN clients"
  type        = list(string)
}

variable "vpn_client_root_certificate_public_cert_data" {
  description = "Public certificate data for VPN client root certificate in base64"
  type        = string
}

variable "key_vault_object_id" {
  description = "The Object ID of the principal that will have access to the Key Vault"
  type        = string
}

# Variables for Backend Reference
variable "tfstate_rg_name" {
  description = "Name of the resource group containing the Terraform state"
  type        = string
}

variable "tfstate_storage_account_name" {
  description = "Name of the storage account containing the Terraform state"
  type        = string
}

variable "tfstate_container_name" {
  description = "Name of the container holding the Terraform state"
  type        = string
}

variable "tags" {
  description = "A map of tags to apply to resources"
  type        = map(string)
  default     = {}
}
