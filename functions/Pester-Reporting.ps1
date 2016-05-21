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
    $testTemplate = @"
`$here = Split-Path -Parent `$MyInvocation.MyCommand.Path
`$sut = (Split-Path -Leaf `$MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "`$here\`$sut"
Describe "Test$num" {
    It "Should output $num" {
        Test$num | Should Be $num
    }
}
"@ | Set-Content -Path (Join-Path $tempFolder "Test$num.Tests.ps1")
}
Push-Location $tempFolder
Invoke-Pester -OutputFile report.xml -OutputFormat NUnitXml
#display overall test-suite results
$testResults
#display specific tests within test suite
$testResults.TestResult

#download and extract ReportUnit.exe
$url = 'http://relevantcodes.com/Tools/ReportUnit/reportunit-1.2.zip'
$fullPath = Join-Path $tempFolder $url.Split("/")[-1]
(New-Object Net.WebClient).DownloadFile($url,$fullPath)
(New-Object -ComObject Shell.Application).Namespace($tempFolder.FullName).CopyHere((New-Object -ComObject Shell.Application).Namespace($fullPath).Items(),16)
del $fullPath

#run reportunit against report.xml and display result in browser
& .\reportunit.exe report.xml
ii report.html
