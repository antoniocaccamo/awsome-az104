terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.9.0"
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
  default     = "northeurope"
  sensitive   = false
  description = "Use .auto.tfvars to set a location near you"
}

### Resources ###

resource "azurerm_resource_group" "default" {
  name     = "RG26"
  location = var.location
}

resource "azurerm_mssql_server" "azsql01" {
  name                         = "sql-awsomeaz104-zsql01"
  resource_group_name          = azurerm_resource_group.default.name
  location                     = azurerm_resource_group.default.location
  version                      = "12.0"
  administrator_login          = "missadministrator"
  administrator_login_password = "thisIsKat11"
  minimum_tls_version          = "1.2"
}

resource "azurerm_mssql_database" "azsql01_d01" {
  name      = "SQLD01"
  server_id = azurerm_mssql_server.azsql01.id
  collation = "SQL_Latin1_General_CP1_CI_AS"
  # license_type = "LicenseIncluded"
  sku_name = "Basic"
}

resource "azurerm_recovery_services_vault" "vault" {
  name                = "rsv-rgv1"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  sku                 = "Standard"
  soft_delete_enabled = false
}

# Backup VM

resource "azurerm_virtual_network" "default" {
  name                = "vnet-VM1"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.default.name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "default" {
  name                = "nic-VM1"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "default" {
  name                = "VM1"
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
  size                = "Standard_DS1_v2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"

  provision_vm_agent         = true
  allow_extension_operations = true

  network_interface_ids = [
    azurerm_network_interface.default.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
}
