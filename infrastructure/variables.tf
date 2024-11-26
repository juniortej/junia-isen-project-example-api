variable "location" {
  description = "Azure region for the resources"
  type        = string
  default     = "France Central"
  validation {
    condition     = contains(["France Central", "West Europe", "North Europe"], var.location)
    error_message = "The location must be one of 'France Central', 'West Europe', or 'North Europe'."
  }
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "junia-shop2024"
  validation {
    condition     = length(var.project_name) > 0
    error_message = "Project name cannot be empty."
  }
}

variable "admin_username" {
  description = "Administrator username for PostgreSQL server"
  type        = string
  default     = "Amiche"
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

variable "environment" {
  description = "Environment tag (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of 'dev', 'staging', or 'prod'."
  }
}
