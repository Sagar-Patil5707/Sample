variable "name_prefix" { type = string }
variable "env" { type = string }
variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "app_service_mi_principal_id" { type = string }
variable "tags" {
  type    = map(string)
  default = {}
}
