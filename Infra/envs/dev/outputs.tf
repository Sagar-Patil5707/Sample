output "resource_group" { value = local.rg_name }
output "static_web_app_default_host" { value = module.swa.default_host_name }
output "app_service_url" { value = module.app.default_hostname }
output "sql_private_fqdn" { value = module.sql.server_fqdn_private }
