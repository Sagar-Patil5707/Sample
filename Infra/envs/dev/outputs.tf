output "resource_group" { value = module.rg.name }
output "static_web_app_default_host" { value = module.swa.default_hostname }
output "app_service_url" { value = module.app.default_hostname }
output "sql_private_fqdn" { value = module.sql.server_fqdn_private }
