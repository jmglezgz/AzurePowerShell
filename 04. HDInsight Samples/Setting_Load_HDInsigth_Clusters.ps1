<#
#DEMO 1. Configuring HDInsight Cluster and Loading Data

Big Data Sample
Census data site: https://www.census.gov/popest/research/modified.html
Pre-requisites: Strip out the heading from both files and save as .dat file

PowerShell
https://azure.microsoft.com/en-us/documentation/articles/powershell-install-configure/
#>

########################################################################
# Setting up Subscription, HDInsight Cluster and Storage Account
########################################################################

#Azure Service Management ASM (Classic Development model)
#WARNING: The Azure Service Management (ASM) cmdlets for HDInsight are deprecated and will be removed in a future release. 
#Please use the ARM version of this cmdlet (ARM, Azure Resource Management)
# more information: https://azure.microsoft.com/en-us/documentation/articles/resource-manager-deployment-model/

#Specify the values
$clusterName = "{PUT YOUR HDINSIGHT CLUSTER NAME}"
$subId = "{PUT YOUR SUBSCRIPTION ID}"

#Login to your azure subscription
$sub = Get-AzureRmSubscription -ErrorAction SilentlyContinue
if (-not ($sub))
{
    Login-AzureRmAccount
}

#If you have more than one subscription with your account, then select what you working on
Select-AzureRmSubscription -SubscriptionId $subId


#Get HTTPS/Admin credentials for submitting the job later
$creds = Get-Credential

#Get the cluster info so we can get the resource group, storage, etc.
$clusterInfo = Get-AzureRmHDInsightCluster -ClusterName $clusterName
$resourceGroup = $clusterInfo.ResourceGroup
$storageAccountName = $clusterInfo.DefaultStorageAccount.split('.')[0]
$container = "hdinsight" #clusterInfo.DefaultStorageContainer
$storageAccountKey = Get-AzureRmStorageAccountKey `    -Name $storageAccountName `    -ResourceGroupName $resourceGroup `    | %{$_.Key1}#Create a storage content and upload the file$context = New-AzureStorageContext `    -StorageAccountName $storageAccountName `    -StorageAccountKey $storageAccountKey
########################################################################
#Upload data to Storage account to use in HDinsight cluster
########################################################################

#Copy the census files from local workstation to blog container
Set-AzureStorageBlobContent -File C:\it\data\STCO-MR2010_AL_MO.dat -Blob "data/census/STCO-MR2010_AL_MO.dat" -Container $container -context $context
Set-AzureStorageBlobContent -File C:\IT\data\STCO-MR2010_MT_WY.dat -Blob "data/census/STCO-MR2010_MT_WY.dat"-Container $container -context $context

#List the files
Get-AzureStorageBlob -Container $container -context $context -Blob "data/census/*" | ft -a