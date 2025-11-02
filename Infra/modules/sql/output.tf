output "server_id" { value = azurerm_mssql_server.server.id }
output "database_name" { value = azurerm_mssql_database.db.name }
# output "server_fqdn_private" {
#   value = azurerm_private_endpoint.pe.custom_dns_configs[0].fqdn
# }

output "server_fqdn_private" {
  value = try(azurerm_private_endpoint.pe.custom_dns_configs[0].fqdn, null)
}
