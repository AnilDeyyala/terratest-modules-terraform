variable "postfix" {
  description = "A postfix string to centrally mitigate resource name collisions"
  type        = string
  default     = "resource"
}

variable "location" {
  description = "The location to set for the CosmosDB instance."
  default     = "East US"
}

variable "throughput" {
  description = "The RU/s throughput for the database account."
  default     = 400
}

variable "resource_group_name" {
  default = "Devops-RG"
}