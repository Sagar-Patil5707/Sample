locals {
  targets = var.targets

  # Build resource configurations dynamically
  resource_configs = [
    for target in local.targets : {
      id = target

      log_categories = (
        can(regex("Microsoft.Web/sites", target)) ? [
          "AppServiceHTTPLogs",
          "AppServiceConsoleLogs",
          "AppServiceAppLogs",
          "AppServiceAuditLogs",
          "AppServicePlatformLogs"
        ] :
        can(regex("Microsoft.KeyVault/vaults", target)) ? [
          "AuditEvent"
        ] :
        can(regex("Microsoft.Network/networkSecurityGroups", target)) ? [
          "NetworkSecurityGroupEvent",
          "NetworkSecurityGroupRuleCounter"
        ] :
        can(regex("Microsoft.Storage/storageAccounts", target)) ? [
          "StorageRead",
          "StorageWrite",
          "StorageDelete"
        ] :
        can(regex("Microsoft.Sql/servers", target)) ? [] :
        can(regex("Microsoft.Sql/servers/.*/databases", target)) ? [
          "SQLSecurityAuditEvents"
        ] : []
      )

      metric_categories = (
        can(regex("Microsoft.Web/sites", target)) ? ["AllMetrics"] :
        can(regex("Microsoft.KeyVault/vaults", target)) ? ["AllMetrics"] :
        can(regex("Microsoft.Network/networkSecurityGroups", target)) ? ["AllMetrics"] :
        can(regex("Microsoft.Storage/storageAccounts", target)) ? ["Transaction", "Capacity"] :
        []
      )
    }
  ]

  # ✅ Generate valid diagnostic names (cleaner + safe)
  sanitized_names = {
    for cfg in local.resource_configs : cfg.id => lower(substr(
      "to-law-${element(split(cfg.id, "/"), length(split(cfg.id, "/")) - 1)}",
      0,
      80
    ))
  }
}
