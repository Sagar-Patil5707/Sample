output "workspace_id" { value = azurerm_log_analytics_workspace.law.id }
output "id" {
  description = "Log Analytics Workspace ID"
  value       = azurerm_log_analytics_workspace.law.id
}
