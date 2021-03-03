function Get-TextWithin {
    <#    
        .SYNOPSIS
            Get the text between two surrounding characters (e.g. brackets, quotes, or custom characters)
        .DESCRIPTION
            Use RegEx to retrieve the text within enclosing characters.
	    .PARAMETER Text
            The text to retrieve the matches from.
        .PARAMETER WithinChar
            Single character, indicating the surrounding characters to retrieve the enclosing text for. 
            If this paramater is used the matching ending character is "guessed" (e.g. '(' = ')')
        .PARAMETER StartChar
            Single character, indicating the start surrounding characters to retrieve the enclosing text for. 
        .PARAMETER EndChar
            Single character, indicating the end surrounding characters to retrieve the enclosing text for. 
        .EXAMPLE
            # Retrieve all text within single quotes
		    $s=@'
here is 'some data'
here is "some other data"
this is 'even more data'
'@
             Get-TextWithin $s "'"
    .EXAMPLE
    # Retrieve all text within custom start and end characters
    $s=@'
here is /some data\
here is /some other data/
this is /even more data\
'@
    Get-TextWithin $s -StartChar / -EndChar \

    .LINK
        https://powershellone.wordpress.com/2021/02/24/using-powershell-and-regex-to-extract-text-between-delimiters/
#>
    [CmdletBinding()]
    param( 
        [Parameter(Mandatory, 
            ValueFromPipeline = $true,
            Position = 0)]   
        $Text,
        [Parameter(ParameterSetName = 'Single', Position = 1)] 
        [char]$WithinChar = '"',
        [Parameter(ParameterSetName = 'Double')] 
        [char]$StartChar,
        [Parameter(ParameterSetName = 'Double')] 
        [char]$EndChar
    )
    $htPairs = @{
        '(' = ')'
        '[' = ']'
        '{' = '}'
        '<' = '>'
    }
    if ($PSBoundParameters.ContainsKey('WithinChar')) {
        $StartChar = $EndChar = $WithinChar
        if ($htPairs.ContainsKey([string]$WithinChar)) {
            $EndChar = $htPairs[[string]$WithinChar]
        }
    }
    $pattern = @"
(?<=\$StartChar).+?(?=\$EndChar)
"@
    [regex]::Matches($Text, $pattern).Value
}
