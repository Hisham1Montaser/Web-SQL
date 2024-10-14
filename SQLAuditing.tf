resource "azurerm_log_analytics_workspace" "SQLWorkSpace" {
  name                = "SQLWorkSpace"
  location            = azurerm_resource_group.MyRG.location
  resource_group_name = azurerm_resource_group.MyRG.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_mssql_database_extended_auditing_policy" "SQLAuditing" {
  database_id            = azurerm_mssql_database.MySQLDB.id
  log_monitoring_enabled = true
}
resource "azurerm_monitor_diagnostic_setting" "diag" {
  name                       = "${azurerm_mssql_database.MySQLDB.name}-diag-setting"
  target_resource_id         = azurerm_mssql_database.MySQLDB.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.SQLWorkSpace.id

  enabled_log {
    category = "SQLSecurityAuditEvents"
  }
  metric {
    category = "AllMetrics"
  }
}
