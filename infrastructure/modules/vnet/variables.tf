variable "location" {
  description = "Azure region for the VNet"
  type        = string
  default     = "France Central"
  validation {
    condition     = contains(["France Central", "West Europe", "North Europe"], var.location)
    error_message = "The location must be one of 'France Central', 'West Europe', or 'North Europe'."
  }
}

variable "unique_suffix" {
  description = "Unique suffix for resource naming"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group where the VNet will be created"
  type        = string
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

variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "junia-shop2024"
  validation {
    condition     = length(var.project_name) > 0
    error_message = "Project name cannot be empty."
  }
}

variable "address_space" {
  description = "The address space for the VNet"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "db_subnet_prefix" {
  description = "Address prefix for the database subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "app_subnet_prefix" {
  description = "Address prefix for the application subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "enable_nsg" {
  description = "Enable Network Security Group (NSG) rules for subnets"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to be applied to resources"
  type        = map(string)
  default     = {
    environment = "dev"
    project     = "junia-shop2024"
  }
}
