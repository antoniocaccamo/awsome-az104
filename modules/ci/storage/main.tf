terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.9.0"
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
  default     = "brazilsouth"
  sensitive   = false
  description = "Change this to a location near you"
}

variable "storage_account_name" {
  default     = "stawsomeaz104"
  sensitive   = false
  description = "Change in case the default is already taken"
}

variable "image_build" {
  description = "Add your image path to .auto.tfvars"
}

locals {
  app_affix = "awsomeaz104"
}

### Azure Active Directory ###

### Resources ###

resource "azurerm_resource_group" "default" {
  name     = "rg-${local.app_affix}"
  location = var.location
}

resource "azurerm_storage_account" "storage" {
  name                     = var.storage_account_name
  location                 = azurerm_resource_group.default.location
  resource_group_name      = azurerm_resource_group.default.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "blobs" {
  name                 = "blobs"
  storage_account_name = azurerm_storage_account.storage.name
}

resource "azurerm_container_group" "app1" {
  name                = "ci-awsomeaz104"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  ip_address_type     = "Public"
  dns_name_label      = "ci-awsomeaz104"
  os_type             = "Linux"

  container {
    name   = "app1"
    image  = var.image_build
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 80
      protocol = "TCP"
    }
  }
}
