output "db_connection_string" {
  description = "Connection string to the database"
  value = "host=${azurerm_postgresql_flexible_server.postgresqlserver.name}.postgres.database.azure.com port=5432 dbname=postgres user=${var.psotgres-administrator-login} password=${var.postgres-password} sslmode=require"
}

output "postgres-password" {
  description = "Postgres password"
  value       = azurerm_postgresql_flexible_server.postgresqlserver.administrator_password
  sensitive = true
}

output "psotgres-administrator-login" {
  description = "Postgres username"
  value       = azurerm_postgresql_flexible_server.postgresqlserver.administrator_login
}

output "load_balancer_public_ip_address" {
  description = "LB public IP"
  value       = module.vms.load_balancer_public_ip_address

}
