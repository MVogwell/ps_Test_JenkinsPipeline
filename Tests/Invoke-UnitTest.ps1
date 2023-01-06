# Invoke-UnitTest
[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)][string]$OutputFile
)

Write-Output "*** Running Invoke-UnitTest script"

Import-Module Pester

if ((Get-Module pester).Version.Major -ge 5) {
	Write-Output "`t+++ Using Pester v5 or above"

	$objPesterConfig = [PesterConfiguration]::Default
	$objPesterConfig.Run.Exit = $true
	$objPesterConfig.Run.Throw = $true
	$objPesterConfig.TestResult.Enabled = $true
	$objPesterConfig.TestResult.OutputPath = $OutputFile
	$objPesterConfig.Output.Verbosity = "Detailed"

	Invoke-Pester -Configuration $objPesterConfig -WarningAction "SilentlyContinue"
}
else { # Using an older version of Pester
	Write-Output "`t+++ Using Pester below v5"

	Invoke-Pester -EnableExit -OutputFile $OutputFile -OutputFormat NUnitXml -WarningAction "SilentlyContinue"
}

Write-Output "`t+++ Completed"