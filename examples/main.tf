module "destroy" {
  source = "gabrielmccoll/terraform-azurerm-selfdestruct"
  resource_group_name = azurerm_resource_group.example.name
  hours = 1
  depends_on = [
    azurerm_resource_group.example #you will need a depends on for the rg you're going to delete or the module will error
  ]
}