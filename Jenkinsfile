// Jenkinsfile: Pull lastest git commit for master, run pester tests, run ScriptAnalyzer tests, Execute script
pipeline {
    agent any
    stages {
        stage('GitPull') {
            steps {
				// Git pull - as this is a public repository credentials won't be used.
                git branch: 'main', url: 'https://github.com/MVogwell/ps_Test_JenkinsPipeline'
            }
        }
        stage('PesterTests') {
            steps {
				// Run script Invoke-UnitTest.ps1 which executes Invoke-Pester. Unit test results exported to PSTestResults.xml
				script {
					def fExists = fileExists 'Tests/Invoke-UnitTest.ps1'
					if (fExists) {
						pwsh script: '.\\Tests\\Invoke-UnitTest.ps1 -OutputFile "PSTestResults.xml"'
						
						// Import the unit test results
						nunit testResultsPattern: 'PSTestResults.xml'
					} else {
						echo "Skipping Invoke-UnitTest.ps1 - script file not available"
					}
				}
            }
        }
        stage('ScriptAnalyzerTests') {
            steps {
				script {
					def fExists = fileExists 'Tests/Invoke-ScriptAnalyzerTest.ps1'
					if (fExists) {
						// Run script Invoke-ScriptAnalyzerTest.ps1 which tests all .ps1 files using Invoke-ScriptAnalyzer
						pwsh script: '.\\Tests\\Invoke-ScriptAnalyzerTest.ps1'
					} else {
						echo "Skipping Invoke-ScriptAnalyzerTest.ps1 - script file not available"
					}
				}
            }
        }
        stage('Execute') {
            steps {
				// Run the script.
                pwsh script: '.\\ps_Test_Jenkins.ps1 -sMsg "This is sMsg!"'
            }
        }
    }
}