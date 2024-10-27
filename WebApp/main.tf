
resource "azurerm_service_plan" "myserviceplan" {
  name                = var.app_service_plan_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku_name            = "B1"
  os_type             = "Windows"
}

resource "azurerm_windows_web_app" "mywebapp" {
  name                = var.windows_webapp_name
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.myserviceplan.id

  site_config {
    application_stack {
      current_stack  = "dotnet"
      dotnet_version = "v6.0"
    }
  }
  app_settings = {
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = azurerm_application_insights.webappinsights.connection_string
  }
  connection_string {
    name  = "MyDbConnection"
    type  = "SQLAzure"
    value = "Server=${var.sql_server_name}.privatelink.database.windows.net;Database=${var.sql_db_name};User ID=${var.sql_login_username};Password=${var.sql_login_password};Trusted_Connection=False;Encrypt=True;"
  }
}

resource "azurerm_log_analytics_workspace" "webappworkspace" {
  name                = var.webapp_log_analytics_workspace_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_application_insights" "webappinsights" {
  name                = var.webapp_application_insights_name
  resource_group_name = var.resource_group_name
  location            = var.location
  application_type    = "web"
  workspace_id        = azurerm_log_analytics_workspace.webappworkspace.id
}
