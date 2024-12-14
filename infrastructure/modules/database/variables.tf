variable "location" {
  description = "Azure region for the database"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group where the database will be created"
  type        = string
}

variable "unique_suffix" {
  description = "Unique suffix for resource naming"
  type        = string
}

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
}

variable "database_name" {
  description = "Name of the PostgreSQL database"
  type        = string
}

variable "admin_username" {
  description = "Administrator username for PostgreSQL server"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet where the database will be deployed"
  type        = string
}

variable "private_dns_zone_id" {
  description = "The ID of the Private DNS Zone for PostgreSQL Flexible Server."
  type        = string
}

variable "environment" {
  description = "Environment tag (e.g., dev, staging, prod)"
  type        = string
}

variable "admin_password" {
  description = "Administrator password for PostgreSQL server"
  type        = string
  sensitive   = true
}

variable "database_password" {
  description = "Password for the PostgreSQL database"
  type        = string
  sensitive   = true
}
