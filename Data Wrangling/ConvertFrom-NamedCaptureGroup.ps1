function ConvertFrom-NamedCaptureGroup {
    <#
        .SYNOPSIS
            Convert the output of a RegEx named capture group to a PSObject
        .DESCRIPTION
            Converts the RegEx named capture group from a hashtable into a PSObject.
            This uses Select-String -AllMatches to catch all occurences across all lines in the text matching
            the RegEx pattern.
            Following the idea of $txt | % { if ($_ -match $regex) { $Matches.Remove(0); new-object PSObject -property $Matches } }
        .PARAMETER Text
            The text to apply the RegEx pattern against. Can be multiline text
        .PARAMETER Pattern
            The RegEx pattern containing named capture groups in the form of '(?<CAPTUREGROUPNAME>REGEXPATTERN)
        .EXAMPLE
            $Text = @'
<a href="https://www.address1.com">Link 1</a><a href="https://www.address2.com">Link 2</a>
<a href="https://www.address3.com">Link 3</a><a href="https://www.address4.com">Link 4</a>
'@  
            $Pattern = [regex]'(?i)<a href="(?<link>.*?)".*?>(?<text>.*?)</a>'
            ConvertFrom-NamedCaptureGroup $Text $Pattern

            # output excerpt
            link                     text
            ----                     ----
            https://www.address1.com Link 1
            https://www.address2.com Link 2
            https://www.address3.com Link 3
            https://www.address4.com Link 4
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, 
            ValueFromPipeline,
            Position = 0)]   
        $Text, 
        [Parameter(Mandatory, 
            Position = 1)] 
        [regex]$Pattern
    )
    $names = $Pattern.GetGroupNames() | Select-Object -skip 1
    $Text | select-string -Pattern $Pattern -AllMatches| Select-Object -ExpandProperty Matches |
        ForEach-Object {
        $hash = [ordered]@{}
        foreach ($name in $names) {
            $hash.add($name, $_.groups[$name].value)
        }
        [PSCustomObject]$hash
    } 
}