variable "resource_group_name" {
}

variable "location" {
}

variable "sql_server_name" {
}


variable "sql_login_username" {
}

variable "sql_login_password" {
  sensitive = true

}

variable "sql_db_name" {
}


variable "sql_workspace_name" {
}

variable "monitor_diagnostic_setting_name" {
  description = "Name of the diagnostic setting for SQL Database"
}

variable "sql_username_objectid" {
  
}
variable "my_public_ip" {
}
