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
