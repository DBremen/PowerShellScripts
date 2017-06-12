function Get-GoogleSuggestion {
<#
    .SYNOPSIS
        Function to get "Did you mean?" suggestions from Google.        
    .DESCRIPTION
		Similar to the experience "Did you mean?" experience using the Google search engine,
        the function will return suggestions on mistyped search terms (word or sentence).   
    .PARAMETER Query
        A word or sentence to get suggestions for.    
    .EXAMPLE  
        dym 'dnld t' #use the alias to get suggestions for a term
        
        donald trump
        donald trump twitter
        donald trump news
        donald tusk
        donald trump age
        donald trump wife
        donald trump jr
        donald trump dead
        donald trump memes
        donald trump net worth
#>
    [CmdletBinding()]
    [Alias('dym')]
    param(
        $Query
    )
    $uri = [uri]::escapeuristring("suggestqueries.google.com/complete/search?client=firefox&q=$Query")
    $content = (Invoke-WebRequest $uri).Content 
    ($content | ConvertFrom-Json).SyncRoot | Select-Object -Skip 1
}