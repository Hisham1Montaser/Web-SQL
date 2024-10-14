resource "azurerm_resource_group" "MyRG" {
  name     = "WebRG"
  location = "francecentral"
}

resource "azurerm_service_plan" "MyServicePlan" {
  name                = "My-ServicePlan"
  resource_group_name = azurerm_resource_group.MyRG.name
  location            = azurerm_resource_group.MyRG.location
  sku_name            = "B1"
  os_type             = "Windows"
}

resource "azurerm_windows_web_app" "MyWebApp" {
  name                = "Bastawisiwebapp"
  resource_group_name = azurerm_resource_group.MyRG.name
  location            = azurerm_resource_group.MyRG.location
  service_plan_id     = azurerm_service_plan.MyServicePlan.id

  site_config {
    application_stack {
      current_stack  = "dotnet"
      dotnet_version = "v6.0"
    }
  }
  app_settings = {
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = azurerm_application_insights.MyAppinsights.connection_string
  }
  connection_string {
    name  = "MyDbConnection"
    type  = "SQLAzure"
    value = "Server=${azurerm_mssql_server.MySQLServer.name}.privatelink.database.windows.net;Database=${azurerm_mssql_database.MySQLDB.name};User ID=${azurerm_mssql_server.MySQLServer.azuread_administrator[0].login_username};Password=<YourPassword>;Trusted_Connection=False;Encrypt=True;"
  }
}


resource "azurerm_log_analytics_workspace" "MyworkSpace" {
  name                = "appworkspace"
  resource_group_name = azurerm_resource_group.MyRG.name
  location            = azurerm_resource_group.MyRG.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_application_insights" "MyAppinsights" {
  name                = "appinsights"
  resource_group_name = azurerm_resource_group.MyRG.name
  location            = azurerm_resource_group.MyRG.location
  application_type    = "web"
  workspace_id        = azurerm_log_analytics_workspace.MyworkSpace.id
}