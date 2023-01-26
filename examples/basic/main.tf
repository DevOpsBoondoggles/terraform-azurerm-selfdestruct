terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0"
    }
  }
}
# put everything in one resource group
resource "azurerm_resource_group" "example" {
  name = "Example Resource Group to be destroyed"
}

resource "azurerm_linux_virtual_machine_scale_set" "example" {
    name = "Example resource that will be destroyed"
    resource_group_name = azurerm_resource_group.example.name
    location = resource_group_name = azurerm_resource_group.example.location
}

module "destroy" {
  source = "gabrielmccoll/selfdestruct/azurerm"
  resource_group_name = azurerm_resource_group.example.name
  hours = 1
  depends_on = [
    azurerm_resource_group.example #you will need a depends on for the rg you're going to delete or the module will error
  ]
}