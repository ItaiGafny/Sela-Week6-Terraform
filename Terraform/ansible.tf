
#IP address
resource "azurerm_public_ip" "ansible-pip" {
  name                = "${var.prefix[terraform.workspace]}PublicIPForAnsible"
  location            = local.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "ansible-nic" {
  name                = "${var.prefix[terraform.workspace]}ansible"
  location            = local.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ansible-ip"
    subnet_id                     = module.vms.public-subnet-id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ansible-pip.id
  }
}
# Create a new Virtual Machine
resource "azurerm_linux_virtual_machine" "vm" {
  name                            = "${var.prefix[terraform.workspace]}vm-ansible"
  location                        = local.location
  resource_group_name             = azurerm_resource_group.rg.name
  network_interface_ids           = [azurerm_network_interface.ansible-nic.id]
  size                            = var.vm_size[terraform.workspace]
  admin_username                  = var.admin-user
  admin_password                  = var.admin-password
  disable_password_authentication = false


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal" #"UbuntuServer"
    sku       = "20_04-lts-gen2"               #"20.04-LTS"
    version   = "latest"
  }
}