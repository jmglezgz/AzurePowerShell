﻿<#
#DEMO 3. Custom Map Reduce process from c# executables

Vistual Studio - C# projects
1. BigDataMapper.exe
2. BigDataReducer.exe

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


# Load Data files and executables mapper and reducer
Set-AzureStorageBlobContent `
    -File C:\it\data\STCO-MR2010_AL_MO.dat `
    -Blob "data/census/STCO-MR2010_AL_MO.dat" `
    -Container $container `
    -context $context `
Set-AzureStorageBlobContent `
    -File C:\IT\data\STCO-MR2010_MT_WY.dat `
    -Blob "data/census/STCO-MR2010_MT_WY.dat" `
    -Container $container `
    -context $context `
    -force


### 2. Upload executables to the cluster
Set-AzureStorageBlobContent `
    -File C:\IT\in\BigDataMapper.exe `
    -Blob "apps/BigDataMapper.exe" `
    -Container $container `
    -context $context
Set-AzureStorageBlobContent `
    -File C:\it\in\BigDataReducer.exe `
    -Container $container `
    -context $context

#List files in Storage



##################################################################################
### 3. ***ASM versin*** Define and Execute the MapReduce job with custom mapper and reducer executables. ***ASM version***
##################################################################################
$mrMapper = "BigDataMapper.exe"
$mrReducer = "BigDataReducer.exe"
$mrMapperFile = "/apps/BigDataMapper.exe"
$mrReducerFile = "/apps/BigDataReducer.exe"
$mrInput = "/data/census/STCO-MR2010_AL_MO.dat"
$mrOutput = "/data/Output"
$mrStatusOutput = "apps/MRStatusOutput"

# job definition
$mrJobDef = New-AzureHDInsightStreamingMapReduceJobDefinition `
    -JobName mrWordCountStreamingJob `
    -StatusFolder $mrStatusOutput `
    -Mapper $mrMapper `
    -Reducer $mrReducer `
    -InputPath $mrInput `
    -OutputPath $mrOutput
$mrJobDef.Files.Add($mrMapperFile)
$mrJobDef.Files.Add($mrReducerFile)

Write-Host "Init ..." -ForegroundColor Green
$mrJob = Start-AzureHDInsightJob -Cluster $clusterName -Credential $creds -JobDefinition $mrJobDef
Write-Host "Wait ..." -ForegroundColor Green
Wait-AzureHDInsightJob -Credential $creds -job $mrJob -WaitTimeoutInSeconds 3600

$JobId = $mrJob.JobId

# Print the output of the Map Reduce job. ARM version because cluster is Created in this version.
Write-Host "Display the standard output ..." -ForegroundColor Green
Get-AzureRmHDInsightJobOutput `



#Download & PrintOut 
cat C:\IT\out\censusOutput.txt | findstr "King"
<#
##################################################################################
### 4. ***ARM version*** Define and Execute the MapReduce job with custom mapper and reducer executables. ***ARM version***
##################################################################################
# Define custom Map Reduce job

$mrMapper = "BigDataMapper.exe"
$mrReducer = "BigDataReducer.exe"
$mrMapperFile = "/apps/WordCountMapper.exe"
$mrReducerFile = "/apps/WordCountReducer.exe"
$mrInput = "/data/census/STCO-MR2010_AL_MO.dat"
$mrOutput = "/data/output/"
$mrStatusOutput = "/data/MRStatusOutput/"
    -OutputPath $mrOutput
### IMPORTANT 10/02/16: it seems that cmdlets "Start-AzureRmHDInsightJob" is broken. more info: https://social.msdn.microsoft.com/Forums/vstudio/en-US/82c3e3df-e727-4136-8878-00004996f016/problems-running-the-word-count-c-streaming-sample?forum=hdinsight
###

Write-Host "Display the standard output ..." -ForegroundColor Green
Get-AzureRmHDInsightJobOutput `