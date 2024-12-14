resource "azurerm_service_plan" "main" {
  name                = "${var.project_name}-sp-${var.unique_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  
  sku_name = var.app_service_plan_sku

  tags = {
    environment = var.environment
  }
}

resource "azurerm_linux_web_app" "main" {
  name                = var.app_service_name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.main.id
  
  site_config {
    linux_fx_version = "DOCKER|${var.container_image_name}:${var.container_image_tag}"
  }

  app_settings = merge(
    {
      "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    },
    var.env_vars
  )

  tags = {
    environment = var.environment
  }
}
