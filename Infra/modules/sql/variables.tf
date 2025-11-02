variable "name_prefix" { type = string }
variable "env" { type = string }
variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "vnet_id" { type = string }
variable "data_subnet_id" { type = string }
variable "private_dns_rg_name" { type = string }
variable "sql_admin_login" { type = string }
variable "sql_admin_password" {
  type      = string
  sensitive = true
}
variable "diag_workspace_id" { type = string }
variable "tags" {
  type    = map(string)
  default = {}
}
