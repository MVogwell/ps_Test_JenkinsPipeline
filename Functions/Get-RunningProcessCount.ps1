Function Get-RunningProcessCount() {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)][string]$sTimestamp
    )

    # Example function. Adds a string containing the number of running
    # processes to the timestamp provided in the parameter

    BEGIN {
        Write-Verbose "Starting function: Get-RunningProcessCount"

        # Check the timestamp is longer than 3 characters... used for the Pester test example
        if ($sTimeStamp.Length -le 3) {
            throw "Nope - you must have a valid string"
        }

        try {
            # Enumerate the number of processes running on the machine
            $iProcessCount = Get-Process | Measure-Object | Select-Object -ExpandProperty count
        }
        catch {
            throw "Failed to discover the number of processes running"
        }
    }
    PROCESS {
        #
        $sOutput = ($sTimeStamp + " - There are " + $iProcessCount.toString() + " processes running")
    }
    END {
        return $sOutput
    }
}