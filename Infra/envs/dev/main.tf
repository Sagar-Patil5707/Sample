locals {
  rg_name  = "${var.name_prefix}-${var.env}-rg"
  tags = {
    ENVIRONMENT = var.env
    COSTCENTER  = "ENGINEERING"
    OWNER       = "devops"
  }
}

module "rg" {
  source   = "../../modules/resource_group"
  name     = local.rg_name
  location = var.location
  tags     = local.tags
}

module "law" {
  source              = "../../modules/log_analytics"
  name_prefix         = var.name_prefix
  env                 = var.env
  location            = var.location
  resource_group_name = module.rg.name
  tags                = local.tags
}

module "appi" {
  source              = "../../modules/app_insights"
  name_prefix         = var.name_prefix
  env                 = var.env
  location            = var.location
  resource_group_name = module.rg.name
  workspace_id        = module.law.workspace_id
  tags                = local.tags
}

module "storage" {
  source              = "../../modules/storage"
  name_prefix         = var.name_prefix
  env                 = var.env
  location            = var.location
  resource_group_name = module.rg.name
  tags                = local.tags
}

module "net" {
  source              = "../../modules/networking"
  name_prefix         = var.name_prefix
  env                 = var.env
  location            = var.location
  resource_group_name = module.rg.name
  vnet_cidr           = var.vnet_cidr
  frontend_cidr       = var.frontend_cidr
  backend_cidr        = var.backend_cidr
  data_cidr           = var.data_cidr
  tags                = local.tags
}

module "kv" {
  source                 = "../../modules/key_vault"
  name_prefix            = var.name_prefix
  env                    = var.env
  location               = var.location
  resource_group_name    = module.rg.name
  allowed_public_ips     = var.allowed_kv_ips
  diag_workspace_id      = module.law.workspace_id
  tags                   = local.tags
}

module "sql" {
  source                     = "../../modules/sql"
  name_prefix                = var.name_prefix
  env                        = var.env
  location                   = var.location
  resource_group_name        = module.rg.name
  vnet_id                    = module.net.vnet_id
  data_subnet_id             = module.net.data_subnet_id
  private_dns_rg_name        = module.rg.name
  sql_admin_login            = var.sql_admin_login
  sql_admin_password         = var.sql_admin_password
  diag_workspace_id          = module.law.workspace_id
  tags                       = local.tags
}

module "app" {
  source                       = "../../modules/app_service"
  name_prefix                  = var.name_prefix
  env                          = var.env
  location                     = var.location
  resource_group_name          = module.rg.name
  app_service_sku              = var.app_service_sku
  backend_subnet_id            = module.net.backend_subnet_id
  app_insights_connection_str  = module.appi.connection_string
  key_vault_id                 = module.kv.id
  diag_workspace_id            = module.law.workspace_id
  tags                         = local.tags

  # Example: put SQL connection string into app settings (fetched by MI from KV later)
  sql_server_fqdn              = module.sql.server_fqdn_private
  sql_database_name            = module.sql.database_name
}

module "swa" {
  source              = "../../modules/static_web_app"
  name_prefix         = var.name_prefix
  env                 = var.env
  location            = var.location
  resource_group_name = module.rg.name
  tags                = local.tags
}

module "diag" {
  source              = "../../modules/diagnostics"
  resource_group_name = module.rg.name
  workspace_id        = module.law.workspace_id

  targets = [
    module.app.app_id,
    module.sql.server_id,
    module.kv.id,
    module.net.nsg_ids...
  ]
}
