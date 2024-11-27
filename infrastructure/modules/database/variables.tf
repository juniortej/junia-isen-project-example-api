variable "location" {
  description = "Azure region for the database"
  type        = string
  default     = "France Central"
  validation {
    condition     = contains(["France Central", "West Europe", "North Europe"], var.location)
    error_message = "The location must be one of 'France Central', 'West Europe', or 'North Europe'."
  }
}

variable "resource_group_name" {
  description = "Resource group where the database will be created"
  type        = string
  validation {
    condition     = length(var.resource_group_name) > 0
    error_message = "Resource group name cannot be empty."
  }
}

variable "unique_suffix" {
  description = "Unique suffix for resource naming"
  type        = string
}

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "default-project"
  validation {
    condition     = length(var.project_name) > 0
    error_message = "Project name cannot be empty."
  }
}

variable "admin_username" {
  description = "Administrator username for PostgreSQL server"
  type        = string
  default     = "postgres_admin"
  validation {
    condition     = length(var.admin_username) > 3
    error_message = "Administrator username must be at least 4 characters."
  }
}

variable "admin_password" {
  description = "Administrator password for PostgreSQL server"
  type        = string
  sensitive   = true
  validation {
    condition     = length(var.admin_password) >= 8
    error_message = "Administrator password must be at least 8 characters."
  }
}

variable "subnet_id" {
  description = "ID of the subnet where the database will be deployed"
  type        = string
  validation {
    condition     = length(var.subnet_id) > 0
    error_message = "Subnet ID cannot be empty."
  }
}

variable "private_dns_zone_id" {
  description = "ID of the private DNS zone for the database"
  type        = string
  validation {
    condition     = length(var.private_dns_zone_id) > 0
    error_message = "Private DNS Zone ID cannot be empty."
  }
}

variable "environment" {
  description = "Environment tag (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of 'dev', 'staging', or 'prod'."
  }
}
