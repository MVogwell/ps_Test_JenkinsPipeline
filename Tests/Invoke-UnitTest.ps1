# Invoke-UnitTest
[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)][string]$OutputFile
)

Write-Output "*** Running Invoke-UnitTest script"

Import-Module Pester

Invoke-Pester -EnableExit -OutputFile $OutputFile -OutputFormat NUnitXml -WarningAction "SilentlyContinue"

Write-Output "`t+++ Completed"