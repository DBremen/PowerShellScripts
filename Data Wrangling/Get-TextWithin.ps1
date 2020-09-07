function Get-TextWithin {
    <#    
        .SYNOPSIS
            Get the text between two (balanced) surrounding characters (e.g. brackets, quotes...)
        .DESCRIPTION
            Use RegEx to retrieve the text within enclosing characters.
	    .PARAMETER Text
            The text to retrieve the matches from.
        .PARAMETER WithinChar
            Single character, indicating the surrounding characters to retrieve the enclosing text for.
        .EXAMPLE
            # Retrieve all text within single quotes
		    $s=@'
here is 'some data'
here is "some other data"
this is 'even more data'
'@
            Get-TextWithin $s "'"
    #>
    [CmdletBinding()]
    param( 
        [Parameter(Mandatory, 
            ValueFromPipeline = $true,
            Position = 0)]   
        $Text,
        [Parameter(Position = 1)] 
        [char]$WithinChar = '"'
    )
    $htPairs = @{
        '(' = ')'
        '[' = ']'
        '{' = '}'
    }
    $withinChar2 = $WithinChar
    if ($htPairs.ContainsKey([string]$WithinChar)) {
        $withinChar2 = $htPairs[[string]$WithinChar]
    }
     $pattern = @"
(?<=\$WithinChar).+?(?=\$WithinChar2)
"@
    [regex]::Matches($Text, $pattern).Value
}