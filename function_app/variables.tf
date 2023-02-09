variable "location" {
  description = "The supported azure location where the resource exists"
  type        = string
  default     = "East US"
}

variable "postfix" {
  description = "A postfix string to centrally mitigate resource name collisions."
  type        = string
  default     = "7386320"
}

variable "resource_group_name" {
  type = string 
  default = "Devops-RG"
}