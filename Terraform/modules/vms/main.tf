resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}${count.index}"
  count               = var.instance_count
  location            = var.location
  resource_group_name = var.rg-name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.public-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}
# Create a new Virtual Machine
resource "azurerm_linux_virtual_machine" "vm" {
  name                            = "${var.prefix}webserver-${count.index}"
  count                           = var.instance_count
  location                        = var.location
  resource_group_name             = var.rg-name
  network_interface_ids           = [azurerm_network_interface.main[count.index].id]
  size                            = var.vm_size
  admin_username                  = var.admin-user
  admin_password                  = var.admin-password
  disable_password_authentication = false
  availability_set_id             = azurerm_availability_set.aset.id
  #delete_os_disk_on_termination    = true
  #delete_data_disks_on_termination = true


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