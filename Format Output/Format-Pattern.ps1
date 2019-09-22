
function Format-Pattern {
    <#    
      .SYNOPSIS
        Highlight a pattern in the output. Cannot be used in the middle of a pipeline.
        And works only on the commandline.
      .DESCRIPTION
        Uses split Out-String, and Write-Host to highlight a pattern in the output.
        Does not return objects and therefore cannot be used in the middle of a pipeline.
      .PARAMETER InputObject
        The object(s) that contain the pattern to be highlighted (best used as pipeline input)
      .PARAMETER Pattern
        The pattern to identify the string within the output to be highlighted.
      .PARAMETER Color
        The Color to highlight the matches in.
      .PARAMETER SimpleMatch
        Switch parameter if specified the Pattern is not considered as a RegEx pattern.
      .EXAMPLE
        #Highlight the word 'firefox' in Magenta within the output of Get-Process
        Get-Process | Format-Pattern -Pattern firefox -Color Magenta
    #>
    [CmdletBinding()]
    [Alias('ColorPattern')]
    param( 
        [Parameter(Mandatory, 
            ValueFromPipeline,
            Position = 0)]   
        $InputObject, 
        [Parameter(Mandatory)] $Pattern,
        [Parameter(Mandatory)][ConsoleColor]$Color, 
        [switch]$SimpleMatch
    )
    BEGIN {
        if ($Host.Name -ne "ConsoleHost") { 
            Write-Warning "This works only for the console, script will exit now..."
            exit
        }
    }
    END {
        $found = ''
        if ( $SimpleMatch ) { $Pattern = [regex]::Escape( $Pattern ) }
        $Text = $Input | Out-String
        $split = $Text -split $Pattern
        $found = [regex]::Matches( $Text, $Pattern, 'IgnoreCase' )
        for ( $i = 0; $i -lt $split.Count; ++$i ) {
            Write-Host $split[$i] -NoNewline
            Write-Host $found[$i] -NoNewline -ForegroundColor $Color
        }
    }
}