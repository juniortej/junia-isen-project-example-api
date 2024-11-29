resource "azurerm_app_service_plan" "app_service_plan" {
  name                = var.app_service_plan_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  sku {
    tier = "Basic"
    size = var.app_service_sku
  }
}

resource "azurerm_app_service" "app_service" {
  name                = var.app_service_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  app_service_plan_id = azurerm_app_service_plan.app_service_plan.id
  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
  }
  site_config {
    linux_fx_version = "PYTHON|3.8"
  }
}
