# Invoke-HTMLPesterReport

## SYNOPSIS
Generate HTML report for Pester test results using ReportUnit.exe

## Script file
Utils\Invoke-HTMLPesterReport.ps1

## Related blog post
https://powershellone.wordpress.com/2016/05/18/reporting-against-pester-test-results/

## SYNTAX

```
Invoke-HTMLPesterReport
```

## DESCRIPTION
Using Pester's 'OutputFile' and 'OutputFormat' test results are turned into an XML in NUnit compatible format. 
The .xml file can be imported into tools like TeamCity in order to view test results in a human readable way. 
For people without access to full-fledged development tools, there is ReportUnit an open source command line tool
that automatically transforms the XML into a nice HTML report.
This is a PowerShell wrapper for ReportUnit. 
ReportUnit is required within the same path of the script.
If ReportUnit is not present, the function will automatically download it.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
#create test functions


$tempFolder = New-Item "$env:Temp\PesterTest" -ItemType Directory -force
foreach ($num in (1..10)){
    $functionTemplate =  @"
function Test$num {
    $(if ($Num -eq 8){
        "$($num + 1)"
        }else{
        "$num"
        }
    )
}
"@ | Set-Content -Path (Join-Path $tempFolder "Test$num.ps1")
#create tests against test functions
$testTemplate = @"
\`$here = Split-Path -Parent \`$MyInvocation.MyCommand.Path
\`$sut = (Split-Path -Leaf \`$MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
.
"\`$here\\\`$sut"
Describe "Test$num" {
    It "Should output $num" {
        Test$num | Should Be $num
    }
}
"@ | Set-Content -Path (Join-Path $tempFolder "Test$num.Tests.ps1")
}
Push-Location $tempFolder
#Invoke pester and generate NUnitXML output format
Invoke-Pester -OutputFile report.xml -OutputFormat NUnitXml
#feed the xml into the function
Invoke-GUIPesterReport $tempFolder\report.xml
```
## PARAMETERS

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://powershellone.wordpress.com/2016/05/18/reporting-against-pester-test-results/](https://powershellone.wordpress.com/2016/05/18/reporting-against-pester-test-results/)

[http://relevantcodes.com/Tools/ReportUnit](http://relevantcodes.com/Tools/ReportUnit)



