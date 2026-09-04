variable "environment" {
  type    = string
  default = "dev"
  validation {
    condition     = contains(["dev", "test", "stage", "prod"], var.environment)
    error_message = "Use dev, test, stage, or prod."
  }
}
variable "enabled_clouds" {
  type    = set(string)
  default = []
  validation {
    condition     = length(setsubtract(var.enabled_clouds, ["azure", "aws", "gcp"])) == 0
    error_message = "Only azure, aws, and gcp are valid."
  }
}
variable "azure_location" { type = string }
variable "azure_subscription_id" {
  type      = string
  sensitive = true
}
variable "aws_region" { type = string }
variable "gcp_region" { type = string }
variable "gcp_project_id" { type = string }
variable "name_suffix" {
  type    = string
  default = "change-me"
  validation {
    condition     = can(regex("^[a-z0-9-]{3,16}$", var.name_suffix))
    error_message = "name_suffix must be 3-16 lowercase letters, numbers, or hyphens."
  }
}
variable "tags" { type = map(string) }
