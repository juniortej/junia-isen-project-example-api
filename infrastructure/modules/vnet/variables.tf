variable "location" {
  description = "Azure region for the VNet"
  type        = string
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
}

variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "address_space" {
  description = "The address space for the VNet"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "db_subnet_prefix" {
  description = "Address prefix for the database subnet"
  type        = string
}

variable "app_subnet_prefix" {
  description = "Address prefix for the application subnet"
  type        = string
}

variable "gateway_subnet_prefix" {
  description = "Address prefix for the Gateway Subnet"
  type        = string
}

variable "vpn_client_address_pool" {
  description = "Address pool for VPN clients"
  type        = list(string)
}

variable "tags" {
  description = "Tags to be applied to resources"
  type        = map(string)
}
