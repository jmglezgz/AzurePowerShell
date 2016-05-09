﻿<#
#DEMO 4. Create and Load Hive Tables


Input -- Big Data Sample
This demo take DEMO 3 output to insert info in a table

PowerShell
https://azure.microsoft.com/en-us/documentation/articles/powershell-install-configure/
#>

########################################################################
# Setting up Subscription, HDInsight Cluster and Storage Account
########################################################################
$clusterName = "{PUT YOUR HDINSIGHT CLUSTER NAME}"
$subId = "{PUT YOUR SUBSCRIPTION ID}"

$sub = Get-AzureRmSubscription -ErrorAction SilentlyContinue
if (-not ($sub))
{
    Login-AzureRmAccount
}

#If you have more than one subscription with your account, then select what you working on
Select-AzureRmSubscription -SubscriptionId $subId


#Get HTTPS/Admin credentials for submitting the job later
$creds = Get-Credential

$clusterInfo = Get-AzureRmHDInsightCluster -ClusterName $clusterName
$resourceGroup = $clusterInfo.ResourceGroup
$storageAccountName = $clusterInfo.DefaultStorageAccount.split('.')[0]
$container = $clusterInfo.DefaultStorageContainer
$storageAccountKey = Get-AzureRmStorageAccountKey `
########################################################################
# Create query, Config JOb definition and execute
########################################################################
Write-Host "Display the standard output ..." -ForegroundColor Green
Get-AzureRmHDInsightJobOutput `
#List files in Storage
