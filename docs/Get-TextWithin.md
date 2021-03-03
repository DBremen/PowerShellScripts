# Get-TextWithin

## SYNOPSIS
Get the text between two surrounding characters (e.g.
brackets, quotes, or custom characters)

## Script file
Data Wrangling\Get-TextWithin.ps1

## Related blog post
https://powershellone.wordpress.com/2021/02/24/using-powershell-and-regex-to-extract-text-between-delimiters/

## SYNTAX

### Single
```
Get-TextWithin [-Text] <Object> [[-WithinChar] <Char>]
```

### Double
```
Get-TextWithin [-Text] <Object> [-StartChar <Char>] [-EndChar <Char>]
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
### -------------------------- EXAMPLE 2 --------------------------
```
# Retrieve all text within custom start and end characters


$s=@'
here is /some data\
here is /some other data/
this is /even more data\
'@
Get-TextWithin $s -StartChar / -EndChar \
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
If this paramater is used the matching ending character is "guessed" (e.g.
'(' = ')')

```yaml
Type: Char
Parameter Sets: Single
Aliases: 

Required: False
Position: 2
Default value: "
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartChar
Single character, indicating the start surrounding characters to retrieve the enclosing text for.

```yaml
Type: Char
Parameter Sets: Double
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndChar
Single character, indicating the end surrounding characters to retrieve the enclosing text for.

```yaml
Type: Char
Parameter Sets: Double
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://powershellone.wordpress.com/2021/02/24/using-powershell-and-regex-to-extract-text-between-delimiters/](https://powershellone.wordpress.com/2021/02/24/using-powershell-and-regex-to-extract-text-between-delimiters/)





