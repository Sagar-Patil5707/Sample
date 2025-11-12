output "count" { value = length(var.targets) }

output "diagnostic_summary" {
  description = "Resources that have diagnostics attached"
  value = {
    created = keys(var.targets)
  }
}

