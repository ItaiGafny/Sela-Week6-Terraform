output "instance_count" {
  value = var.instance_count
}

output "vm_user" {
  value = "using sshkey from image, will user password next week..."
}

output "load_balancer_public_ip_address" {
  value = azurerm_public_ip.pip.ip_address
}

output "vnet-id" {
  value = azurerm_virtual_network.vnet.id
}
output "vnet-name" {
  value = azurerm_virtual_network.vnet.name
}

output "private-subnet-id" {
  value = azurerm_subnet.private-subnet.id
}
output "public-subnet-id" {
  value = azurerm_subnet.public-subnet.id
}

