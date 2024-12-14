variable "resource_group_name" {
  description = "The name of the Resource Group in which to create the App Service."
  type        = string
}

variable "location" {
  description = "The Azure location where the App Service will be deployed."
  type        = string
}

variable "project_name" {
  description = "Project name used for resource naming."
  type        = string
}

variable "unique_suffix" {
  description = "A unique suffix for resource naming."
  type        = string
}

variable "environment" {
  description = "Environment tag (e.g. dev, staging, prod)."
  type        = string
}

variable "app_service_plan_sku" {
  description = "The SKU for the App Service Plan (e.g., B1, P1v2, etc.)."
  type        = string
  default     = "B1"
}

variable "app_service_name" {
  description = "The name of the App Service."
  type        = string
}

variable "container_image_name" {
  description = "The full name of the Docker image (e.g., 'nginx', 'myregistry.azurecr.io/myapp')."
  type        = string
  default = "shop-app"
}

variable "container_image_tag" {
  description = "The Docker image tag."
  type        = string
  default     = "latest"
}

variable "env_vars" {
  description = "A map of environment variables to set in the App Service."
  type        = map(string)
  default     = {}
}
