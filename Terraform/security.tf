resource "azurerm_network_security_group" "WebTierNSG" {
  name                = "${local.prefix}WebTierNSG"
  location            = local.location
  resource_group_name = local.rg-name

  security_rule {
    name                       = "Port_8080"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "Port_22"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "77.137.78.94"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "DataTierNSG" {
  name                = "${local.prefix}DataTierNSG"
  location            = local.location
  resource_group_name = local.rg-name

  # security_rule {
  #   name                       = "Port_5432"
  #   priority                   = 110
  #   direction                  = "Inbound"
  #   access                     = "Allow"
  #   protocol                   = "Tcp"
  #   source_port_range          = "*"
  #   destination_port_range     = "5432"
  #   source_address_prefix      = "10.0.0.4"
  #   destination_address_prefix = "*"
  # }
}


