output "sql_server_id" {
  value = azurerm_mssql_server.mysqlserver.id
}

output "sql_db_id" {
  value = azurerm_mssql_database.mysqldb.id
}

output "sql_workspace_id" {
  value = azurerm_log_analytics_workspace.sqlworkspace.id
}
