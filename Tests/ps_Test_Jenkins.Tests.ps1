[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
param()

BeforeAll {
    # Import the script file
    $sPath = ($PSScriptRoot).Replace("Tests","") + "\ps_Test_Jenkins.ps1"

    Function Get-RunningProcessCount() {}
}

Describe "ps_Test_Jenkins" {
    Context "Expected operation" {
        BeforeAll {
            Mock Get-RunningProcessCount {
                param (
                    [Parameter(Mandatory=$true)][string]$sTimestamp
                )

                $sOut = ($sTimestamp + " - There are 100 processes running")

                return $sOut
            }

            [string[]]$arrResult = . $sPath -sMsg "Hello World"

            if ($PSVersionTable.OS -match "Windows") {
                $sOutputFile = $Env:Temp + "\ps_Test_Jenkins.txt"
            }
            else {
                $sOutputFile = (Get-ChildItem env:\ | Where-Object Name -eq "HOME" | Select-Object -ExpandProperty value) + "/ps_Test_Jenkins.txt"
            }
        }

        It "Should return a string array" {
            ($arrResult).GetType().Name | Should -be "String[]"
        }

        It "Should return the param string in element 1" {
            $arrResult[1] | Should -Be "Your message from the parameter sMsg: Hello World"
        }

        It "Should create a file" {
            Test-Path $sOutputFile | Should -Be $true
        }

        It "Should create the correct contents in the output file" {
            Get-Content $sOutputFile | Select-Object -Last 1 | Should -Match "[0-9]{14} \- There are 100 processes running"
        }

        AfterAll {
            Remove-Item $sOutputFile -ErrorAction "Stop"
        }
    }
    Context "Called Function fails" {
        BeforeAll {
            Mock Get-RunningProcessCount {  throw "Failing function" }
        }

        It "Should fail with correct message" {
            try {
                [string[]]$arrResult = . $sPath -sMsg "Hello World" -Verbose
            }
            catch {
                $Error[0].Exception.Message | Should -BeLike 'Failed to run function Get-RunningProcessCount*'
            }
        }
    }
}

AfterAll {
    Remove-Item function:\Get-RunningProcessCount

}