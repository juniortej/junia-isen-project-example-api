provider "azurerm" {
  features {}
  subscription_id = "9e01d033-be6a-400c-91a9-6376a10e4f16"
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# App Service Plan for Linux (Docker)
resource "azurerm_app_service_plan" "asp" {
  name                = "${var.prefix}-appserviceplan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Basic"
    size = "B1"
  }
}

# Azure Container Registry (ACR)
resource "azurerm_container_registry" "acr" {
  name                     = "${replace(var.prefix, "/[^a-zA-Z0-9]/", "")}acr"
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  sku                      = "Basic"
  admin_enabled            = true
}

# App Service with Docker Image from ACR
resource "azurerm_app_service" "app" {
  name                = "${var.prefix}-flask-app"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.asp.id

  site_config {
    linux_fx_version = "DOCKER|${azurerm_container_registry.acr.login_server}/${var.prefix}:latest"
  }

  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    "DOCKER_REGISTRY_SERVER_URL"          = azurerm_container_registry.acr.login_server
    "DOCKER_REGISTRY_SERVER_USERNAME"     = azurerm_container_registry.acr.admin_username
    "DOCKER_REGISTRY_SERVER_PASSWORD"     = azurerm_container_registry.acr.admin_password
  }
}

# Output for container registry login server and App Service URL
output "acr_login_server" {
  description = "Login server URL for the Azure Container Registry"
  value       = azurerm_container_registry.acr.login_server
}

output "app_service_url" {
  description = "URL of the deployed Azure App Service"
  value       = azurerm_app_service.app.default_site_hostname
}
