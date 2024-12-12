resource "azurerm_service_plan" "asp" {
  name                = "${var.prefix}-appserviceplan"
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type = "Linux"
  sku_name = "B1"
}

resource "azurerm_linux_web_app" "app" {
  name                = "${var.prefix}-flask-app"
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id = azurerm_service_plan.asp.id
  site_config {}
}

resource "azurerm_container_registry" "acr" {
  name                     = "${replace(var.prefix, "/[^a-zA-Z0-9]/", "")}acr"
  location                 = var.location
  resource_group_name      = var.resource_group_name
  sku                      = "Basic"
  admin_enabled            = true
}

