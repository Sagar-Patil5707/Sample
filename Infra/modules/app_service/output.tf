output "app_id" { value = azurerm_linux_web_app.app.id }
output "default_hostname" { value = azurerm_linux_web_app.app.default_hostname }
output "app_identity_principal_id" {
  value = azurerm_linux_web_app.app.identity[0].principal_id
}
output "id" {
  description = "App Service resource ID"
  value       = azurerm_linux_web_app.app.id
}

