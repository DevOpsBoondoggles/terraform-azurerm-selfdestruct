variable "resource_group_name" {
  type = string
  description = "The name of the resource group the Automation Account will be created and which will be deleted"
}

variable "hours" {
  type = number
  description = "the number of hours before the deployment self destructs"
}