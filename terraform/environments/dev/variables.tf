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
variable "enable_phase2_storage" {
  description = "Explicitly create Phase 2 storage resources; defaults to false to avoid charges."
  type        = bool
  default     = false
}
variable "enable_phase2_databases" {
  description = "Explicitly create Phase 2 private PostgreSQL resources; defaults to false."
  type        = bool
  default     = false
}
variable "database_admin_password" {
  description = "Supplied only through an approved secret-injection mechanism when Azure database deployment is enabled."
  type        = string
  default     = null
  sensitive   = true
}
variable "enable_phase2_compute" {
  description = "Explicitly create Phase 2 compute and internal load-balancing resources; defaults to false."
  type        = bool
  default     = false
}
variable "enable_phase2_security" {
  description = "Explicitly enable Phase 2 cloud-native security services; defaults to false."
  type        = bool
  default     = false
}
variable "compute_admin_ssh_public_key" {
  description = "SSH public key for Azure VMSS administration; supply only when Azure compute is enabled."
  type        = string
  default     = null
}
variable "aws_ami_id" {
  description = "Approved AMI ID for AWS compute; supply only when AWS compute is enabled."
  type        = string
  default     = null
}
variable "name_suffix" {
  type    = string
  default = "change-me"
  validation {
    condition     = can(regex("^[a-z0-9-]{3,16}$", var.name_suffix))
    error_message = "name_suffix must be 3-16 lowercase letters, numbers, or hyphens."
  }
}
variable "tags" { type = map(string) }
