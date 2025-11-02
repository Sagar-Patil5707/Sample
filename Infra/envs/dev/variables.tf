variable "subscription_id" { type = string }
variable "location" {
  type    = string
  default = "eastus"
}
variable "env" {
  type    = string
  default = "dev"
}
variable "name_prefix" {
  type    = string
  default = "oneview"
}

# Networking CIDRs (match the diagram)
variable "vnet_cidr" {
  type    = string
  default = "10.0.0.0/16"
}
variable "frontend_cidr" {
  type    = string
  default = "10.0.1.0/24"
}
variable "backend_cidr" {
  type    = string
  default = "10.0.2.0/24"
}
variable "data_cidr" {
  type    = string
  default = "10.0.3.0/24"
}

# App Service
variable "app_service_sku" {
  type    = string
  default = "F1"
} # matches “single instance, B2” feel

# SQL
variable "sql_admin_login" { type = string }
variable "sql_admin_password" {
  type      = string
  sensitive = true
}

# Allowed egress IPs for KV public firewall (optional)
variable "allowed_kv_ips" {
  type    = list(string)
  default = []
}
