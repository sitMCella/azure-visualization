# Get Entra ID Groups Members (test script)
#
# Requirements:
# - Install PowerShell
# - Install PowerShell Az library
#
# Run the following commands:
# pwsh
# Connect-AzAccount
# ./get_groups_members.ps1

$date = Get-Date -Format "dd_MM_yyyy"

$groups = Get-AzADGroup | Select-Object -Property @('DisplayName','Id')

$groupsMembers = [System.Collections.ArrayList]@()

foreach($group in $groups){
  $members = Get-AzADGroupMember -GroupObjectId $group.id | Select-Object -Property @('Id')
  $memberIds = [System.Collections.ArrayList]@()
  foreach($member in $members){
    $memberIds.add($member.Id) > $null
  }
  $groupMembers = [PSCustomObject]@{
    MemberIds = $memberIds
    GroupId = $group.id
  }
  $groupsMembers.add($groupMembers) > $null
}

$outputFile = "groups_members_${date}.json"
$groupsMembers | ConvertTo-Json > $outputFile
