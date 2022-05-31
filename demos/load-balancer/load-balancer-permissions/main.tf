terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.8.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.22.0"
    }
  }
  backend "local" {
    path = "./.workspace/terraform.tfstate"
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

### Variables ###

variable "location" {
  default   = "eastus"
  sensitive = false
}

locals {
  app_affix = "awsomeaz104-loadbalancer-permissions-demo"
  password  = "DemoPassword!123"
}

### Azure Active Directory ###

data "azuread_domains" "aad_domains" {
  only_default = true
}

resource "azuread_user" "admin1" {
  user_principal_name = "Admin1@${data.azuread_domains.aad_domains.domains[0].domain_name}"
  display_name        = "Admin1"
  password            = local.password
}

### Resources ###

resource "azurerm_resource_group" "default" {
  name     = "rg-${local.app_affix}"
  location = var.location
}

resource "azurerm_role_assignment" "read" {
  scope                = azurerm_resource_group.default.id
  role_definition_name = "Reader"
  principal_id         = azuread_user.admin1.object_id
}

# Internal Load Balancer

resource "azurerm_virtual_network" "default" {
  name                = "vnet-${local.app_affix}"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "lbi" {
  name                 = "LBI-Subnet"
  resource_group_name  = azurerm_resource_group.default.name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_lb" "lbi" {
  name                = "lbi-${local.app_affix}"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name

  frontend_ip_configuration {
    name                          = "PrivateIPAddress"
    subnet_id                     = azurerm_subnet.lbi.id
    private_ip_address_allocation = "Dynamic"
  }

}


# External Load Balancer

resource "azurerm_public_ip" "lbe" {
  name                = "pip-${local.app_affix}"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  allocation_method   = "Static"
}

resource "azurerm_lb" "lbe" {
  name                = "lbe-${local.app_affix}"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lbe.id
  }
}

### Outputs

output "admin1_object_id" {
  value     = azuread_user.admin1.object_id
  sensitive = false
}

output "admin1_principal_name" {
  value     = azuread_user.admin1.user_principal_name
  sensitive = false
}
