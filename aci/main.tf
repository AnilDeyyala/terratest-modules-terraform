provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "rg" {
    name = var.rg_name 
}

resource "azurerm_container_group" "aci" {
  name                = "aci${var.postfix}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_address_type = "Public"
  dns_name_label  = "aci${var.postfix}"
  os_type         = "Linux"

  container {
    name   = "hello-world"
    image  = "mcr.microsoft.com/azuredocs/aci-helloworld:latest"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 443
      protocol = "TCP"
    }
  }

  tags = {
    Environment = "Development"
  }
}