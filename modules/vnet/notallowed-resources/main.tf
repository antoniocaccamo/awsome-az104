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
  }
}

### Variables ###

variable "location" {
  default     = "brazilsouth"
  sensitive   = false
  description = "Use .auto.tfvars to set a location near you"
}

variable "subscription_name_prefix" {
  default   = "Pay-As-You-Go"
  sensitive = false
}

### Resources ###

# Resource Groups

resource "azurerm_resource_group" "rg1" {
  name     = "RG1"
  location = var.location
}

resource "azurerm_resource_group" "rg2" {
  name     = "RG2"
  location = var.location
}

# Virtual Networks

resource "azurerm_virtual_network" "vnet1" {
  name                = "VNET1"
  address_space       = ["10.10.0.0/16"]
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
}

resource "azurerm_virtual_network" "vnet2" {
  name                = "VNET2"
  address_space       = ["10.20.0.0/16"]
  location            = azurerm_resource_group.rg2.location
  resource_group_name = azurerm_resource_group.rg2.name
}

# Virtual Machines

resource "azurerm_subnet" "subnet_vm" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.rg2.name
  virtual_network_name = azurerm_virtual_network.vnet2.name
  address_prefixes     = ["10.20.0.0/24"]
}


resource "azurerm_network_interface" "default" {
  name                = "nic-VM1"
  location            = azurerm_resource_group.rg2.location
  resource_group_name = azurerm_resource_group.rg2.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.subnet_vm.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "default" {
  name                = "VM1"
  resource_group_name = azurerm_resource_group.rg2.name
  location            = azurerm_resource_group.rg2.location
  size                = "Standard_DS1_v2"

  disable_password_authentication = false
  admin_username                  = "adminuser"
  admin_password                  = "P@$$w0rd1234!"

  network_interface_ids = [
    azurerm_network_interface.default.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}

# Policies
resource "azurerm_resource_group_policy_assignment" "default" {
  name                 = "Not Allowed Resource Types"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/6c112d4e-5bc7-47ae-a041-ea2d9dccd749"
  resource_group_id    = azurerm_resource_group.rg2.id
  enforce              = true

  parameters = <<PARAMETERS
    {
      "listOfResourceTypesNotAllowed": { 
        "value": [ "Microsoft.ClassicNetwork/virtualNetworks", "Microsoft.Network/virtualNetworks", "Microsoft.Compute/virtualMachines" ]
      }
    }
  PARAMETERS

  depends_on = [
    azurerm_linux_virtual_machine.default
  ]
}
