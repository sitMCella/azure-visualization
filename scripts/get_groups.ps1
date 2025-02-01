# Get Entra ID Groups (test script)
#
# Requirements:
# - Install PowerShell
# - Install PowerShell Az library
#
# Run the following commands:
# pwsh
# Connect-AzAccount
# ./get_groups.ps1

$date = Get-Date -Format "dd_MM_yyyy"

$groups = Get-AzADGroup | Select-Object -Property @('DisplayName','Id')

$outputFile = "groups_${date}.json"
$groups | ConvertTo-Json > $outputFile
