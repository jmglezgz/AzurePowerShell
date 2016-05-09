<#
#DEMO 4. Create and Load Hive Tables


Input -- Big Data Sample
This demo take DEMO 3 output to insert info in a table

PowerShell
https://azure.microsoft.com/en-us/documentation/articles/powershell-install-configure/
#>

########################################################################
# Setting up Subscription, HDInsight Cluster and Storage Account
#########################################################################Specify the values
$clusterName = "mscloudbigdatacluster"
$subId = "3f8ecd43-01db-483e-930e-812fd2e1e8eb"
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
$storageAccountKey = Get-AzureRmStorageAccountKey `    -Name $storageAccountName `    -ResourceGroupName $resourceGroup `    | %{$_.Key1}#Create a storage content and upload the file$context = New-AzureStorageContext `    -StorageAccountName $storageAccountName `    -StorageAccountKey $storageAccountKey
########################################################################
# Create query, Config JOb definition and execute
########################################################################$querystring = "DROP TABLE working_te_census_info;" +`"CREATE EXTERNAL TABLE working_te_census_info (" + `    "state STRING," + `    "county STRING," + `    "agegrp STRING," + `    "total_population STRING) " +`    "STORED AS TEXTFILE LOCATION 'wasb:///data/hive/';" +`    "LOAD DATA INPATH 'wasb:///data/Output/part-00000'" +`    "OVERWRITE INTO TABLE working_te_census_info;" + `    "SELECT * from working_te_census_info ORDER BY total_population DESC limit 10;"# Create a Hive job definition$HiveJobDefinition = New-AzureRmHDInsightHiveJobDefinition -Query $querystring# Submit the job to the clusterWrite-Host "Start the Hive job..." -ForegroundColor Green$hiveJob = Start-AzureRmHDInsightJob -ClusterName $clusterName -JobDefinition $HiveJobDefinition -ClusterCredential $creds#Wait for the Hive job to completeWrite-Host "Wait for the job to complete..." -ForegroundColor GreenWait-AzureRmHDInsightJob -ClusterName $clusterName -JobId $hiveJob.JobId -ClusterCredential $creds#JobId$JobId = $hiveJob.JobId# Print the output of the Map Reduce job. ARM version because cluster is Created in this version.
Write-Host "Display the standard output ..." -ForegroundColor Green
Get-AzureRmHDInsightJobOutput `    -ClusterName $clusterName `    -DefaultContainer $container `    -DefaultStorageAccountKey $storageAccountKey `    -DefaultStorageAccountName $storageAccountName `    -HttpCredential $creds `    -JobId $JobId `    -DisplayOutputType StandardError
#List files in StorageGet-AzureStorageBlob `    -Container $container `    -Context $context `    -Blob "data/*" | ft -a  
