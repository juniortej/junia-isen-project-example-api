resource "azurerm_virtual_network" "main" {
  name                = "${var.project_name}-vnet-${var.unique_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  tags                = var.tags
}

resource "azurerm_subnet" "db_subnet" {
  name                 = "db-subnet-${var.unique_suffix}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.db_subnet_prefix]

  delegation {
    name = "db-delegation"
    service_delegation {
      name    = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_subnet" "app_subnet" {
  name                 = "app-subnet-${var.unique_suffix}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.app_subnet_prefix]
}

resource "azurerm_subnet" "gateway_subnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.gateway_subnet_prefix]
}

resource "azurerm_network_security_group" "db_nsg" {
  name                = "db-nsg-${var.unique_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "AllowPostgreSQLFromVPN"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5432"
    source_address_prefixes    = var.vpn_client_address_pool
    destination_address_prefix = azurerm_subnet.db_subnet.address_prefixes[0]
  }

  tags = var.tags
}

resource "azurerm_subnet_network_security_group_association" "db_nsg_association" {
  subnet_id                 = azurerm_subnet.db_subnet.id
  network_security_group_id = azurerm_network_security_group.db_nsg.id
}
