# output "db_connection_string" {
#   description = "Connection string to the database"
#   value = "host=sela-week5-postgresql-server.postgres.database.azure.com port=5432 dbname=postgres user=${var.psotgres-administrator-login} password=${var.postgres-password} sslmode=require"
# }

output "postgres-password" {
  description = "Postgres password"
  value       = var.postgres-password
}

output "psotgres-administrator-login" {
  description = "Postgres username"
  value       = var.psotgres-administrator-login
}

output "load_balancer_public_ip_address" {
  description = "LB public IP"
  value       = module.vms.load_balancer_public_ip_address

}
