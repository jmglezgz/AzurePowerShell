<#######################################################################################################################
Script . Create a virtual network by using an ARM template
    more info: https://azure.microsoft.com/en-us/documentation/articles/virtual-networks-create-vnet-arm-template-click/#deploy-the-arm-template-by-using-click-to-deploy/
   

Prerequisites:
    How to install and configure PowerShell
    https://azure.microsoft.com/en-us/documentation/articles/powershell-install-configure/

    Sample Template GitHub
    https://github.com/Azure/azure-quickstart-templates/tree/master/101-vnet-two-subnets
    Download azuredeploy.json and azuredeploy.parameters.json in RAW format

WARNING:
Azure Service Management ASM (Classic Development model) vs Azure Resource Management ARM (Resource Development Model)
The Azure Service Management (ASM) cmdlets are ONLY for legacy compatibility and will be removed in a future release. 
Please use the ARM version of this cmdlet (ARM, Azure Resource Management)
more information: https://azure.microsoft.com/en-us/documentation/articles/resource-manager-deployment-model/

########################################################################################################################>


###############################################
#Login and config Azure ARM Subscription
###############################################
Login-AzureRmAccount #Login an use ARM API
#Add-AzureAccount #Login an use ASM API

Get-AzureRMSubscription | Sort SubscriptionName | Select SubscriptionName
#Get-AzureSubscription | Sort SubscriptionName | Select SubscriptionName

$subscr="Azure Pass"
Select-AzureRMSubscription -SubscriptionName $subscr #ARM API

$subscr="Azure Pass" 
#Select-AzureSubscription -SubscriptionName $subscr #ASM API


#
#Resource group
#
$rgName="rg-MyFirstVM-JMG"

#Lists available Azure Data Center Locations
Get-AzureLocation |select Name, AvailableServices, StorageAccountTypes
$locName="North Europe"

New-AzureRmResourceGroup -Name $rgName -Location $locName

#list your existing resource groups
Get-AzureRmResourceGroup | Sort ResourceGroupName | Select ResourceGroupName

#
#deploy the new VNet by using the template and parameter files you downloaded and modified
#
$vnetName= "TestVNetDeploy77"
New-AzureRmResourceGroupDeployment `    -Name  $vnetName `    -ResourceGroupName $rgName `    -TemplateFile C:\it\in\azuredeploy.json `    -TemplateParameterFile C:\it\in\azuredeploy.parameters.json