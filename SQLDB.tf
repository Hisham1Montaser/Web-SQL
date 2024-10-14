resource "azurerm_mssql_server" "MySQLServer" {
  name                = "bastawisisqlserver"
  resource_group_name = azurerm_resource_group.MyRG.name
  location            = azurerm_resource_group.MyRG.location
  version             = "12.0"

  azuread_administrator {
    login_username              = "Hisham"
    object_id                   = "3616fdcf-2b13-407d-a86e-4a1a79715b51"
    azuread_authentication_only = true
  }
}

resource "azurerm_mssql_database" "MySQLDB" {
  name         = "SP"
  server_id    = azurerm_mssql_server.MySQLServer.id
  collation    = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "LicenseIncluded"
  max_size_gb  = 2
  sku_name     = "Basic"
}

resource "azurerm_mssql_firewall_rule" "SQLfirewallrule" {
  name             = "AllowMyIP"
  server_id        = azurerm_mssql_server.MySQLServer.id
  start_ip_address = "156.214.251.90"
  end_ip_address   = "156.214.251.90"
}