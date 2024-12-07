variable "location" {
  description = "Azure region for the resources"
  type        = string
  default     = "francecentral"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "junia-shop2024"
}

variable "database_name" {
  description = "Name of the PostgreSQL database"
  type        = string
  default     = "app_db"
}

variable "admin_username" {
  description = "Administrator username for PostgreSQL server"
  type        = string
  default     = "postgres_admin"
}

variable "admin_password" {
  description = "Administrator password for PostgreSQL server"
  type        = string
  sensitive   = true
}

variable "environment" {
  description = "Environment tag (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "vpn_client_address_pool" {
  description = "Address pool for VPN clients"
  type        = list(string)
  default     = ["172.16.0.0/16"]
}

variable "vnet_address_space" {
  description = "Address space of the Virtual Network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "vpn_client_root_certificate_public_cert_data" {
  description = "Public certificate data for VPN client authentication in base64 encoding"
  type        = string
}
