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
        [char]$WithinChar = '"'
    )
    $pattern = @"
(?<=\$WithinChar).+?(?=\$WithinChar)
"@
    [regex]::Matches($Text, $pattern).Value
}