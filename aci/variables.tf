variable "rg_name" {
    default = "Devops-RG"
}

variable "postfix" {
  description = "A postfix string to centrally mitigate resource name collisions."
  type        = string
  default     = "1276"
}
