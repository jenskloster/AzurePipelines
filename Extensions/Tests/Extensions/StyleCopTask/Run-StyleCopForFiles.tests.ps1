# Check that the required powershell module is loaded if it is remove it as it might be an older version
if ((get-module -name StyleCop ) -ne $null)
{
  remove-module StyleCop 
} 
import-module "$PSScriptRoot\..\..\..\stylecop\stylecoptask\StyleCop.psm1"

# Make sure we have a log folder
New-Item -ItemType Directory -Force -Path "$PSScriptRoot\logs" >$null 2>&1

Describe "StyleCop single file tests" {
  
    It "File has 7 issues" {
        $result = Invoke-StyleCop -sourcefolders "$PSScriptRoot\testdata\FileWith7Errors.cs" `
                                  -SettingsFile "$PSScriptRoot\testdata\AllSettingsEnabled.StyleCop" `
                                  -loggingfolder "$PSScriptRoot\logs" `
                                  -runName "TestRun7a" 
        $result.Succeeded | Should be $true
        $result.ViolationCount | Should be 7 
    }

      It "File has 7 issues but max violation count set to 3 where violations are warnings" {
        $result = Invoke-StyleCop -sourcefolders "$PSScriptRoot\testdata\FileWith7Errors.cs" `
                                  -SettingsFile "$PSScriptRoot\testdata\AllSettingsEnabled.StyleCop" `
                                  -loggingfolder "$PSScriptRoot\logs" `
                                  -runName "TestRun7c" `
                                  -MaximumViolationCount  3 `
                                  -treatStyleCopViolationsErrorsAsWarnings $true 
        $result.Succeeded | Should be $true
        $result.ViolationCount | Should be 3 
    }

        It "File has 7 issues but max violation count set to 3 where violations are errors" {
        $result = Invoke-StyleCop -sourcefolders "$PSScriptRoot\testdata\FileWith7Errors.cs" `
                                  -SettingsFile "$PSScriptRoot\testdata\AllSettingsEnabled.StyleCop" `
                                  -loggingfolder "$PSScriptRoot\logs" `
                                  -runName "TestRun7c" `
                                  -MaximumViolationCount  3 `
                                  -treatStyleCopViolationsErrorsAsWarnings $false 
        $result.Succeeded | Should be $false
        $result.ViolationCount | Should be 3 
    }

    It "File has 7 issues and treating issues as errors" {
        $result = Invoke-StyleCop -sourcefolders "$PSScriptRoot\testdata\FileWith7Errors.cs" `
                                  -SettingsFile "$PSScriptRoot\testdata\AllSettingsEnabled.StyleCop" `
                                  -loggingfolder "$PSScriptRoot\logs" `
                                  -runName "TestRun7b" `
                                  -treatStyleCopViolationsErrorsAsWarnings $false
        $result.Succeeded | Should be $false
        $result.ViolationCount | Should be 7 
    }


    It "File has 3 issues due to reduced ruleset" {
        $result = Invoke-StyleCop -sourcefolders "$PSScriptRoot\testdata\FileWith7Errors.cs" `
                                  -SettingsFile "$PSScriptRoot\testdata\SettingsDisableSA1200.StyleCop" `
                                  -loggingfolder "$PSScriptRoot\logs" `
                                  -runName "TestRun3a"
        $result.Succeeded | Should be $true
        $result.ViolationCount | Should be 3 
    }


     It "File has 0 issues" {
        $result = Invoke-StyleCop -sourcefolders "$PSScriptRoot\testdata\FileWith0Errors.cs" `
                                  -SettingsFile "$PSScriptRoot\testdata\AllSettingsEnabled.StyleCop" `
                                  -loggingfolder "$PSScriptRoot\logs" `
                                  -runName "TestRun0"
        $result.Succeeded | Should be $true
        $result.ViolationCount | Should be 0 
    }

     It "File has 3 issues" {
        $result = Invoke-StyleCop -sourcefolders "$PSScriptRoot\testdata\FileWith3Errors.cs" `
                                  -SettingsFile "$PSScriptRoot\testdata\AllSettingsEnabled.StyleCop" `
                                  -loggingfolder "$PSScriptRoot\logs" `
                                  -runName "TestRun3b"
        $result.Succeeded | Should be $true
        $result.ViolationCount | Should be 3 
    }

       It "File has 1 SA1650 issue" {
        $result = Invoke-StyleCop -sourcefolders "$PSScriptRoot\testdata\FileWithSA1650Errors.cs" `
                                  -SettingsFile "$PSScriptRoot\testdata\SettingsOnlySA1650.StyleCop" `
                                  -loggingfolder "$PSScriptRoot\logs" `
                                  -runName "TestRun1650"
        $result.Succeeded | Should be $true
        $result.ViolationCount | Should be 1 
    }

} 