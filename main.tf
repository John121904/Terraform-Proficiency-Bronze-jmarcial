# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-terraform-tfstate"
    storage_account_name = "tfstate31802"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

# Create local variables
locals {
  assetname   = "3Cloud"
  environment = "dev"
  location    = "eastus"

  resource_name = format("%s-%s", local.assetname, local.environment)
}

# Create Resource Group Name
resource "azurerm_resource_group" "resource_group" {
  name     = "rg-${local.resource_name}"
  location = local.location
}

# Create Application Service Plan
module "asp" {
  source   = "./modules/app-service-plan"
  asp_name = "asp-${local.resource_name}"
  rg_name  = azurerm_resource_group.resource_group.name
  location = azurerm_resource_group.resource_group.location
}

# Create Application Service (with Instance count)
module "webapp" {
  source = "./modules/app-service"
  webapp = "webapp-${local.resource_name}"
  rg_name = azurerm_resource_group.resource_group.name
  location = module.asp.location
  asp_id = module.asp.asp_id
  instance_count = 2
}