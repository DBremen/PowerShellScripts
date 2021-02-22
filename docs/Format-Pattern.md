# Format-Pattern

## SYNOPSIS
Highlight a pattern in the output.
Cannot be used in the middle of a pipeline.
And works only on the commandline.

## Script file
format output\Format-Pattern.ps1

## SYNTAX

```
Format-Pattern [-InputObject] <Object> -Pattern <Object> -Color <ConsoleColor> [-SimpleMatch]
```

## DESCRIPTION
Uses split Out-String, and Write-Host to highlight a pattern in the output.
Does not return objects and therefore cannot be used in the middle of a pipeline.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
#Highlight the word 'firefox' in Magenta within the output of Get-Process


Get-Process | Format-Pattern -Pattern firefox -Color Magenta
```
## PARAMETERS

### -InputObject
The object(s) that contain the pattern to be highlighted (best used as pipeline input)

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
The pattern to identify the string within the output to be highlighted.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Color
The Color to highlight the matches in.

```yaml
Type: ConsoleColor
Parameter Sets: (All)
Aliases: 
Accepted values: Black, DarkBlue, DarkGreen, DarkCyan, DarkRed, DarkMagenta, DarkYellow, Gray, DarkGray, Blue, Green, Cyan, Red, Magenta, Yellow, White

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SimpleMatch
Switch parameter if specified the Pattern is not considered as a RegEx pattern.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS



