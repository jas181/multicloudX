locals {
  tags   = merge(var.tags, { environment = var.environment })
  prefix = "mcx-${var.environment}-${var.name_suffix}"
}

module "azure_landing_zone" {
  count       = contains(var.enabled_clouds, "azure") ? 1 : 0
  source      = "../../modules/azure-landing-zone"
  name_prefix = local.prefix
  location    = var.azure_location
  tags        = local.tags
}

module "azure_network" {
  count               = contains(var.enabled_clouds, "azure") ? 1 : 0
  source              = "../../modules/azure-network"
  name_prefix         = local.prefix
  location            = var.azure_location
  resource_group_name = module.azure_landing_zone[0].resource_group_name
  tags                = local.tags
}

module "aws_landing_zone" {
  count       = contains(var.enabled_clouds, "aws") ? 1 : 0
  source      = "../../modules/aws-landing-zone"
  name_prefix = local.prefix
  tags        = local.tags
}

module "aws_network" {
  count       = contains(var.enabled_clouds, "aws") ? 1 : 0
  source      = "../../modules/aws-network"
  name_prefix = local.prefix
  tags        = local.tags
}

module "gcp_landing_zone" {
  count       = contains(var.enabled_clouds, "gcp") ? 1 : 0
  source      = "../../modules/gcp-landing-zone"
  name_prefix = local.prefix
  project_id  = var.gcp_project_id
  location    = var.gcp_region
  labels      = local.tags
}

module "gcp_network" {
  count       = contains(var.enabled_clouds, "gcp") ? 1 : 0
  source      = "../../modules/gcp-network"
  name_prefix = local.prefix
  project_id  = var.gcp_project_id
  region      = var.gcp_region
  labels      = local.tags
}
