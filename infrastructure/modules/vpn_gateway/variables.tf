variable "location" {
  description = "Azure region for the VPN Gateway"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group where the VPN Gateway will be created"
  type        = string
}

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
}

variable "unique_suffix" {
  description = "Unique suffix for resource naming"
  type        = string
}

variable "tags" {
  description = "Tags to be applied to resources"
  type        = map(string)
}

variable "gateway_subnet_id" {
  description = "ID of the Gateway Subnet"
  type        = string
}

variable "vpn_client_address_pool" {
  description = "Address pool for VPN clients"
  type        = list(string)
}

variable "vpn_client_root_certificate_public_cert_data" {
  description = "Public certificate data for VPN client authentication"
  type        = string
}

variable "vnet_address_space" {
  description = "Address space of the Virtual Network"
  type        = list(string)
}
