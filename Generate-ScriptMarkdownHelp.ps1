# module https://github.com/MathieuBuisson/Powershell-Utility/tree/master/ReadmeFromHelp
#http://jbt.github.io/markdown-editor/

if ($global:MyInvocation -ne $script:MyInvocation) {  
    Write-Warning 'Please start the Generate-ScriptMarkdownHelp script dot-sourced'  
    break  
}  

function Get-FunctionFromScript {
    <#
    .Synopsis 
        Gets the functions and filters declared within a script block or a file
    .Description
        Gets the functions exactly as they are written within a script or file
    .Example
        Get-FunctionFromScript {
            function foo() {
                "foo"
            }
            function bar() {
                "bar"
            }
        }
    .Link
        http://powershellpipeworks.com/
    #>
    [CmdletBinding(DefaultParameterSetName = 'File')]
    [OutputType([ScriptBlock], [PSObject])]
    param(
        # The script block containing functions
        [Parameter(Mandatory = $true,
            Position = 0,
            ParameterSetName = "ScriptBlock",
            ValueFromPipelineByPropertyName = $true)]    
        [ScriptBlock]
        $ScriptBlock,
    
        # A file containing functions
        [Parameter(Mandatory = $true,
            ParameterSetName = "File",
            ValueFromPipelineByPropertyName = $true)]           
        [Alias('FullName')]
        [String]
        $File,
    
        # If set, outputs the command metadatas
        [switch]
        $OutputMetaData
    )
    
    process {
        if ($psCmdlet.ParameterSetName -eq "File") {
            #region Resolve the file, create a script block, and pass the data down
            $realFile = Get-Item $File
            if (-not $realFile) {
                $realFile = Get-Item -LiteralPath $File -ErrorAction SilentlyContinue
                if (-not $realFile) { 
                    return
                }
            }
            $text = [IO.File]::ReadAllText($realFile.Fullname)
            $scriptBlock = [ScriptBlock]::Create($text)
            if ($scriptBlock) {
                $functionsInScript = 
                Get-FunctionFromScript -ScriptBlock $scriptBlock -OutputMetaData:$OutputMetaData                    
                if ($OutputMetaData) {
                    $functionsInScript | 
                        Add-Member NoteProperty File $realFile.FullName -PassThru
                }
            } 
            #endregion Resolve the file, create a script block, and pass the data down
        }
        elseif ($psCmdlet.ParameterSetName -eq "ScriptBlock") {            
            #region Extract out core functions from a Script Block
            $text = $scriptBlock.ToString()
            $tokens = [Management.Automation.PSParser]::Tokenize($scriptBlock, [ref]$null)            
            for ($i = 0; $i -lt $tokens.Count; $i++) {
                if ($tokens[$i].Content -eq "function" -or $tokens[$i].Content -eq 'filter' -and
                    $tokens[$i].Type -eq "Keyword") {
                    $groupDepth = 0
                    $functionName = $tokens[$i + 1].Content
                    $ii = $i
                    $done = $false
                    while (-not $done) {
                        while ($tokens[$ii] -and $tokens[$ii].Type -ne 'GroupStart') { $ii++ }
                        $groupDepth++
                        while ($groupDepth -and $tokens[$ii]) {
                            $ii++
                            if ($tokens[$ii].Type -eq 'GroupStart') { $groupDepth++ } 
                            if ($tokens[$ii].Type -eq 'GroupEnd') { $groupDepth-- }
                        }
                        if (-not $tokens[$ii]) { break } 
                        if ($tokens[$ii].Content -eq "}") { 
                            $done = $true
                        }
                    }
                    if (-not $tokens[$ii] -or 
                        ($tokens[$ii].Start + $tokens[$ii].Length) -ge $Text.Length) {
                        $chunk = $text.Substring($tokens[$i].Start)
                    }
                    else {
                        $chunk = $text.Substring($tokens[$i].Start, 
                            $tokens[$ii].Start + $tokens[$ii].Length - $tokens[$i].Start)
                    }        
                    if ($OutputMetaData) {
                        New-Object PSObject -Property @{
                            Name       = $functionName
                            Definition = [ScriptBlock]::Create($chunk)
                        }                        
                    }
                    else {
                        [ScriptBlock]::Create($chunk)
                    }
                }
            }        
            #endregion Extract out core functions from a Script Block
        }        
    }
}


