This module is designed to make a terraform deployment self destruct in a certain amount of time. 
Essentially, after `<hours>` it destroys `<resource_group>`.

Use Case:

When deploying terraform resources to test or learn, and you're worried about leaving them running.
While 'terraform destroy' is preferred, this gives a safety net without having to have a CI system involved.

It is recommended to put all your test resources in one Resource Group, though you should be able to call the module twice if needed.  

The mechanism is simple:

The module creates an Automation Account, Runbook and Schedule that triggers in <hours> to delete the Resource Group
that it's deployed in.  The Powershell script that runs it, will be on an Azure runner outside the sub and therefore the script deletes the resource group, all the resources in it, plus the automation that kicked it off in the first place. 

The times of the Runbook and Schedule it creates is in UTC but all times are relative to when created anyway. 
It will repeat the schedule every <hours>, if for some reason the first wasn't successful. 

Again, using Terraform Destroy is preferred. This is a safety net. 

Please see the Example(s)