resource "azurerm_service_plan" "app_service_plan" {
  name                = var.app_service_plan_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  os_type = "Linux"
  sku_name = "P0v3"
}

resource "azurerm_linux_web_app" "app_service" {
  name                = var.app_service_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  service_plan_id = azurerm_service_plan.app_service_plan.id
  app_settings = merge(var.app_settings, {
    "NEW_RELIC_LICENSE_KEY" = var.new_relic_license_key
  })

  virtual_network_subnet_id = var.subnet_id

  identity {
    type = "SystemAssigned"
  }

  site_config {

    application_stack {
      docker_registry_url = var.docker_registry_url
      docker_image_name   = var.docker_image
    }

    ip_restriction {
      name       = "Allow-Gateway-IP"
      ip_address = "${var.gateway_ip}/32"
      priority   = 1
      action     = "Allow"
    }

    ip_restriction_default_action = "Deny"
  }

  depends_on = [ azurerm_service_plan.app_service_plan ]
}
