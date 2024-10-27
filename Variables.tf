#Root module variables
variable "resource_group_name" {
}

# WebApp module variables
variable "location" {
}

variable "app_service_plan_name" {
}

variable "windows_webapp_name" {
}

variable "webapp_log_analytics_workspace_name" {
}

variable "webapp_application_insights_name" {
}



# Networking module variables
variable "virtual_network_name" {
}

variable "address_space" {
}

variable "main_subnet_name" {
}

variable "main_subnet_prefixes" {
}


variable "integration_subnet_name" {
}


variable "integration_subnet_prefixes" {
}

variable "delegation_name" {
}

variable "private_endpoint_name" {
}

variable "private_service_connection_name" {
}

variable "private_dnszone_name" {
}

variable "dnszone_link_name" {
}

variable "sql_server_name" {
}

variable "sql_dns_record_name" {
}


# SQL module variables


variable "sql_login_username" {
}

variable "sql_login_password" {
  sensitive = true

}

variable "sql_username_objectid" {
}

variable "sql_db_name" {
}

variable "sql_workspace_name" {
}

variable "monitor_diagnostic_setting_name" {
}


variable "my_public_ip" {
}
