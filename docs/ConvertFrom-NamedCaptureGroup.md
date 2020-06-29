# ConvertFrom-NamedCaptureGroup

## SYNOPSIS
Convert the output of a RegEx named capture group to a PSObject

## Script file
Data Wrangling\ConvertFrom-NamedCaptureGroup.ps1

## SYNTAX

```
ConvertFrom-NamedCaptureGroup [-Text] <Object> [-Pattern] <Regex>
```

## DESCRIPTION
Converts the RegEx named capture group from a hashtable into a PSObject.
This uses Select-String -AllMatches to catch all occurences across all lines in the text matching
the RegEx pattern.
Following the idea of $txt | % { if ($_ -match $regex) { $Matches.Remove(0); new-object PSObject -property $Matches } }

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$Text = @'


\<a href="https://www.address1.com"\>Link 1\</a\>\<a href="https://www.address2.com"\>Link 2\</a\>
\<a href="https://www.address3.com"\>Link 3\</a\>\<a href="https://www.address4.com"\>Link 4\</a\>
'@  
$Pattern = \[regex\]'(?i)\<a href="(?\<link\>.*?)".*?\>(?\<text\>.*?)\</a\>'
ConvertFrom-NamedCaptureGroup $Text $Pattern

# output excerpt
link                     text
----                     ----
https://www.address1.com Link 1
https://www.address2.com Link 2
https://www.address3.com Link 3
https://www.address4.com Link 4
```
## PARAMETERS

### -Text
The text to apply the RegEx pattern against.
Can be multiline text

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

### -Pattern
The RegEx pattern containing named capture groups in the form of '(?\<CAPTUREGROUPNAME\>REGEXPATTERN)

```yaml
Type: Regex
Parameter Sets: (All)
Aliases: 

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS



