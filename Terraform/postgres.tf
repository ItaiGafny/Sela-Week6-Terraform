resource "azurerm_private_dns_zone" "dns-zone" {
  #Code="PrivateDnsZoneNameNotValid" Message="The Private DNS Zone name provided [sela-week5-postgresql-server.postgres.database.azure.com] is not valid. It can not be server name plus zone suffix."
  name                = "week5.postgres.database.azure.com"
  resource_group_name = local.rg-name
}

resource "azurerm_private_dns_zone_virtual_network_link" "virtual-network-link" {
  name                  = "week5VnetZone.com"
  private_dns_zone_name = azurerm_private_dns_zone.dns-zone.name
  virtual_network_id    = module.vms.vnet-id
  resource_group_name   = local.rg-name

}

resource "azurerm_postgresql_flexible_server" "postgresqlserver" {
  name                = "${var.prefix}postgresql-server"
  location            = local.location
  resource_group_name = local.rg-name

  sku_name = "B_Standard_B1ms"

  storage_mb                   = 32768
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  #require_secure_transport      = false

  administrator_login    = var.psotgres-administrator-login
  administrator_password = var.postgres-password
  version                = "12"
  zone                   = "1"


  delegated_subnet_id = module.vms.private-subnet-id
  private_dns_zone_id = azurerm_private_dns_zone.dns-zone.id

  depends_on = [
    #azurerm_subnet.private-subnet,
    module.vms.azurerm_subnet,
    azurerm_private_dns_zone_virtual_network_link.virtual-network-link
  ]
}

# Set the DB to work without SSL as we do in this project
resource "azurerm_postgresql_flexible_server_configuration" "db-config-no-ssl" {
  name      = "require_secure_transport"
  server_id = azurerm_postgresql_flexible_server.postgresqlserver.id
  value     = "off"
}