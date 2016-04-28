<#######################################################################################################################
Script 2. Create and configure a Windows Virtual Machine with Resource Manager and Azure PowerShell
    more info: https://azure.microsoft.com/en-us/documentation/articles/virtual-machines-windows-create-powershell/

Prerequisites:
    How to install and configure PowerShell (https://azure.microsoft.com/en-us/documentation/articles/powershell-install-configure/)
    How to install and configure Azure PowerShell (https://azure.microsoft.com/en-us/documentation/articles/powershell-install-configure/)


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
Add-AzureAccount #Login an use ASM API

Get-AzureRMSubscription | Sort SubscriptionName | Select SubscriptionName
Get-AzureSubscription | Sort SubscriptionName | Select SubscriptionName

$subscr="Azure Pass"
Select-AzureRMSubscription -SubscriptionName $subscr #ARM API

$subscr="Azure Pass" 
Select-AzureSubscription -SubscriptionName $subscr #ASM API


###############################################
#Create resources:
# 1. Resource Group
# 2. Storage Account
# 4. Aviability Set
# 5. NAT Rules
###############################################

#
#Resource group
#

$rgName="rg-MySecondVM-JMG"

#Lists available Azure Data Center Locations
Get-AzureLocation |select Name, AvailableServices, StorageAccountTypes
$locName="North Europe"

New-AzureRmResourceGroup -Name $rgName -Location $locName

#list your existing resource groups
Get-AzureRmResourceGroup | Sort ResourceGroupName | Select ResourceGroupName

#
#Create Resource: Storage Account
#
$saName="samyfirststg76"
#test whether a chosen storage account name is globally unique (False: don't exist - is unique/ TRUE: exist - is not unique)
Test-AzureName -Storage $saName

$saType="Standard_LRS"
New-AzureRmStorageAccount -Name $saName -ResourceGroupName $rgName –Type $saType -Location $locName

#List your existing storage accounts
Get-AzureRmStorageAccount

#
# Aviability Set
#

$avName="av-MyFirstAvSet-JMG"
New-AzureRmAvailabilitySet –Name $avName –ResourceGroupName $rgName -Location $locName

#List all aviablity Set
Get-AzureRmAvailabilitySet –ResourceGroupName $rgName | Sort Name | Select Name

#
# Virtual Network
#
$vnetName="vnet-MyFirstVnet-JMG"
$frontendSubnet=New-AzureRmVirtualNetworkSubnetConfig -Name frontendSubnet -AddressPrefix 10.0.1.0/24
$backendSubnet=New-AzureRmVirtualNetworkSubnetConfig -Name backendSubnet -AddressPrefix 10.0.2.0/24
New-AzureRmVirtualNetwork -Name $vnetName -ResourceGroupName $rgName -Location $locName -AddressPrefix 10.0.0.0/16 -Subnet $frontendSubnet,$backendSubnet

#List existing virtual networks
Get-AzureRmVirtualNetwork -ResourceGroupName $rgName | Sort Name | Select Name


#List index subnet
Get-AzureRmVirtualNetwork -Name $vnetName -ResourceGroupName $rgName | Select Subnets

$subnetIndex=0
$vnet=Get-AzureRmVirtualNetwork -Name $vnetName -ResourceGroupName $rgName

#There are several option to configure NIC on Azure, here you have the basic one. A NIC dynamics IP with a Public IP address
# Other options: https://azure.microsoft.com/en-us/documentation/articles/virtual-machines-windows-create-powershell/
$nicName="nic-MyFirstNIC-JMG"
$pip = New-AzureRmPublicIpAddress -Name $nicName -ResourceGroupName $rgName -Location $locName -AllocationMethod Dynamic
$nic = New-AzureRmNetworkInterface -Name $nicName -ResourceGroupName $rgName -Location $locName -SubnetId $vnet.Subnets[$subnetIndex].Id -PublicIpAddressId $pip.Id

#
# Create Virtual Machine Object
#

$vmName="vm-JMG"

# determine the possible values of the VM size string
Get-AzureRmVMSize -Location $locName | Select Name
$vmSize="Basic_A1"



# Set and fill in the publisher, offer, and SKU names

Get-AzureRmVMImagePublisher -Location $locName | where {$_.PublisherName -like "*Microsoft*"}
$pubName="MicrosoftWindowsServer"
Get-AzureRmVMImageOffer -Location $locName -PublisherName $pubName
$offerName="WindowsServer"

Get-AzureRmVMImageSku -Location $locName -PublisherName $pubName -Offer $offerName
$skuName="2012-R2-Datacenter"


$vmCred=Get-Credential -Message "Type the name and password of the local administrator account."

#Init object $vm with new azure VM Configuration based on name and size
$vm=New-AzureRmVMConfig -VMName $vmName -VMSize $vmSize

$vm=Set-AzureRmVMOperatingSystem -VM $vm -Windows -ComputerName $vmName -Credential $vmCred -ProvisionVMAgent -EnableAutoUpdate
$vm=Set-AzureRmVMSourceImage -VM $vm -PublisherName $pubName -Offer $offerName -Skus $skuName -Version "latest"
$vm.AvailabilitySetReference = $avName
$vm=Add-AzureRmVMNetworkInterface -VM $vm -Id $nic.Id



#set and fill in the name identifier for the operating system disk for the VM
$diskName="myfirstdisk76"
$storageAcc=Get-AzureRmStorageAccount -ResourceGroupName $rgName -Name $saName
$osDiskUri=$storageAcc.PrimaryEndpoints.Blob.ToString() + "vhds/" + $diskName  + ".vhd"
$vm=Set-AzureRmVMOSDisk -VM $vm -Name $diskName -VhdUri $osDiskUri -CreateOption fromImage

#***********************************************************************************

#
# Create Virtual Machine
#

New-AzureRmVM -ResourceGroupName $rgName -Location $locName -VM $vm
