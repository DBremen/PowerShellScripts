# ConvertFrom-HtmlToText

## SYNOPSIS
Extract the text out of a HTML string

## Script file
Utils\ConvertFrom-HtmlToText.ps1

## SYNTAX

```
ConvertFrom-HtmlToText [-HTML] <Object>
```

## DESCRIPTION
Converts a string of HTML to an array of strings where each HTML elements text is one item, using InternetExplorer COM object

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
#using alias


PS\> '\<li\>test1\</li\>\<li\>test2\</li\>' | html2Text
#output: 
test1
test2
```
## PARAMETERS

### -HTML
The HTML fragment (The function automatically wraps it into well-formed HTML)

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS



