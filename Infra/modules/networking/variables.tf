variable "name_prefix" { type = string }
variable "env" { type = string }
variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "vnet_cidr" { type = string }
variable "frontend_cidr" { type = string }
variable "backend_cidr" { type = string }
variable "data_cidr" { type = string }
variable "tags" {
  type    = map(string)
  default = {}
}
