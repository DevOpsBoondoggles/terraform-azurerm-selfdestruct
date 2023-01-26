terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0"
    }
    local = {
      source = "hashicorp/local"
      version = ">=2.3.0"
    }
  }
}


resource "azurerm_automation_account" "selfdestruct" {
  name                = var.resource_group_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "Basic"
  tags = {
    environment = "github.com/gabrielmccoll/terraform-azurerm-selfdestruct"
  }
  identity {
    type = "SystemAssigned"
  }
}

#give permissions to the automation account to be able to delete the resource group
resource "azurerm_role_assignment" "auto_rg" {
  role_definition_name = "Contributor"
  scope = var.resource_group_id
  principal_id = azurerm_automation_account.selfdestruct.identity[0].principal_id
}


### Script you want to run, in my case to delete
data "local_file" "demo_ps1" {
    filename = "${path.module}/runbooks/destroy.ps1"
}

### Create the runbook with the powershell script
resource "azurerm_automation_runbook" "destroy" {
  name                = azurerm_automation_account.selfdestruct.name
  location            = azurerm_automation_account.selfdestruct.location
  resource_group_name = azurerm_automation_account.selfdestruct.resource_group_name
  automation_account_name = azurerm_automation_account.selfdestruct.name
  log_verbose             = "true"
  log_progress            = "true"
  description             = "This Run Book will destroy ${var.resource_group_name} in ${var.hours} hours"
  runbook_type            = "PowerShell"
  content                 = data.local_file.demo_ps1.content
}

### a Schedule and linking the schedule to the runbook
resource "azurerm_automation_schedule" "destroy" {
  name                    = "destroy ${var.resource_group_name} in ${var.hours}"
  resource_group_name = azurerm_automation_account.selfdestruct.resource_group_name
  automation_account_name = azurerm_automation_account.selfdestruct.name
  frequency               = "Hour"
  interval                = var.hours
  timezone                = "Etc/UTC" 
  description             = "Run after X hour"
  start_time = timeadd(local.timenow, "${var.hours}h")
  expiry_time = timeadd(local.timenow, "24h")
 lifecycle { # this is so if you reapply the TF due to changes it doesn't reset the timer.
   ignore_changes = [
     start_time,
     expiry_time
   ]
 }
}

resource "azurerm_automation_job_schedule" "destroy" {
  resource_group_name = azurerm_automation_account.selfdestruct.resource_group_name
  automation_account_name = azurerm_automation_account.selfdestruct.name
  schedule_name           = azurerm_automation_schedule.destroy.name
  runbook_name            = azurerm_automation_runbook.destroy.name

}

### adding in variables to pass to the scripts
resource "azurerm_automation_variable_string" "rgname" {
  name                    = "rgname"
  resource_group_name = azurerm_automation_account.selfdestruct.resource_group_name
  automation_account_name = azurerm_automation_account.selfdestruct.name
  value                   = azurerm_automation_account.selfdestruct.resource_group_name
}



