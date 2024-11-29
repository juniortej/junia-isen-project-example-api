variable "virtual_network_name" {
  description = "The name of the virtual network"
  type        = string
}

variable "virtual_network_address_space" {
  description = "The address space that is used by the virtual network"
  type        = list(string)
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "resource_group_location" {
  description = "The location of the resource group"
  type        = string
}

variable "database_subnet_name" {
  description = "The name of the database subnet"
  type        = string
}

variable "database_subnet_address_space" {
  description = "The address space that is used by the database subnet"
  type        = list(string)
}

variable "python_app_subnet_name" {
  description = "The name of the Python app subnet"
  type        = string
}

variable "python_app_subnet_address_space" {
  description = "The address space that is used by the Python app subnet"
  type        = list(string)
}