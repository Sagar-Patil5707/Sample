variable "name_prefix" { type = string }
variable "env" { type = string }
variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "app_service_sku" { type = string }
variable "backend_subnet_id" { type = string }
variable "app_insights_connection_str" { type = string }
variable "key_vault_id" { type = string }
variable "diag_workspace_id" { type = string }
variable "sql_server_fqdn" { type = string }
variable "sql_database_name" { type = string }
variable "tags" {
  type    = map(string)
  default = {}
}
variable "acr_login_server" { type = string }
variable "image_name" { type = string }
variable "image_tag" {
  type    = string
  default = "latest"
}
variable "app_command_line" {
  type    = string
  default = ""
}
variable "container_port" {
  type    = number
  default = 8080
}
