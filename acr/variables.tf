variable "sku" {
  description = "SKU tier for the ACR."
  default     = "Standard"
}


variable "postfix" {
  description = "A postfix string to centrally mitigate resource name collisions."
  type        = string
  default     = "1276"
}

variable "rg_name" {
  type = string 
  default = "Devops-RG"
}