resource "azurerm_virtual_network" "MyVNET" {
  name                = "MyVnet"
  resource_group_name = azurerm_resource_group.MyRG.name
  location            = azurerm_resource_group.MyRG.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "MySubnet" {
  name                 = "MySubnet"
  resource_group_name  = azurerm_resource_group.MyRG.name
  virtual_network_name = azurerm_virtual_network.MyVNET.name
  address_prefixes     = ["10.0.1.0/24"]

}

resource "azurerm_subnet" "IntegrationSubnet" {
  name                 = "IntegrationSubnet"
  resource_group_name  = azurerm_resource_group.MyRG.name
  virtual_network_name = azurerm_virtual_network.MyVNET.name
  address_prefixes     = ["10.0.2.0/24"]

  delegation {
    name = "WebAppDelegation"
    service_delegation {
      name = "Microsoft.Web/serverFarms"
    }
  }
}


#Creating a SQL private endpoint and its DNS Zone and records
resource "azurerm_private_endpoint" "SQLPrivateEndpoint" {
  name                = "sql-private-endpoint"
  location            = azurerm_resource_group.MyRG.location
  resource_group_name = azurerm_resource_group.MyRG.name
  subnet_id           = azurerm_subnet.MySubnet.id

  private_service_connection {
    name                           = "SQLPrivateLink"
    private_connection_resource_id = azurerm_mssql_server.MySQLServer.id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }
}

resource "azurerm_private_dns_zone" "SQL_DNS_ZONE" {
  name                = "privatelink.database.windows.net"
  resource_group_name = azurerm_resource_group.MyRG.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "SQL_DNS_VNET_Link" {
  name                  = "sqlPrivateDnsVnetLink"
  resource_group_name   = azurerm_resource_group.MyRG.name
  private_dns_zone_name = azurerm_private_dns_zone.SQL_DNS_ZONE.name
  virtual_network_id    = azurerm_virtual_network.MyVNET.id
}

resource "azurerm_private_dns_a_record" "SQL_DNS_Record" {
  name                = azurerm_mssql_server.MySQLServer.name
  zone_name           = azurerm_private_dns_zone.SQL_DNS_ZONE.name
  resource_group_name = azurerm_resource_group.MyRG.name
  ttl                 = 300
  records             = [azurerm_private_endpoint.SQLPrivateEndpoint.private_service_connection[0].private_ip_address]
}

#Creating a VNET Integration for WEB  APP
resource "azurerm_app_service_virtual_network_swift_connection" "WEBAPP_VNET_Integration" {
  app_service_id = azurerm_windows_web_app.MyWebApp.id
  subnet_id      = azurerm_subnet.IntegrationSubnet.id
}