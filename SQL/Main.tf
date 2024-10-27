resource "azurerm_mssql_server" "mysqlserver" {
  name                = var.sql_server_name
  resource_group_name = var.resource_group_name
  location            = var.location
  version             = "12.0"

  azuread_administrator {
    login_username              = var.sql_login_username
    object_id                   = var.sql_username_objectid
    azuread_authentication_only = true
  }
}

resource "azurerm_mssql_database" "mysqldb" {
  name         = var.sql_db_name
  server_id    = azurerm_mssql_server.mysqlserver.id
  collation    = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "LicenseIncluded"
  max_size_gb  = 2
  sku_name     = "Basic"
}

resource "azurerm_mssql_firewall_rule" "sqlfirewallrule" {
  name             = "AllowMyIP"
  server_id        = azurerm_mssql_server.mysqlserver.id
  start_ip_address = var.my_public_ip
  end_ip_address   = var.my_public_ip
}

resource "azurerm_log_analytics_workspace" "sqlworkspace" {
  name                = var.sql_workspace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_mssql_database_extended_auditing_policy" "sqlauditing" {
  database_id            = azurerm_mssql_database.mysqldb.id
  log_monitoring_enabled = true
}

resource "azurerm_monitor_diagnostic_setting" "diag" {
  name                       = var.monitor_diagnostic_setting_name
  target_resource_id         = azurerm_mssql_database.mysqldb.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.sqlworkspace.id

  enabled_log {
    category = "SQLSecurityAuditEvents"
  }
  metric {
    category = "AllMetrics"
  }
}
