<#
#DEMO 1. Setting up, create and destroy HDInsight Cluster

PowerShell
https://azure.microsoft.com/en-us/documentation/articles/powershell-install-configure/

#Azure Service Management ASM (Classic Development model)
#WARNING: The Azure Service Management (ASM) cmdlets for HDInsight are deprecated and will be removed in a future release. 
#Please use the ARM version of this cmdlet (ARM, Azure Resource Management)
# more information: https://azure.microsoft.com/en-us/documentation/articles/resource-manager-deployment-model/

#>


########################################################################
# Setting up Subscription, HDInsight Cluster and Storage Account
########################################################################

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
$sub = Get-AzureRmSubscription -SubscriptionId $subId



#Get HTTPS/Admin credentials for submitting the job later
$creds = Get-Credential

#Get storage Account info so we can get the resource group, storage, etc.
$subscriptionName = $sub.SubscriptionName
$resourceGroup = "mscloudbigdatagroup" #$clusterInfo.ResourceGroup 
$storageAccountName = "mscloudbigdatastorage" #$clusterInfo.DefaultStorageAccount.split('.')[0]
$location = "North Europe"
$storageContainer = "hdinsight2"
$storageAccountKey = Get-AzureRmStorageAccountKey `    -Name $storageAccountName `    -ResourceGroupName $resourceGroup `    | %{$_.Key1}#Create a storage content and upload the file$context = New-AzureStorageContext `    -StorageAccountName $storageAccountName `    -StorageAccountKey $storageAccountKey########################################################################
# Create New Cluster
########################################################################
# Create the cluster
New-AzureRmHDInsightCluster `
    -ClusterType Hadoop `
    -OsType Window `
    -Version Hadoop26 `
    -ClusterSizeInNodes 4 `
    -ResourceGroupName $resourceGroup `
    -ClusterName $clusterName `
    -HttpCredential $creds `
    -Location $location `
    -DefaultStorageAccountName "$storageAccountName.blob.core.windows.net"  `
    -DefaultStorageAccountKey $storageAccountKey `
    -DefaultStorageContainer $storageContainer 

$clusterInfo = Get-AzureRmHDInsightCluster -ClusterName $clusterName
$container = $clusterInfo.DefaultStorageContainer

########################################################################
# Create New Cluster
########################################################################

# Remove-AzureRmHDInsightCluster -ClusterName $clusterName