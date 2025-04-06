# Create a resource group
resource "azurerm_resource_group" "lms-rg" {
  name     = "lms-resources"
  location = "East US"
}

# Create Virtual Network 
resource "azurerm_virtual_network" "lms-vnet" {
  name                = "lms-vnet"
  location            = azurerm_resource_group.lms-rg.location
  resource_group_name = azurerm_resource_group.lms-rg.name
  address_space       = ["10.0.0.0/16"]
}

