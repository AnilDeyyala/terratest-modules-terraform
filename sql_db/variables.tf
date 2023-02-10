variable "resource_group_name" {
  type = string 
  default = "Devops-RG"
}

variable "sqlserver_admin_login" {
  description = "The administrator login name for the sql server."
  type        = string
  default     = "AdminUser2314"
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = string
  default     = "Development"
}

variable "postfix" {
  description = "A postfix string to centrally mitigate resource name collisions"
  type        = string
  default     = "resource"
}