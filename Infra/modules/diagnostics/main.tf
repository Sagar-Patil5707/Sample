# Attach diagnostic settings for many resources to LAW
locals {
  targets = var.targets
}

resource "azurerm_monitor_diagnostic_setting" "diag" {
  count = length(local.targets)

  name                       = "to-law-${count.index}"
  target_resource_id         = local.targets[count.index]
  log_analytics_workspace_id = var.workspace_id

  dynamic "enabled_log" {
    for_each = [
      "AppServiceHTTPLogs",
      "AppServiceConsoleLogs",
      "AuditEvent",
      "SQLSecurityAuditEvents",
      "AzureDiagnostics"
    ]
    content {
      category = enabled_log.value
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

