
variable "location" {
  description = "The location to set for the storage account."
  type        = string
  default = "East US"
}

variable "rg_name" {
  type        = string 
  default = "Devops-RG"
}

variable "storage_account_kind" {
  description = "The kind of storage account to set"
  type        = string
  default = "StorageV2"
}

variable "storage_account_tier" {
  description = "The tier of storage account to set"
  type        = string
  default = "Standard"
}

variable "storage_replication_type" {
  description = "The replication type of storage account to set"
  type        = string
  default = "LRS"
}

variable "container_access_type" {
  description = "The replication type of storage account to set"
  type        = string
  default     = "private"
}

variable "postfix" {
  type        = string 
  default     = "4593734"
}