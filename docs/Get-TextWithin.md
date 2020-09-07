# Get-TextWithin

## SYNOPSIS
Get the text between two (balanced) surrounding characters (e.g.
brackets, quotes...)

## Script file
Data Wrangling\Get-TextWithin.ps1

## SYNTAX

```
Get-TextWithin [-Text] <Object> [[-WithinChar] <Char>]
```

## DESCRIPTION
Use RegEx to retrieve the text within enclosing characters.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
# Retrieve all text within single quotes


$s=@'
here is 'some data'
here is "some other data"
this is 'even more data'
'@
Get-TextWithin $s "'"
```
## PARAMETERS

### -Text
The text to retrieve the matches from.

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

### -WithinChar
Single character, indicating the surrounding characters to retrieve the enclosing text for.

```yaml
Type: Char
Parameter Sets: (All)
Aliases: 

Required: False
Position: 2
Default value: "
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS



