# Invoke-UnitTest
[CmdletBinding()]
param ()

Import-Module PSScriptAnalyzer

# Get the project root folder
$sRootPath = ($PSScriptRoot).Replace("\Tests","")

Write-Output "*** Running Invoke-ScriptAnalyzer for path: $sRootPath"

try {
    $arrResults = Invoke-ScriptAnalyzer $sRootPath -Recurse
}
catch {
    $sErrMsg = ("Failed to run Invoke-ScriptAnalzer cmdlet. Error: " + ($Error[0].Exception.Message).Replace("`n"," ").Replace("`r",""))
    throw $sErrMsg
}

if ($null -eq $arrResults) {
    Write-Output "`t+++ All tests passed"

}
else {
    Write-Output ($arrResults | Select-Object ruleName,ScriptPath,Severity,@{n='Line';e={$_.SuggestedCorrections.StartLineNumber}},Message | Sort-Object ScriptPath,Severity | ConvertTo-Json )

    throw "Invoke-ScriptAnalyzer tests failed. See log"
}
