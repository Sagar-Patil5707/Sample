# output "id" { value = azurerm_key_vault.kv.id }
output "name" { value = azurerm_key_vault.kv.name }

output "id" {
  description = "Key Vault resource ID"
  value       = azurerm_key_vault.kv.id
}
