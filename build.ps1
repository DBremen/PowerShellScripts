# Add script files as nested modules into module manifest
$nestedModules = Get-ChildItem $PSScriptRoot\ -Include ('*.ps1','*.psm1') -Recurse | 
    where { $_.DirectoryName -ne $PSScriptRoot -and $_.Name -ne 'Add-ScriptHelpISEAddOn.ps1'} | ForEach-Object { 
    "'.$($_.FullName.Replace($PSScriptRoot,''))'"
}

$start='# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess'
$end = '# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.'

$manifestPath = "$PSScriptRoot\PowerShellScripts.psd1"
$txt = @"
NestedModules = @(
$($nestedModules -join ",`r`n")
)
"@
[regex]::Replace(([IO.File]::ReadAllText($manifestPath)),"($start)([\s\S]*)($end)","`$1`r`n$txt`r`n`$3",[Text.RegularExpressions.RegexOptions]::Multiline) | 
			Set-Content $manifestPath
	


# Fix Example section markup from PlatyPS
$files = dir "$PSSCriptRoot\docs"
$replacements = foreach ($file in $files){
    $exampleText = [RegEx]::Match(($file | Get-Content -Raw),'(?ms)## EXAMPLES(.*)?## PARAMETERS').Groups[1].Value
    $examples = ($exampleText -split '###.*EXAMPLE \d\s*[-]*') | select -Skip 1
    foreach ($example in $examples){
        [PSCustomObject][ordered]@{
            Old = $example
            New = "`r`n" + '```' + "`r`n$($example.Replace('```','').Trim())`r`n" + '```' + "`r`n"
            Path = $file.FullName
        }
    }
}

foreach ($replacement in $replacements){
    (Get-Content $replacement.Path -Raw).Replace($replacement.Old,$replacement.New) | Set-Content $replacement.Path
}
