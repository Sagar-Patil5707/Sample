variable "name_prefix" { type = string }
variable "env" { type = string }
variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "allowed_public_ips" {
  type    = list(string)
  default = []
}
variable "diag_workspace_id" { type = string }
variable "tags" {
  type    = map(string)
  default = {}
}
