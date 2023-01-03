[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)][string]$sMsg
)

# Test script for Jenkins pipeline

# .source function file
. $PSScriptRoot\Functions\Get-RunningProcessCount.ps1

# Initialise variables
$sTimestamp = Get-Date -Format "yyyyMMddHHmmss"

if ($PSVersionTable.OS -match "Windows") {
    $sOutputFile = $Env:Temp + "\ps_Test_Jenkins.txt"
    Write-Output "Using Windows output path: $sOutputFile"
}
else {
    $sOutputFile = (Get-ChildItem env:\ | Where-Object Name -eq "HOME" | Select-Object -ExpandProperty value) + "/ps_Test_Jenkins.txt"
    Write-Output "Using Linux output path: $sOutputFile"
}

# Print the message from the startup parameter - this will be shows in the
# jenkins pipeline output.
Write-Output "Your message from the parameter sMsg: $sMsg"

# This is an example of calling a function, returns a string
try {
    $sOut = Get-RunningProcessCount -sTimeStamp $sTimestamp
}
catch {
    $sErrMsg = ("Failed to run function Get-RunningProcessCount. Error: " + ($Error[0].Exception.Message).Replace("`n"," ").Replace("`r",""))
    throw $sErrMsg
}

try {
    Write-Output "Writing to file"
    $sOut | Out-File $sOutputFile -encoding utf8 -Append -ErrorAction "Stop"

    Write-Output "`t+++ Success"
    Write-Output "`t+++ File location: $sOutputFile"
}
catch {
    $sErrMsg = ("Failed to write to file. Error: " + ($Error[0].Exception.Message).Replace("`n"," ").Replace("`r",""))
    throw $sErrMsg
}

Write-Output "=== Finished === `n`n"
