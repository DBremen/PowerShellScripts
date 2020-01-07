function SilverSearcher {
	 <#
    .SYNOPSIS
        PowerShell wrapper around silver searcher (ag.exe)
	    Recursively search for PATTERN in PATH. Like grep or ack, but faster.
    .DESCRIPTION
        PowerShell wrapper around silver searcher (ag.exe)
	    Recursively search for PATTERN in PATH. Like grep or ack, but faster.
        This function requires ag.exe (Silver Searcher).
        Either change the path on line 82 to the location of ag.exe on your Computer
        or install ag.exe via chocolatey "cinst ag"
    .PARAMETER Pattern
		A regular expression used for searching.
	.PARAMETER Path
	    A file or directory to search.
    .PARAMETER Context
	    Show NUM lines before and after each match. Defaults to 0.
    .PARAMETER PathPattern
	   Limit search to path matching the pattern
    .PARAMETER Depth
	    Depth of recursion: descend at most NUM directories.Defaults to 25.
    .PARAMETER CountOnly
	    Only print the number of matches in each file. (This often differs from the number of matching lines).
    .PARAMETER SimpleMatch
	    Treat the pattern as a literal string.
    .PARAMETER List
	    Only show the paths with at least one match.
    .PARAMETER CaseSensitive
	    Search case sensitively.Default is smart match case insensitively unless PATTERN contains uppercase characters.
    .PARAMETER NoRecurse
	    Do not search within sub-directories. Overwrites Depth parameter.
    .PARAMETER FollowSymLinks
	    Follow symbolic links
    .PARAMETER NotMatch
	    Invert matching.
    .PARAMETER FullWord
	    Only show matches surrounded by word boundaries.(Same as \b$Pattern\b).
    .PARAMETER SearchZip
	   Search through content of compressed files
    .PARAMETER Include
	    Only search files matching extension(s).
    .PARAMETER Exclude
	    Only search files not matching extension(s).Default @('lnk','exe','bpm','1','log','jar','tis','tii','prx')
    .PARAMETER FullLine
        Switch parameter, if specified the entire line of the match is returned. 
    .EXAMPLE
    	
    .EXAMPLE
    	
    .LINK
        https://github.com/ggreer/the_silver_searcher/blob/master/doc/ag.1.md
    #>
    [CmdletBinding()]
    [Alias("pag")]
    Param(
        [Parameter(Mandatory,Position=0)]
        $Pattern,
        [Parameter(Position=1)]
        $Path,
        $Context=0,
        $PathPattern,
        $Depth,
        [switch]$CountOnly,
        [switch]$SimpleMatch,
        [switch]$List,
        [switch]$CaseSensitive,
        [switch]$NoRecurse,
        [switch]$FollowSymLinks,
        [switch]$NotMatch,
        [switch]$FullWord,
        [switch]$SearchZip,
        [string[]]$Include,
        [string[]]$Exclude=@('lnk','exe','bpm','1','log','jar','tis','tii','prx'),
        [switch]$FullLine
    )

    $agPath = 'C:\ProgramData\chocolatey\bin\ag.exe'
    if (!(Test-Path $agPath)){
        $message = @'     

Couldn't file ag.exe. This function requires ag.exe (Silver Searcher).
Either change the path on line 82 to the location of ag.exe on your Computer
or install ag.exe via chocolatey "cinst ag"
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
    $properties = Write-Output Path LineNumber Line
    if ($CountOnly){
        $properties = Write-Output Path Count
    }
    $end = 3
    $selector = [string[]](Write-Output LineNumber Line Path)
    if ($CountOnly) { 
        $end = 2 
        $selector = [string[]](Write-Output Count Path)
    }
    & $agPath $parameters | ForEach-Object{
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
                    if (!$FullLine){
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
                }
               
                $ht.Add($properties[$i],$val)
            }
            [PSCustomObject]$ht | Select-Object $selector 
        }
    } 
}

