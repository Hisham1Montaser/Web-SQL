# Root module variables
resource_group_name = "MyRG"
location            = "francecentral" # Corrected the region name

#WebApp module variables
app_service_plan_name               = "MyAppServicePlan"
windows_webapp_name                 = "bastawisiwindowsapp"
webapp_log_analytics_workspace_name = "MyWebApp-LogAnalytics-WorkSpace"
webapp_application_insights_name    = "WebApp_application_insights"

# Networking module variables
virtual_network_name            = "MyVNET"
address_space                   = ["10.0.0.0/8"]
main_subnet_name                = "MainSubnet"
main_subnet_prefixes            = ["10.0.0.0/16"]
integration_subnet_name         = "IntegrationSubnet"
integration_subnet_prefixes     = ["10.1.0.0/16"]
delegation_name                 = "Delegation_for_Web"
private_endpoint_name           = "SQL-PE"
private_service_connection_name = "SQL_Private_Connection"
private_dnszone_name            = "privatelink.database.windows.net"
dnszone_link_name               = "sqlPrivateDnsVnetLink"

# SQL module variables
sql_server_name                 = "bastawisisqlserver"
sql_dns_record_name             = "bastawisisqlserver"
sql_login_username              = "Hisham"
sql_username_objectid           = "3616fdcf-2b13-407d-a86e-4a1a79715b51"
sql_db_name                     = "MyDB"
sql_workspace_name              = "SQL-Workspace"
my_public_ip                    = "41.34.12.252" # Replace with your actual public IP
monitor_diagnostic_setting_name = "SQL-Diagnostics-Settings"