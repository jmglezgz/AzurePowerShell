<#
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
$clusterName = "HDInsightCluster01"
$subId = "c197246d-d7ed-4643-b93b-b74e30851221"

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
$storageAccountKey = Get-AzureRmStorageAccountKey `    -Name $storageAccountName `    -ResourceGroupName $resourceGroup `    | %{$_.Key1}#Create a storage content and upload the file$context = New-AzureStorageContext `    -StorageAccountName $storageAccountName `    -StorageAccountKey $storageAccountKey########################################################################
# Define, execute and view result from Hello World Map Reduce job########################################################################
#Define the MapReduce job#NOTE: If using an HDInsight 2.0 cluster, use haddop-examples.jar instead# -JarFile = the JAR containing the MapReduce application# -ClassName = the class of the application# Arguments = The input file, and the output directory$wordCountJobDefinition = New-AzureRmHDInsightMapReduceJobDefinition `    -JarFile "wasb:///example/jars/hadoop-mapreduce-examples.jar" `    -ClassName "wordcount" `    -Arguments `        "wasb:///example/data/gutenberg/davinci.txt", `
        "wasb:///example/Output/WordCountOutput"#Submit the job to the clusterWrite-Host "Start the mapReduce job..." -ForegroundColor Green$wordCountJob = Start-AzureRmHDInsightJob `    -ClusterName $clusterName `    -JobDefinition $wordCountJobDefinition `    -HttpCredential $creds                #Wait for the job to completeWrite-Host "Wait for the job to complete..." -ForegroundColor GreenWait-AzureRmHDInsightJob `    -ClusterName $clusterName `    -JobId $wordCountJob.JobId `    -HttpCredential $creds#NOTE: If the ExitCode is a value other than 0, see https://azure.microsoft.com/en-us/documentation/articles/hdinsight-hadoop-use-mapreduce-powershell/#troubleshooting.<#print the Job Log OutputGet-AzureRmHDInsightJobOutput `    -ClusterName $clusterName `    -JobId $wordCountJob.JobId `    -DefaultStorageAccountName $storageAccountName `    -DefaultStorageAccountKey $storageAccountKey `    -DefaultContainer $container `    -HttpCredential $creds    #>#Download the outputGet-AzureStorageBlobContent `    -Blob 'example/Output/WordCountOutput/part-r-00000' `    -Container $container `    -Destination 'C:\IT\out\part-r-0000.txt' `    -context $context# Look at the resultscat 'C:\IT\out\part-r-0000.txt' | findstr "there"cat 'C:\IT\out\part-r-0000.txt' | findstr "city"cat 'C:\IT\out\part-r-0000.txt' | findstr "person"cat 'C:\IT\out\part-r-0000.txt' | findstr "house"