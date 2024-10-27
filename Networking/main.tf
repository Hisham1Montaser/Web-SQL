resource "azurerm_virtual_network" "myvnet" {
  name                = var.virtual_network_name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.address_space
}

resource "azurerm_subnet" "mainsubnet" {
  name                 = var.main_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = var.main_subnet_prefixes
}

resource "azurerm_subnet" "integrationsubnet" {
  name                 = var.integration_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = var.integration_subnet_prefixes

  delegation {
    name = var.delegation_name
    service_delegation {
      name = "Microsoft.Web/serverFarms"
    }
  }
}

# Creating a SQL private endpoint and its DNS Zone and records
resource "azurerm_private_endpoint" "sqlprivateendpoint" {
  name                = var.private_endpoint_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = azurerm_subnet.mainsubnet.id

  private_service_connection {
    name                           = var.private_service_connection_name
    private_connection_resource_id = var.sql_server_id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }
}

resource "azurerm_private_dns_zone" "sql_dns_zone" {
  name                = var.private_dnszone_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "sql_dns_vnet_link" {
  name                  = var.dnszone_link_name
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.sql_dns_zone.name
  virtual_network_id    = azurerm_virtual_network.myvnet.id
}

resource "azurerm_private_dns_a_record" "sql_dns_record" {
  name                = var.sql_server_name
  zone_name           = var.private_dnszone_name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = [azurerm_private_endpoint.sqlprivateendpoint.private_service_connection[0].private_ip_address]
}

# Creating a VNET Integration for Web App
resource "azurerm_app_service_virtual_network_swift_connection" "webapp_vnet_integration" {
  app_service_id = var.app_service_id
  subnet_id      = azurerm_subnet.integrationsubnet.id
}
