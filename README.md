# ps_Test_Jenkins

## What's it all about
This project is a demonstration of deploying a PowerShell script using Jenkins - the PowerShell file ps_Test_Jenkins itself doesn't do anything fancy - it just writes a test file containing a timestamp to a file called ps_Test_Jenkins.txt within the %temp% folder. The main detail contained with this project are:

* Jenkinsfile - this is the pipeline instruction set that is trigger by the Jenkins pipeline project <br><br>
* Invoke-ScriptAnalyzerTest.ps1 - this is called by a Jenkins pipeline stage to initialise the PowerShell script analyzer against the code in the project. <br><br>
* Invoke-UnitTest.ps1 - this is called by a Jenkins pipeline stage to initialise Pester tests against the code

Please see xxxxx for information about using this project in Jenkins