<#######################################################################################################################
Script . Using Azure PowerShell with Azure Storage
    more info: https://azure.microsoft.com/en-us/documentation/articles/storage-powershell-guide-full/
   

Prerequisites:
    How to install and configure PowerShell
    https://azure.microsoft.com/en-us/documentation/articles/powershell-install-configure/


WARNING:
Azure Service Management ASM (Classic Development model) vs Azure Resource Management ARM (Resource Development Model)
The Azure Service Management (ASM) cmdlets are ONLY for legacy compatibility and will be removed in a future release. 
Please use the ARM version of this cmdlet (ARM, Azure Resource Management)
more information: https://azure.microsoft.com/en-us/documentation/articles/resource-manager-deployment-model/

########################################################################################################################>


# Update with the name of your subscription.
$SubscriptionName="Azure Pass"

# Give a name to your new storage account. It must be lowercase!
$StorageAccountName="jmgstacc02"

# Choose "West US" as an example. Use Get-AzureLocation to view datacenters name
$Location = "North Europe"

# Give a name to your new container.
$ContainerName = "jmgcontainer01"

# Have an image file and a source directory in your local computer.
$ImageToUpload = "C:\IT\temp\bg.jpg"

# A destination directory in your local computer.
$DestinationFolder = "C:\IT\temp\"

# Add your Azure account to the local PowerShell environment.
Add-AzureAccount

# Set a default Azure subscription.
Select-AzureSubscription -SubscriptionName $SubscriptionName #deprecated: –Default

# Create a new storage account.
New-AzureStorageAccount –StorageAccountName $StorageAccountName -Location $Location

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
