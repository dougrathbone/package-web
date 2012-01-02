param($testOutputRoot)
# set-psdebug -strict -trace 0

$global:succeeded = $true
# define all test cases here
function TestGetPathToMSDeploy01 {
    try {
        $expectedMsdeployExe = "C:\Program Files\IIS\Microsoft Web Deploy V2\msdeploy.exe"    
        $actualMsdeployExe = GetPathToMSDeploy
        
        $msg = "TestGetPathToMSDeploy01"
        AssertNotNull $actualMsdeployExe $msg
        AssertEqual $expectedMsdeployExe $actualMsdeployExe
        if(!(RaiseAssertions)) {
            $global:succeeded = false
        }
    }
    catch{
        $global:succeeded = $false
    }
}

function TestExtractZip {
    # extract the
    $zipFile = (Join-Path $testOutputRoot -ChildPath "test-resources\SampleZip.zip" | Get-Item).FullName
    $destFolder = Join-Path $testOutputRoot -ChildPath "psout\SampleZip"

    if(Test-Path $destFolder) {
        Remove-Item -Path $destFolder -Recurse
    }
    New-Item -Path $destFolder -type directory
    
    try {
        Extract-Zip -zipFilename $zipFile -destination $destFolder   
    }
    catch{
        $global:succeeded = $false
        $_.Exception | Write-Error | Out-Null
    }
}

$currentDirectory = split-path $MyInvocation.MyCommand.Definition -parent
# Run the initilization script
& (Join-Path -Path $currentDirectory -ChildPath "setup-testing.ps1")

# start running test cases
TestExtractZip

# Run the tear-down script
& (Join-Path -Path $currentDirectory -ChildPath "teardown-testing.ps1")
ExitScript -succeeded $global:succeeded -sourceScriptFile $MyInvocation.MyCommand.Definition