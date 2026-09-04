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

module "azure_storage" {
  count               = contains(var.enabled_clouds, "azure") && var.enable_phase2_storage ? 1 : 0
  source              = "../../modules/azure-storage"
  name_prefix         = local.prefix
  location            = var.azure_location
  resource_group_name = module.azure_landing_zone[0].resource_group_name
  subnet_id           = module.azure_network[0].app_subnet_id
  vnet_id             = module.azure_network[0].vnet_id
  tags                = local.tags
}

module "aws_storage" {
  count       = contains(var.enabled_clouds, "aws") && var.enable_phase2_storage ? 1 : 0
  source      = "../../modules/aws-storage"
  name_prefix = local.prefix
  tags        = local.tags
}

module "gcp_storage" {
  count       = contains(var.enabled_clouds, "gcp") && var.enable_phase2_storage ? 1 : 0
  source      = "../../modules/gcp-storage"
  name_prefix = local.prefix
  project_id  = var.gcp_project_id
  location    = var.gcp_region
  labels      = local.tags
}

module "azure_postgresql" {
  count                  = contains(var.enabled_clouds, "azure") && var.enable_phase2_databases ? 1 : 0
  source                 = "../../modules/azure-postgresql"
  name_prefix            = local.prefix
  location               = var.azure_location
  resource_group_name    = module.azure_landing_zone[0].resource_group_name
  subnet_id              = module.azure_network[0].data_subnet_id
  vnet_id                = module.azure_network[0].vnet_id
  administrator_password = var.database_admin_password
  tags                   = local.tags
}

module "aws_postgresql" {
  count               = contains(var.enabled_clouds, "aws") && var.enable_phase2_databases ? 1 : 0
  source              = "../../modules/aws-postgresql"
  name_prefix         = local.prefix
  vpc_id              = module.aws_network[0].vpc_id
  database_subnet_ids = module.aws_network[0].private_database_subnet_ids
  tags                = local.tags
}

module "gcp_postgresql" {
  count       = contains(var.enabled_clouds, "gcp") && var.enable_phase2_databases ? 1 : 0
  source      = "../../modules/gcp-postgresql"
  name_prefix = local.prefix
  project_id  = var.gcp_project_id
  region      = var.gcp_region
  network_id  = module.gcp_network[0].network_id
  labels      = local.tags
}

module "azure_compute" {
  count                = contains(var.enabled_clouds, "azure") && var.enable_phase2_compute ? 1 : 0
  source               = "../../modules/azure-compute"
  name_prefix          = local.prefix
  location             = var.azure_location
  resource_group_name  = module.azure_landing_zone[0].resource_group_name
  subnet_id            = module.azure_network[0].app_subnet_id
  admin_ssh_public_key = var.compute_admin_ssh_public_key
  tags                 = local.tags
}

module "aws_compute" {
  count          = contains(var.enabled_clouds, "aws") && var.enable_phase2_compute ? 1 : 0
  source         = "../../modules/aws-compute"
  name_prefix    = local.prefix
  vpc_id         = module.aws_network[0].vpc_id
  app_subnet_ids = module.aws_network[0].private_app_subnet_ids
  ami_id         = var.aws_ami_id
  tags           = local.tags
}

module "gcp_compute" {
  count       = contains(var.enabled_clouds, "gcp") && var.enable_phase2_compute ? 1 : 0
  source      = "../../modules/gcp-compute"
  name_prefix = local.prefix
  project_id  = var.gcp_project_id
  region      = var.gcp_region
  subnet_id   = module.gcp_network[0].app_subnet_id
  network_id  = module.gcp_network[0].network_id
  labels      = local.tags
}
