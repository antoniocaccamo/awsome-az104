terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.22.0"
    }
  }
  backend "local" {
    path = "./.workspace/terraform.tfstate"
  }
}

### Variables ###

locals {
  password = "DemoPassword!123"
}

### Azure Active Directory ###

data "azuread_client_config" "current" {}

data "azuread_domains" "aad_domains" {
  only_default = true
}

# Groups

resource "azuread_group" "group1" {
  display_name     = "Microsoft 365 Group - Assigned"
  security_enabled = true
  mail_enabled     = true
  mail_nickname    = "Microsoft365GroupAssigned"
  types            = ["Unified"]
}

resource "azuread_group" "group2" {
  display_name     = "Security Group - Assigned"
  security_enabled = true
}

resource "azuread_group" "group3" {
  display_name     = "Microsoft 365 Group - Dynamic"
  security_enabled = true
  mail_enabled     = true
  mail_nickname    = "Microsoft365GroupDynamic"
  types            = ["Unified"]

  dynamic_membership {
    enabled = true
    rule    = "user.department -eq \"Finances\""
  }
}

resource "azuread_group" "group4" {
  display_name     = "Security Group - Dynamic"
  security_enabled = true
  types            = ["DynamicMembership"]

  dynamic_membership {
    enabled = true
    rule    = "user.department -eq \"Sales\""
  }
}


# Users

resource "azuread_user" "user1" {
  user_principal_name = "user1@${data.azuread_domains.aad_domains.domains[0].domain_name}"
  display_name        = "User1"
  password            = local.password
}

resource "azuread_user" "user2" {
  user_principal_name = "user2@${data.azuread_domains.aad_domains.domains[0].domain_name}"
  display_name        = "User2"
  password            = local.password
}

resource "azuread_user" "user3" {
  user_principal_name = "user3@${data.azuread_domains.aad_domains.domains[0].domain_name}"
  display_name        = "User3"
  password            = local.password
}
