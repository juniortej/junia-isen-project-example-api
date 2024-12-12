resource "azurerm_virtual_network" "virtual_net" {
  name                = "vm_network"
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = ["10.123.0.0/16"]
  tags = {
    environment = "dev"
  }
}
resource "azurerm_subnet" "subnet" {
  name                 = "vm_subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.virtual_net.name
  address_prefixes     = ["10.123.1.0/24"]
}
resource "azurerm_network_security_group" "security_group" {
  name                = "vm_security"
  resource_group_name = var.resource_group_name
  location            = var.location

  tags = {
    environment = "dev"
  }
}
resource "azurerm_network_security_rule" "security_rule" {
  name                        = "vm_security_rule"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.security_group.name
}
resource "azurerm_subnet_network_security_group_association" "sga" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.security_group.id
}
resource "azurerm_public_ip" "public_ip1" {
  name                = "public_ip1"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"

  tags = {
    environment = "dev"
  }
}
resource "azurerm_network_interface" "net_int" {
  name                = "network_interface"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip1.id
  }
  tags = {
    environment = "dev"
  }
}