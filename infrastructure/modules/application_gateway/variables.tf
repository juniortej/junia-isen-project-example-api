
variable "application_gateway_name" {
  description = "The name of the Application Gateway"
  type        = string
}

variable "application_gateway_sku" {
  description = "The SKU of the Application Gateway"
  type        = string
}

variable "application_gateway_capacity" {
  description = "The capacity of the Application Gateway"
  type        = number
}

variable "application_gateway_frontend_ip_configuration" {
  description = "The frontend IP configuration for the Application Gateway"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "resource_group_location" {
  description = "The location of the resource group"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet"
  type        = string
}

variable "backend_fqdn" {
  description = "The backend FQDN"
  type        = string
}