
# virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}vnet"
  location            = var.location
  address_space       = ["10.0.0.0/16"]
  resource_group_name = var.rg-name
}
#subnets
resource "azurerm_subnet" "public-subnet" {
  name                 = "${var.prefix}public-subnet"
  resource_group_name  = var.rg-name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/24"]
  depends_on = [
    azurerm_virtual_network.vnet
  ]
}

resource "azurerm_subnet_network_security_group_association" "public-nsg-association" {
  subnet_id                 = azurerm_subnet.public-subnet.id
  network_security_group_id = var.WebTierNSG_id
}

resource "azurerm_subnet" "private-subnet" {
  name                 = "${var.prefix}private-subnet"
  resource_group_name  = var.rg-name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]

  delegation {
    name = "fs"
    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "private-nsg-association" {
  subnet_id                 = azurerm_subnet.private-subnet.id
  network_security_group_id = var.DataTierNSG_id
}

#IP address
resource "azurerm_public_ip" "pip" {
  name                = "${var.prefix}PublicIPForLB"
  location            = var.location
  resource_group_name = var.rg-name
  allocation_method   = "Static"
  sku                 = "Standard"
}

#load balancer
resource "azurerm_lb" "lb" {
  name                = "${var.prefix}loadbalancer"
  location            = var.location
  resource_group_name = var.rg-name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "${var.prefix}lb-frontend-ip"
    public_ip_address_id = azurerm_public_ip.pip.id
  }

  depends_on = [
    azurerm_public_ip.pip
  ]
}

resource "azurerm_availability_set" "aset" {
  name                = "${var.prefix}aset"
  location            = var.location
  resource_group_name = var.rg-name

}

resource "azurerm_lb_backend_address_pool" "lb-backend-address-pool" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "${var.prefix}BackEndAddressPool"

  depends_on = [
    azurerm_lb.lb
  ]
}

resource "azurerm_lb_backend_address_pool_address" "add-pool-add" {
  count                   = var.instance_count
  name                    = "${var.prefix}webserver-${count.index}"
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb-backend-address-pool.id
  virtual_network_id      = azurerm_virtual_network.vnet.id
  ip_address              = azurerm_network_interface.main[count.index].private_ip_address

  depends_on = [
    azurerm_lb_backend_address_pool.lb-backend-address-pool
  ]
}

resource "azurerm_lb_probe" "lb-probe" {
  resource_group_name = var.rg-name
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "http-probe"
  protocol            = "Http"
  request_path        = "/"
  port                = 8080

  depends_on = [
    azurerm_lb.lb
  ]
}


resource "azurerm_lb_rule" "lb-rule" {
  loadbalancer_id                = azurerm_lb.lb.id
  resource_group_name            = var.rg-name
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 8080
  backend_port                   = 8080
  frontend_ip_configuration_name = "${var.prefix}lb-frontend-ip"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.lb-backend-address-pool.id]
  probe_id                       = azurerm_lb_probe.lb-probe.id

  depends_on = [
    azurerm_lb.lb,
    azurerm_lb_probe.lb-probe
  ]
}