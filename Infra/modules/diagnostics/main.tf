# --- Diagnostic Settings ---
resource "azurerm_monitor_diagnostic_setting" "diag" {
  # ✅ static keys (from var.targets)
  for_each = var.targets

  name = lower(substr("to-law-${var.env}-${each.key}", 0, 80))

  target_resource_id         = each.value
  log_analytics_workspace_id = var.workspace_id

  # --- Log categories ---
  dynamic "enabled_log" {
    for_each = (
      can(regex("Microsoft.Web/sites", each.value)) ? [
        "AppServiceHTTPLogs",
        "AppServiceConsoleLogs",
        "AppServiceAppLogs",
        "AppServiceAuditLogs",
        "AppServicePlatformLogs"
      ] :
      can(regex("Microsoft.KeyVault/vaults", each.value)) ? ["AuditEvent"] :
      can(regex("Microsoft.Network/networkSecurityGroups", each.value)) ? [
        "NetworkSecurityGroupEvent",
        "NetworkSecurityGroupRuleCounter"
      ] :
      # Storage has no log categories
      can(regex("Microsoft.Storage/storageAccounts", each.value)) ? [] :
      can(regex("Microsoft.Sql/servers/.*/databases", each.value)) ? ["SQLSecurityAuditEvents"] :
      []
    )
    content {
      category = enabled_log.value
    }
  }

  # --- Metric categories ---
  dynamic "metric" {
    for_each = (
      can(regex("Microsoft.Web/sites", each.value)) ? ["AllMetrics"] :
      can(regex("Microsoft.KeyVault/vaults", each.value)) ? ["AllMetrics"] :
      # NSG → no metrics
      can(regex("Microsoft.Network/networkSecurityGroups", each.value)) ? [] :
      # Storage → metrics only
      can(regex("Microsoft.Storage/storageAccounts", each.value)) ? ["Transaction", "Capacity"] :
      can(regex("Microsoft.Sql/servers", each.value)) ? ["AllMetrics"] :
      []
    )
    content {
      category = metric.value
      enabled  = true
    }
  }
}
