$rgname = Get-AutomationVariable -Name 'rgname' #terraform created this
# Ensures you do not inherit an AzContext in your runbook
Disable-AzContextAutosave -Scope Process

# Connect to Azure with system-assigned managed identity
$AzureContext = (Connect-AzAccount -Identity).context

# set and store context
$AzureContext = Set-AzContext -SubscriptionName $AzureContext.Subscription -DefaultProfile $AzureContext



Remove-AzResourceGroup `
		-Name $rgname `
        -Force
