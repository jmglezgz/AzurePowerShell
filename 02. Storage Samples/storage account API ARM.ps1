<#######################################################################################################################
Script . Install and import Azure Powershell throw PowerShell Console (ARM version)
    more info: https://azure.microsoft.com/en-us/documentation/articles/storage-dotnet-how-to-use-blobs/ (ASM version)
   

Prerequisites:
    How to install and configure PowerShell
    https://azure.microsoft.com/en-us/documentation/articles/powershell-install-configure/


WARNING:
Azure Service Management ASM (Classic Development model) vs Azure Resource Management ARM (Resource Development Model)
The Azure Service Management (ASM) cmdlets are ONLY for legacy compatibility and will be removed in a future release. 
Please use the ARM version of this cmdlet (ARM, Azure Resource Management)
more information: https://azure.microsoft.com/en-us/documentation/articles/resource-manager-deployment-model/

########################################################################################################################>

#
#Login and config Azure ARM Subscription
#
Login-AzureRmAccount #Login an use ARM API
#Add-AzureAccount #Login an use ASM API

#Show current context profile
Get-AzureRmContext


#
# Variables and parameters
#

#Give a resource group name
$rgName="rg-MyFirstVM-JMG"
#Giva a name of your active subscription
$subscr="Azure Pass"

# Choose "North Europe" as an example. Use Get-AzureLocation to view datacenters name
$Location = "North Europe"


#
#Storage Account
#
# Give a name to your new storage account. It must be lowercase!
$saName="samysecondstg77"
# test whether a chosen storage account name is globally unique (False: don't exist - is unique/ TRUE: exist - is not unique)
Test-AzureName -Storage $saName

$saType="Standard_LRS"
New-AzureRmStorageAccount -Name $saName -ResourceGroupName $rgName –Type $saType -Location $locName


#
# Create a storage container blob
#
# To select the default storage context for your current session
Set-AzureRmCurrentStorageAccount –ResourceGroupName $rgName –StorageAccountName $saName

#View if storage account has been asigned to context #$storageContext = New-AzureStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $StorageAccountKey
Get-AzureRmContext

# Create a container blob
$ContainerName = "image"
New-AzureStorageContainer -Name $ContainerName -Permission Off


#
# Upload an image to Storage Account container named images/
#
# Have an image file and a source directory in your local computer.
$ImageToUpload = "C:\IT\in\bg.jpg"

# A destination directory in your local computer.
$DestinationFolder = "C:\IT\out\"
# Upload a blob into a container.
Set-AzureStorageBlobContent -Container $ContainerName -File $ImageToUpload -Blob conseguido.jpg -BlobType Block

# List all blobs in a container.
Get-AzureStorageBlob -Container $ContainerName

# Download blobs from the container:
# Get a reference to a list of all blobs in a container.
$blobs = Get-AzureStorageBlob -Container $ContainerName

# Download blobs into the local destination directory.
$blobs | Get-AzureStorageBlobContent –Destination $DestinationFolder




























#
# Create a new storage account.
# 
New-AzureStorageAccount –StorageAccountName $StorageAccountName -Location $Location #ASM version


# Set a default storage account.
Set-AzureSubscription -CurrentStorageAccountName $StorageAccountName -SubscriptionName $SubscriptionName

# Create a new container.
New-AzureStorageContainer -Name $ContainerName -Permission Off

# Upload a blob into a container.
Set-AzureStorageBlobContent -Container $ContainerName -File $ImageToUpload

# List all blobs in a container.
Get-AzureStorageBlob -Container $ContainerName

# Download blobs from the container:
# Get a reference to a list of all blobs in a container.
$blobs = Get-AzureStorageBlob -Container $ContainerName

# Create the destination directory.
New-Item -Path $DestinationFolder -ItemType Directory -Force  

# Download blobs into the local destination directory.
$blobs | Get-AzureStorageBlobContent –Destination $DestinationFolder
#end