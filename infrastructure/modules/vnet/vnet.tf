# modules/vnet/vnet.tf

# Create the Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = "${var.project_name}-vnet-${var.unique_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  tags                = var.tags
}

# Create the Database Subnet
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

# Create the Application Subnet
resource "azurerm_subnet" "app_subnet" {
  name                 = "app-subnet-${var.unique_suffix}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.app_subnet_prefix]
}

# Create the Gateway Subnet
resource "azurerm_subnet" "gateway_subnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.gateway_subnet_prefix]
}

# Create the Network Security Group for the Database Subnet
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
    source_address_prefix      = var.vpn_client_address_pool[0]
    destination_address_prefix = "*"
  }

  tags = var.tags
}

# Associate the NSG with the Database Subnet
resource "azurerm_subnet_network_security_group_association" "db_nsg_association" {
  subnet_id                 = azurerm_subnet.db_subnet.id
  network_security_group_id = azurerm_network_security_group.db_nsg.id
}