function Generate-ScriptMarkdownHelp {
    <#    
    .SYNOPSIS
        The function that generated the Markdown help in this repository. (see Example for usage). 
        Generates markdown help for Github for each function containing comment based help (Description not empty) within a folder recursively and a summary table for the main README.md
    .DESCRIPTION
        Functions are extracted via Get-FunctionFromScript, dot sourced and parsed using platyPS.
	.PARAMETER Path
		Path to the folder containing the scripts
	.EXAMPLE
       #because the functions are dot sourced within the function they are not visible wihtin the global scope
       #therefore the script needs to be called by dot-sourcing itself
       #open console
       . <PATHTOTHISSCRIPT>
       #call the function
       $path = <PATHTOSCRIPTSTOBEDOCUMENTED>
       . Generate-ScriptMarkdownHelp($path)
#>
    [CmdletBinding()]
    Param($Path = 'C:\Scripts\ps1\PowerShellScripts')
    $summaryTable = @'
# PowerShellScripts
Some PowerShell scipts that can be hopefully also useful to others. Most of them were written by me, if not I tried to reference the author and or source. Since I collected those scripts over several years, I couldn't always remember though. 

| Function | Location | Synopsis | Related Blog Post | Full Documentation |
| --- | --- | --- | --- | --- |
'@
    Import-Module platyps
    $env:path += ";$path"
    $files = Get-ChildItem $path -File -Include ('*.ps1','*.psm1') -Recurse
    $htCheck = @{}
    foreach ($file in $files) {
        if ($file.Extension -eq '.psm1'){
            Import-Module $file.Fullname
            $functions = Get-Command -Module $file.BaseName
        }
        else{
            $htCheck[$file.Name] = 0
            . "$($file.FullName)"
            $functions = Get-FunctionFromScript -File $file.FullName -OutputMetaData | sort Name -unique
        }
        foreach ($function in $functions) {
            $help = $Null
            
            try {
                if (Get-Help $function.Name -ErrorAction SilentlyContinue) {
                    $help = Get-Help $function.Name | Where-Object {$_.Name -eq $function.Name} -ErrorAction Stop
                }
                else {
                    continue
                }
            }
            catch {
                continue
            }
            if ($help.description -ne $null) {
                $htCheck[$file.Name] += 1
                $link = $help.relatedLinks 
                if ($link) {
                    $link = $link.navigationLink.uri | Where-Object {$_ -like '*powershellone*'}
                }
                $mdFile = $function.Name + '.md'
                $location = $("$($file.Directory.Name)\$($file.Name)")
                $summaryTable += "`n| $($function.Name) | $location | $($help.Synopsis.Replace("`n"," ")) | $(if($link){"[Link]($link)"}) | $("[Link](https://github.com/DBremen/PowerShellScripts/blob/master/docs/$mdFile)") |"
                $documenation = New-MarkdownHelp -Command $function.Name -OutputFolder "$path\docs" -Force
                $text = (Get-Content -Path $documenation | Select-Object -Skip 6)
                $index = $text.IndexOf('## SYNTAX')
                $text[$index - 1] += "`n## Script file`n$location`n"
                if ($link) {
                    $index = $text.IndexOf('## SYNTAX')
                    $text[$index - 1] += "`n## Related blog post`n$link`n"
                }
                $text | Set-Content $documenation -Force
            }
        }
    }
    $summaryTable | Set-Content "$path/README.md" -Force
    #sanity check if help file were generated for each script
    [PSCustomObject]$htCheck
}