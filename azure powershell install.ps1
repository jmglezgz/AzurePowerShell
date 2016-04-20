<#######################################################################################################################
Script 1. Install and import Azure Powershell throw PowerShell Console
    more info: https://azure.microsoft.com/en-us/documentation/articles/powershell-install-configure/
    s
Prerequisites:
    PowerShell
    https://azure.microsoft.com/en-us/documentation/articles/powershell-install-configure/


WARNING:
Azure Service Management ASM (Classic Development model) vs Azure Resource Management ARM (Resource Development Model)
The Azure Service Management (ASM) cmdlets are ONLY for legacy compatibility and will be removed in a future release. 
Please use the ARM version of this cmdlet (ARM, Azure Resource Management)
more information: https://azure.microsoft.com/en-us/documentation/articles/resource-manager-deployment-model/

########################################################################################################################>

###########################################################
#AZURE RESOURCE MANAGEMENT ARM (RESOURCE DEVELOPMENT MODEL)
###########################################################

#Run commands below With administrator elevated permissions
Set-ExecutionPolicy RemoteSigned

# Install the Azure Resource Manager modules from the PowerShell Gallery
#NOTE: User -force if you need to force an instalation
Install-Module AzureRM
#Deprecated: Install-AzureRM


# Import AzureRM modules for the given version manifest in the AzureRM module
# Deprecated: Import-AzureRM
Import-Module AzureRM


# To make sure the Azure PowerShell module is available after you install
Get-Module –ListAvailable 

# To login to Azure Resource Manager
Login-AzureRmAccount

# You can also use a specific Tenant if you would like a faster login experience
# Login-AzureRmAccount -TenantId xxxx

# To subscriptions for your account
Get-AzureRmSubscription

# To select a default subscription for your current session
$subName= “<your sub>”
Get-AzureRmSubscription –SubscriptionName $subName | Select-AzureRmSubscription



###########################################################
#AZURE SERVICE MANAGEMENT ASM (CLASSIC DEVELOPMENT MODEL)
###########################################################

# Install the Azure Service Management module from the PowerShell Gallery
#NOTE: User -force if you need to force an instalation
Install-Module Azure


# Import Azure Service Management module
Import-Module Azure

# ASM: add your Azure account to the local PowerShell environment
Add-azureAccount

# To view all subscriptions for your account
Get-AzureSubscription
Get-AzureSubscription -Default



# View your current Azure PowerShell session context
# This session state is only applicable to the current session and will not affect other sessions
Get-AzureRmContext

# To select the default storage context for your current session
Set-AzureRmCurrentStorageAccount –ResourceGroupName “your resource group” –StorageAccountName “your storage account name”

# View your current Azure PowerShell session context
# Note: the CurrentStorageAccount is now set in your session context
Get-AzureRmContext

# To list all of the blobs in all of your containers in all of your accounts
Get-AzureRmStorageAccount | Get-AzureStorageContainer | Get-AzureStorageBlob




###########################################################
#OTHER UTIL CMD-LETS
###########################################################

#Azure Module version
Get-Module azure | format-table version

#find all the available datacenter locations
Get-AzureLocation | format-Table -Property Name, AvailableServices, StorageAccountTypes


#all the available PowerShell cmdlets for Azure Storage
Get-Command -Module Azure -Noun *Storage*

