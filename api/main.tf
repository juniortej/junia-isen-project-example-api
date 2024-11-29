provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "cloud_project_ressource_group" {
  name     = "ourCloudProjectResourceGroup"
  location = "France Central"
}

resource "azurerm_app_service_plan" "cloud_project_service_plan" {
  name                = "ourCloudProjectAppServicePlan"
  location            = azurerm_resource_group.cloud_project_ressource_group.location
  resource_group_name = azurerm_resource_group.cloud_project_ressource_group.name
  sku {
    tier = "Free"
    size = "F1"
  }
  os_type = "Linux"
}

resource "azurerm_app_service" "cloud_project_app_service" {
  name                = "ourCloudProjectAppService"
  location            = azurerm_resource_group.cloud_project_ressource_group.location
  resource_group_name = azurerm_resource_group.cloud_project_ressource_group.name
  app_service_plan_id = azurerm_app_service_plan.cloud_project_service_plan.id
  site_config {
    linux_fx_version = "PYTHON|3.8"
  }
  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    "PORT" = "8000"
  }
}