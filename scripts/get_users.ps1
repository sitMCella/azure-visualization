# Get Entra ID Users (test script)
#
# Requirements:
# - Install PowerShell
# - Install PowerShell Az library
#
# Run the following commands:
# pwsh
# Connect-AzAccount
# ./get_users.ps1

$date = Get-Date -Format "dd_MM_yyyy"

$users = Get-AzADUser | Select-Object -Property @('DisplayName','Id')

$outputFile = "users_${date}.json"
$users | ConvertTo-Json > $outputFile
