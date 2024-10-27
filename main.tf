resource "azurerm_resource_group" "myrg" {
  name     = var.resource_group_name
  location = var.location
}

#WebApp Module
module "WebApp" {
  source                              = "./WebApp"
  resource_group_name                 = var.resource_group_name
  location                            = var.location
  app_service_plan_name               = var.app_service_plan_name
  windows_webapp_name                 = var.windows_webapp_name
  webapp_log_analytics_workspace_name = var.webapp_log_analytics_workspace_name
  webapp_application_insights_name    = var.webapp_application_insights_name
  sql_login_password                  = var.sql_login_password
  sql_login_username                  = var.sql_login_username

  # Pass outputs from the SQL module to the WebApp module
  sql_server_name = var.sql_server_name
  sql_db_name     = var.sql_db_name
}



# Networking Module
module "networking" {
  source                          = "./Networking"
  resource_group_name             = var.resource_group_name
  location                        = var.location
  virtual_network_name            = var.virtual_network_name
  address_space                   = var.address_space
  main_subnet_name                = var.main_subnet_name
  main_subnet_prefixes            = var.main_subnet_prefixes
  integration_subnet_name         = var.integration_subnet_name
  integration_subnet_prefixes     = var.integration_subnet_prefixes
  delegation_name                 = var.delegation_name
  private_endpoint_name           = var.private_endpoint_name
  private_service_connection_name = var.private_service_connection_name
  private_dnszone_name            = var.private_dnszone_name
  dnszone_link_name               = var.dnszone_link_name
  sql_server_name                 = var.sql_server_name
  sql_dns_record_name             = var.sql_dns_record_name

  # Pass outputs from the WebApp module to the Networking module
  app_service_id = module.WebApp.webapp_service_id

  # Pass outputs from the SQL module to the Networking module
  sql_server_id = module.sql_module.sql_server_id

}

# SQL Module
module "sql_module" {
  source                          = "./SQL"
  resource_group_name             = var.resource_group_name
  location                        = var.location
  sql_server_name                 = var.sql_server_name
  sql_login_username              = var.sql_login_username
  sql_login_password              = var.sql_login_password
  sql_username_objectid           = var.sql_username_objectid
  sql_db_name                     = var.sql_db_name
  sql_workspace_name              = var.sql_workspace_name
  my_public_ip                    = var.my_public_ip
  monitor_diagnostic_setting_name = var.monitor_diagnostic_setting_name
}