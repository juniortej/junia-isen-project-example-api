variable "location" {
  description = "The Azure region to deploy resources"
  default     = "East US"
}

variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  default     = "shop-app-rg"
}

variable "app_service_plan_name" {
  description = "Name of the App Service Plan"
  default     = "shop-app-plan"
}

variable "app_service_plan_tier" {
  description = "The pricing tier for the App Service Plan"
  default     = "Basic"
}

variable "app_service_plan_size" {
  description = "The size of the App Service Plan"
  default     = "B1"
}

variable "app_service_name" {
  description = "Name of the App Service"
  default     = "shop-app"
}

variable "docker_registry_username" {
  description = "Username for the Docker registry"
}

variable "docker_registry_password" {
  description = "Password for the Docker registry"
}
