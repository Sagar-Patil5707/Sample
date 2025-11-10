variable "workspace_id" { type = string }
variable "resource_group_name" { type = string }
# variable "targets" { type = list(string) }

variable "targets" {
  description = "Map of resource names to their resource IDs for diagnostic settings"
  type        = map(string)
}



