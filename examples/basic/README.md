Basic example of how to use the module.
In this case all resources are in the single resource group.
``` terraform
module "destroy" {
  source = "gabrielmccoll/selfdestruct/azurerm"
  resource_group_name = azurerm_resource_group.example.name
  hours = 1
  depends_on = [
    azurerm_resource_group.example #you will need a depends on for the rg you're going to delete or the module will error
  ]
}
```
