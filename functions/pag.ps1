function Pag {
	 <#
    .SYNOPSIS
        PowerShell wrapper around silver searcher (ag.exe)
	    Recursively search for PATTERN in PATH.
        Like grep or ack, but faster.
    .DESCRIPTION

    .EXAMPLE
    	
    .EXAMPLE
    	
    .LINK
        https://github.com/ggreer/the_silver_searcher/blob/master/doc/ag.1.md
    #>
    [CmdletBinding()]
    Param(
        #A regular expression used for searching
        [Parameter(Mandatory,Position=0)]
        $Pattern,
        #A file or directory to search.
        [Parameter(Position=1)]
        $Path,
        #Show NUM lines before and after each match. Defaults to 0.
        $Context=0,
        #Limit search to path matching the pattern
        $PathPattern,
        #Depth of recursion: descend at most NUM directories.Defaults to 25.
        $Depth,
        #Only print the number of matches in each file. (This often differs from the number of matching lines)
        [switch]$CountOnly,
        #Treat the pattern as a literal string.
        [switch]$SimpleMatch,
        #Only show the paths with at least one match.
        [switch]$List,
        #Search case sensitively.Default is smart match case insensitively unless PATTERN contains uppercase characters.
        [switch]$CaseSensitive,
        #Do not search within sub-directories. Overwrites Depth parameter.
        [switch]$NoRecurse,
        #Follow symbolic links
        [switch]$FollowSymLinks,
        #Invert matching.
        [switch]$NotMatch,
        #Only show matches surrounded by word boundaries.(Same as \b$Pattern\b).
        [switch]$FullWord,
        #Search through content of compressed files
        [switch]$SearchZip,
        #Only search files matching extension(s).
        [string[]]$Include,
        #Do not search files matching extension(s).
        [string[]]$Exclude=@('lnk','exe','bpm','1','log','jar','tis','tii','prx')
    )

    $agPath = 'C:\cygwin64\bin\ag.exe'
    if (!Test-Path $agPath){
        $message = @'     

Couldn't file ag.exe. This function requires ag.exe (Silver Searcher).
Either change the path on line 54 to the location of ag.exe on your Computer
or download ag.exe via CygWin (this is the only windows binary distribution that worked for me).
Instructions:
- Download https://cygwin.com/setup-x86_64.exe (or the 32bit depending on your platform)
- Run the setup
    - Keep default 'Download from Internet'
    - Keep default directory 'C:\cygwin64'
    - Pick a location for the Local Package Delivery other than the directory chosen in the previous step.
    - Keep with defaults in next two steps (Direct connection and first mirror)
    - Search for 'the_silver_searcher' packet under Utils and select to download it
'@
        Write-Warning $message
        exit
    }
    $basePath = $PWD
    if ($Path) { $basePath = $Path }
    $parameters = New-Object System.Collections.ArrayList
    if ($CountOnly){
        $null = $parameters.Add('-c')
    }
    if ($Context){
        $null = $parameters.Add("-C$Context")
    }
    if ($PathPattern){
        $null = $parameters.Add("-G$PathPattern")
    }
    if ($List){
       $null = $parameters.Add('-l')
    }
    if ($NoRecurse){
        $null = $parameters.Add('--depth 0')
    }
    elseif($Depth){
        $null = $parameters.Add("--depth $Depth")
    }
    if ($FollowSymLinks){
        $null = $parameters.Add('--follow')
    }
    if ($SimpleMatch){
        $null = $parameters.Add('-F')
    }
    if ($CaseSensitive){
        $null = $parameters.Add('-s')
    }
    else{
        #smart case
        $null = $parameters.Add('-S')
    }
    if ($NotMatch){
        $null = $parameters.Add('-v')
    }
    if ($FullWord){
        $null = $parameters.Add('-w')
    }
    if ($SearchZip){
        $null = $parameters.Add('-z')
    }
    if ($Include.Count -gt 0){
        $extensions = $Include  -replace '[.*]',''
        $null = $parameters.Add("-G($($extensions -join '|'))`$")
    }
    if ($Exclude.Count -gt 0){
        foreach ($ext in $Exclude){
            $currExt = $ext  -replace '[.*]',''
            $currExt = '*.' + $currExt
            $null = $parameters.Add("--ignore='$currExt'")
        }
    }
    $null = $parameters.Add('--noheading')
    #$null = $parameters.Add('--search-binary')
    $null = $parameters.Add('--nobreak')
    $null = $parameters.Add('--hidden')
    $null = $parameters.Add('--silent')
    $null = $parameters.Add('--one-device')

    $null = $parameters.Add($pattern)
    if ($Path){
        $null = $parameters.Add($Path)
    }
    $properties = echo Path LineNumber Line
    if ($CountOnly){
        $properties = echo Path Count
    }
    $end = 3
    $selector = [string[]](echo LineNumber Line Path)
    if ($CountOnly) { 
        $end = 2 
        $selector = [string[]](echo Count Path)
    }
    & $agPath $parameters | foreach{
        $split = $_ -split ':(\d+):?'.Where({$_})
        if ($split[2] -or $split[0] -like '*binary file*' -or $CountOnly){     
            $ht = [ordered]@{}
            for ($i=0;$i-lt$end;$i++){
                $val = $split[$i]
                if ($val -eq $Null){
                    $val = ''
                }
                $val = $val.Trim()
                if ($i -eq 0){
                    $val = $val.Replace('Binary file','').Replace('matches.','').Trim()
                    $val = Join-Path $basePath $val
                }
                elseif ($i -eq 2 -and $val -ne ''){
                    $index = [Regex]::Match($val, $Pattern).Index
                    $start = ($index - 10)
                    if ($start -lt 0) {$start = 0}
                    $patLen = $Pattern.Length
                    $len = $patLen + 20
                    if ($start+$len -gt $val.Length){
                        $len = $val.Length - $start
                    }
                    $val = $val.Substring($start,$len)
                }
               
                $ht.Add($properties[$i],$val)
            }
            [PSCustomObject]$ht | select $selector 
        }
    } 
}

