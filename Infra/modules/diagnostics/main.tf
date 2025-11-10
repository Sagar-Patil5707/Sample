# locals {
#   targets = var.targets

#   # Build resource configurations dynamically
#   resource_configs = [
#     for target in local.targets : {
#       id = target

#       log_categories = (
#         can(regex("Microsoft.Web/sites", target)) ? [
#           "AppServiceHTTPLogs",
#           "AppServiceConsoleLogs",
#           "AppServiceAppLogs",
#           "AppServiceAuditLogs",
#           "AppServicePlatformLogs"
#         ] :
#         can(regex("Microsoft.KeyVault/vaults", target)) ? [
#           "AuditEvent"
#         ] :
#         can(regex("Microsoft.Network/networkSecurityGroups", target)) ? [
#           "NetworkSecurityGroupEvent",
#           "NetworkSecurityGroupRuleCounter"
#         ] :
#         can(regex("Microsoft.Storage/storageAccounts", target)) ? [
#           "StorageRead",
#           "StorageWrite",
#           "StorageDelete"
#         ] :
#         can(regex("Microsoft.Sql/servers", target)) ? [] :
#         can(regex("Microsoft.Sql/servers/.*/databases", target)) ? [
#           "SQLSecurityAuditEvents"
#         ] : []
#       )

#       metric_categories = (
#         can(regex("Microsoft.Web/sites", target)) ? ["AllMetrics"] :
#         can(regex("Microsoft.KeyVault/vaults", target)) ? ["AllMetrics"] :
#         can(regex("Microsoft.Network/networkSecurityGroups", target)) ? ["AllMetrics"] :
#         can(regex("Microsoft.Storage/storageAccounts", target)) ? ["Transaction", "Capacity"] :
#         []
#       )
#     }
#   ]

#   # ✅ Generate valid diagnostic names (cleaner + safe)
#   sanitized_names = {
#     for cfg in local.resource_configs : cfg.id => lower(substr(
#       "to-law-${element(split(cfg.id, "/"), length(split(cfg.id, "/")) - 1)}",
#       0,
#       80
#     ))
#   }
# }

# resource "azurerm_monitor_diagnostic_setting" "diag" {
#   for_each = {
#     for cfg in local.resource_configs : cfg.id => cfg
#     if length(cfg.log_categories) > 0 || length(cfg.metric_categories) > 0
#   }

#   name                       = replace(replace(replace(local.sanitized_names[each.key], "/", "-"), ":", "-"), " ", "-")
#   target_resource_id         = each.value.id
#   log_analytics_workspace_id = var.workspace_id

#   dynamic "enabled_log" {
#     for_each = each.value.log_categories
#     content {
#       category = enabled_log.value
#     }
#   }

#   dynamic "metric" {
#     for_each = each.value.metric_categories
#     content {
#       category = metric.value
#       enabled  = true
#     }
#   }
# }


# locals {
#   resource_configs = {
#     for name, id in var.targets : name => {
#       id = id

#       log_categories = (
#         can(regex("Microsoft.Web/sites", id)) ? [
#           "AppServiceHTTPLogs",
#           "AppServiceConsoleLogs",
#           "AppServiceAppLogs",
#           "AppServiceAuditLogs",
#           "AppServicePlatformLogs"
#         ] :
#         can(regex("Microsoft.KeyVault/vaults", id)) ? [
#           "AuditEvent"
#         ] :
#         can(regex("Microsoft.Network/networkSecurityGroups", id)) ? [
#           "NetworkSecurityGroupEvent",
#           "NetworkSecurityGroupRuleCounter"
#         ] :
#         can(regex("Microsoft.Storage/storageAccounts", id)) ? [
#           "StorageRead",
#           "StorageWrite",
#           "StorageDelete"
#         ] :
#         can(regex("Microsoft.Sql/servers/.*/databases", id)) ? [
#           "SQLSecurityAuditEvents"
#         ] : []
#       )

#       metric_categories = (
#         can(regex("Microsoft.Web/sites", id)) ? ["AllMetrics"] :
#         can(regex("Microsoft.KeyVault/vaults", id)) ? ["AllMetrics"] :
#         can(regex("Microsoft.Storage/storageAccounts", id)) ? ["Transaction", "Capacity"] :
#         []
#       )
#     }
#   }
# }

# resource "azurerm_monitor_diagnostic_setting" "diag" {
#   for_each = local.resource_configs

#   name = lower(substr("to-law-${basename(each.value.id)}", 0, 80))

#   target_resource_id         = each.value.id
#   log_analytics_workspace_id = var.workspace_id

#   dynamic "enabled_log" {
#     for_each = each.value.log_categories
#     content {
#       category = enabled_log.value
#     }
#   }

#   dynamic "metric" {
#     for_each = each.value.metric_categories
#     content {
#       category = metric.value
#       enabled  = true
#     }
#   }
# }






locals {
  # Build per-resource diagnostic configuration dynamically
  resource_configs = {
    for name, id in var.targets : name => {
      id = id

      # --- Log categories ---
      log_categories = (
        can(regex("Microsoft.Web/sites", id)) ? [
          "AppServiceHTTPLogs",
          "AppServiceConsoleLogs",
          "AppServiceAppLogs",
          "AppServiceAuditLogs",
          "AppServicePlatformLogs"
        ] :
        can(regex("Microsoft.KeyVault/vaults", id)) ? [
          "AuditEvent"
        ] :
        can(regex("Microsoft.Network/networkSecurityGroups", id)) ? [
          "NetworkSecurityGroupEvent",
          "NetworkSecurityGroupRuleCounter"
        ] :
        # ✅ Storage accounts generally don't support diagnostic logs
        can(regex("Microsoft.Storage/storageAccounts", id)) ? [] :
        can(regex("Microsoft.Sql/servers/.*/databases", id)) ? [
          "SQLSecurityAuditEvents"
        ] : []
      )

      # --- Metric categories ---
      metric_categories = (
        can(regex("Microsoft.Web/sites", id)) ? ["AllMetrics"] :
        can(regex("Microsoft.KeyVault/vaults", id)) ? ["AllMetrics"] :
        # ✅ NSG does NOT support metrics
        can(regex("Microsoft.Network/networkSecurityGroups", id)) ? [] :
        # ✅ Storage supports only these metric categories
        can(regex("Microsoft.Storage/storageAccounts", id)) ? ["Transaction", "Capacity"] :
        can(regex("Microsoft.Sql/servers", id)) ? ["AllMetrics"] :
        []
      )
    }
  }

  # ✅ Filter out unsupported resources (e.g., Static Web Apps, empty configs)
  filtered_resource_configs = {
    for name, cfg in local.resource_configs :
    name => cfg
    if length(cfg.log_categories) > 0 || length(cfg.metric_categories) > 0
  }
}

# --- Diagnostic Settings for each supported resource ---
resource "azurerm_monitor_diagnostic_setting" "diag" {
  for_each = local.filtered_resource_configs

  name = lower(substr("to-law-${basename(each.value.id)}", 0, 80))

  target_resource_id         = each.value.id
  log_analytics_workspace_id = var.workspace_id

  # ✅ Log categories (skip if none)
  dynamic "enabled_log" {
    for_each = length(each.value.log_categories) > 0 ? each.value.log_categories : []
    content {
      category = enabled_log.value
    }
  }

  # ✅ Metric categories (skip if none)
  dynamic "metric" {
    for_each = length(each.value.metric_categories) > 0 ? each.value.metric_categories : []
    content {
      category = metric.value
      enabled  = true
    }
  }
}


