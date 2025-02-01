# Input bindings are passed in via param block.
param($Timer)

Import-Module Az.Storage

Get-Module

# Get the current universal time in the default string format.
$currentUTCtime = (Get-Date).ToUniversalTime()

# The 'IsPastDue' porperty is 'true' when the current function invocation is later than scheduled.
if ($Timer.IsPastDue) {
    Write-Host "PowerShell timer is running late!"
}

# Write an information log with the current time.
Write-Host "PowerShell timer trigger function ran! TIME: $currentUTCtime"

## Connect to Azure using a Service Principal Account
$TenantId = $env:TenantId
$ApplicationId = $env:ApplicationId
$SecurePassword = $env:ClientSecret | ConvertTo-SecureString -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $ApplicationId, $SecurePassword
Connect-AzAccount -ServicePrincipal -Credential $Credential -Tenant $TenantId

## Connect to Azure using a User Assigned Managed Identity
# Disable-AzContextAutosave -Scope Process | Out-Null
# Connect-AzAccount -Identity -AccountId $env:UserAssignedIdentityClientId

$context = Get-AzSubscription -SubscriptionId $env:SubscriptionId
Set-AzContext $context

$date = Get-Date -Format "dd_MM_yyyy"

$storageAccount = Get-AzStorageAccount -ResourceGroupName $env:StorageResourceGroupName -Name $env:StorageName
$ctx = $storageAccount.Context

# Get Users
$users = Get-AzADUser | Select-Object -Property @('DisplayName','Id')
$usersJson = $users | ConvertTo-Json

$fileName = 'users_' + $date + '.json';
$filePath = $env:TMP + '\' + $fileName;
Set-Content -Path $filePath -Value $usersJson -NoNewline;

$blobName = $fileName
Set-AzStorageBlobContent -File $fileName -Container $env:StorageContainerName -Context $ctx -Blob $blobName

# Entra ID Groups
$groups = Get-AzADGroup | Select-Object -Property @('DisplayName','Id')
$groupsJson = $groups | ConvertTo-Json

$fileName = 'groups_' + $date + '.json';
$filePath = $env:TMP + '\' + $fileName;
Set-Content -Path $filePath -Value $groupsJson -NoNewline;

$blobName = $fileName
Set-AzStorageBlobContent -File $fileName -Container $env:StorageContainerName -Context $ctx -Blob $blobName

# Entra ID Group members
$groupsMembers = [System.Collections.ArrayList]@()

foreach($group in $groups){
  $members = Get-AzADGroupMember -GroupObjectId $group.id | Select-Object -Property @('Id')
  $memberIds = [System.Collections.ArrayList]@()
  foreach($member in $members){
    $memberIds.Add($member.Id) > $null
  }
  $groupMembers = [PSCustomObject]@{
    MemberIds = $memberIds
    GroupId = $group.id
  }
  $groupsMembers.Add($groupMembers) > $null
}
$groupsMembersJson = $groupsMembers | ConvertTo-Json

$fileName = 'groups_members_' + $date + '.json';
$filePath = $env:TMP + '\' + $fileName;
Set-Content -Path $filePath -Value $groupsMembersJson -NoNewline;

$blobName = $fileName
Set-AzStorageBlobContent -File $fileName -Container $env:StorageContainerName -Context $ctx -Blob $blobName
