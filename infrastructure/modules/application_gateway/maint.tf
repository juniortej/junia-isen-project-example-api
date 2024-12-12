resource "azurerm_public_ip" "app_gateway_public_ip" {
  name                = "${var.application_gateway_name}-public-ip"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_application_gateway" "app_gateway" {
  name                = var.application_gateway_name
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  sku {
    name     = var.application_gateway_sku
    tier     = var.application_gateway_sku
    capacity = var.application_gateway_capacity
  }
  gateway_ip_configuration {
    name      = "appGatewayIpConfig"
    subnet_id = var.subnet_id
  }
  frontend_ip_configuration {
    name                 = var.application_gateway_frontend_ip_configuration
    public_ip_address_id = azurerm_public_ip.app_gateway_public_ip.id
  }
  frontend_port {
    name = "frontendPort"
    port = 80
  }
  backend_address_pool {
    name = "backendAddressPool"
    fqdns = [var.backend_fqdn]
  }
  backend_http_settings {
    name                  = "backendHttpsSettings"
    cookie_based_affinity = "Disabled"
    port                  = 443
    protocol              = "Https"
    request_timeout       = 20
    pick_host_name_from_backend_address = true
  }
  http_listener {
    name                           = "httpListener"
    frontend_ip_configuration_name = var.application_gateway_frontend_ip_configuration
    frontend_port_name             = "frontendPort"
    protocol                       = "Http"
  }
  request_routing_rule {
    name                       = "rule1"
    rule_type                  = "Basic"
    http_listener_name         = "httpListener"
    backend_address_pool_name  = "backendAddressPool"
    backend_http_settings_name = "backendHttpsSettings"
    priority                   = 1
  }

  enable_http2 = true

  depends_on = [azurerm_public_ip.app_gateway_public_ip]
}