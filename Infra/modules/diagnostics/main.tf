# Attach diagnostic settings for many resources to LAW
locals { targets = var.targets }

resource "azurerm_monitor_diagnostic_setting" "diag" {
  for_each                   = toset(local.targets)
  name                       = "to-law"
  target_resource_id         = each.value
  log_analytics_workspace_id = var.workspace_id

  dynamic "enabled_log" {
    for_each = ["AppServiceHTTPLogs", "AppServiceConsoleLogs", "AuditEvent", "SQLSecurityAuditEvents", "AzureDiagnostics"]
    content { category = enabled_log.value }
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
