# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.65"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

# Confgiure the resource group for the project
resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group_name[terraform.workspace]}rg"
  location = local.location
  tags = {
    Environment = terraform.workspace
  }
}

module "vms" {
  source         = "./modules/vms"
  prefix         = var.prefix[terraform.workspace]
  rg-name        = local.rg-name
  location       = local.location
  instance_count = var.instance_count
  vm_size        = var.vm_size[terraform.workspace]
  DataTierNSG_id = azurerm_network_security_group.DataTierNSG.id
  WebTierNSG_id  = azurerm_network_security_group.WebTierNSG.id
  admin-user     = var.admin-user
  admin-password = var.admin-password
}

locals {
  location = var.location[terraform.workspace]
  prefix   = var.prefix[terraform.workspace]
  rg-name  = azurerm_resource_group.rg.name
}

