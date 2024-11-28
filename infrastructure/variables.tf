variable subscription_id {
    description = "The Azure subscription ID"
    type        = string
    sensitive   = true
}

# Resource Group Variables

variable resource_group_name {
    description = "The name of the resource group"
    type        = string
    default     = "shop-app-atnmm"
}

variable resource_group_location {
    description = "The location of the resource group"
    type        = string
    default     = "France Central"
}

# Virtual Network Variables

variable virtual_network_name {
    description = "The name of the virtual network"
    type        = string
    default     = "vnet-atnmm"
}

variable virtual_network_address_space {
    description = "The address space that is used by the virtual network"
    type        = list(string)
    default     = ["192.168.0.0/16"]
}