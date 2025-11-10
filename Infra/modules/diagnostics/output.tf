output "count" { value = length(var.targets) }

output "diagnostic_summary" {
  value = {
    created = keys(local.filtered_resource_configs)
    skipped = [for name, cfg in local.resource_configs : name if !(contains(keys(local.filtered_resource_configs), name))]
  }
}
