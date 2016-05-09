﻿<#
#DEMO 2. Map Reduce Job Hello World

Big Data Sample
Hadoop examples: example/data/gutenberg/davinci.txt

PowerShell
https://azure.microsoft.com/en-us/documentation/articles/powershell-install-configure/
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


#Get HTTPS/Admin credentials for submitting the job later
$creds = Get-Credential

#Get the cluster info so we can get the resource group, storage, etc.
$clusterInfo = Get-AzureRmHDInsightCluster -ClusterName $clusterName
$resourceGroup = $clusterInfo.ResourceGroup
$storageAccountName = $clusterInfo.DefaultStorageAccount.split('.')[0]
$container = $clusterInfo.DefaultStorageContainer
$storageAccountKey = Get-AzureRmStorageAccountKey `
# Define, execute and view result from Hello World Map Reduce job

        "wasb:///example/Output/WordCountOutput"