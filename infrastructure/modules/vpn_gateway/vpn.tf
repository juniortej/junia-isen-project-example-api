# modules/vpn_gateway/vpn.tf

resource "azurerm_public_ip" "vpn_gateway_ip" {
  name                = "${var.project_name}-vpn-pip-${var.unique_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_virtual_network_gateway" "vpn_gateway" {
  name                = "${var.project_name}-vpngw-${var.unique_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false

  sku = "VpnGw1"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.vpn_gateway_ip.id
    subnet_id                     = var.gateway_subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  vpn_client_configuration {
    address_space = var.vpn_client_address_pool

    root_certificate {
      name             = "rootcert"
      public_cert_data = var.vpn_client_root_certificate_public_cert_data
    }

    revoked_certificate {
      name       = "RevokedCert"
      thumbprint = "F87C34A15E29DD08B67E74B16B51C8A9A7D60C1B"
    }

    vpn_client_protocols = ["OpenVPN"]
  }

  tags = var.tags
}

data "azurerm_virtual_network_gateway" "vpn_gateway" {
  name                = azurerm_virtual_network_gateway.vpn_gateway.name
  resource_group_name = azurerm_virtual_network_gateway.vpn_gateway.resource_group_name
}

resource "azurerm_virtual_network_gateway_nat_rule" "vpn_nat_rule" {
  name                       = "vpn-nat-rule-${var.unique_suffix}" 
  resource_group_name        = var.resource_group_name
  virtual_network_gateway_id = azurerm_virtual_network_gateway.vpn_gateway.id
  mode                       = "EgressSnat"
  type                       = "Static"
  # ip_configuration_id        = data.azurerm_virtual_network_gateway.vpn_gateway.ip_configuration[0].id

  external_mapping {
    address_space = var.vpn_client_address_pool[0]
    port_range    = "200"
  }

  internal_mapping {
    address_space = var.vnet_address_space[0]
    port_range    = "400"
  }
}
