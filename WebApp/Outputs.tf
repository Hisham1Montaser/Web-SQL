output "webapp_service_id" {
  value = azurerm_windows_web_app.mywebapp.id
  description = "ID of the Azure Windows Web App"
}
