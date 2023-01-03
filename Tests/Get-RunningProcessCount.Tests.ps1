[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidOverwritingBuiltInCmdlets", "")]
param()

BeforeAll {
    # Import the script file
    $sPath = ($PSScriptRoot).Replace("Tests","Functions") + "\Get-RunningProcessCount.ps1"

    . $sPath

    Function Get-Process() {}
}

Describe "Get-RunningProcessCount" {
    Context "Working Get-Process" {
        BeforeAll {
            Mock Get-Process {
                $obj1 = [PSCustomObject] @{
                    Name = "Process1"
                }

                $obj2 = [PSCustomObject] @{
                    Name = "Process2"
                }

                $arrReturn = @($obj1,$obj2)

                return $arrReturn
            }
        }

        It "Should return correct string" {
            Get-RunningProcessCount -sTimestamp "1234" | Should -Be "1234 - There are 2 processes running"
        }

        It "Should return a string value" {
            (Get-RunningProcessCount -sTimestamp "1234").GetType().Name | Should -Be "string"
        }

        It "Should return error due to lack of characters in parameter sTimestamp" {
            try {
                Get-RunningProcessCount -sTimestamp "12" -ErrorAction "Stop"
            }
            catch {
                $Error[0].Exception.Message | Should -Be 'Nope - you must have a valid string'
            }
        }
    }
    Context "Failing Get-Context" {
        BeforeAll {
            Mock Get-Process { throw "No processes discovered" }
        }

        It "Should return error about the process retrieval" {
            try {
                Get-RunningProcessCount -sTimestamp "1234" -ErrorAction "Stop"
            }
            catch {
                $Error[0].Exception.Message | Should -Be 'Failed to discover the number of processes running'
            }
        }
    }
}

AfterAll {
    # Tidy up
    Remove-Item function:\Get-Process
    Remove-Item function:\Get-RunningProcessCount
}