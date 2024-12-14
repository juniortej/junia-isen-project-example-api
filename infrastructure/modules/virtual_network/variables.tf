variable "vnet_name" {
  description = "The name of the virtual network (VNet) to be created."
  type        = string
}

variable "address_space" {
  description = "The list of address spaces to assign to the virtual network (e.g., ['10.0.0.0/16'])."
  type        = list(string)
}

variable "location" {
  description = "The Azure region where the virtual network and associated resources will be deployed."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the Azure resource group where the virtual network and its resources will be created."
  type        = string
}

variable "subnet_name" {
  description = "The name of the subnet to be created within the virtual network."
  type        = string
}

variable "subnet_address_prefixes" {
  description = "The list of address prefixes to assign to the subnet (e.g., ['10.0.1.0/24'])."
  type        = list(string)
}
