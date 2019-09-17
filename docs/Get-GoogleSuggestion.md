# Get-GoogleSuggestion

## SYNOPSIS
Function to get "Did you mean?" suggestions from Google.

## Script file
Utils\Get-GoogleSuggestion.ps1

## SYNTAX

```
Get-GoogleSuggestion [[-Query] <Object>]
```

## DESCRIPTION
Similar to the experience "Did you mean?" experience using the Google search engine,
      the function will return suggestions on mistyped search terms (word or sentence).

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
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
```
## PARAMETERS

### -Query
A word or sentence to get suggestions for.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS



