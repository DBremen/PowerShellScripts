# ConvertFrom-ExcelClipboard

## SYNOPSIS
Convert copied range from excel to an array of PSObjects

## Script file
Utils\ConvertFrom-ExcelClipboard.ps1

## Related blog post
https://powershellone.wordpress.com/2016/06/02/powershell-tricks-convert-copied-range-from-excel-to-an-array-of-psobjects/

## SYNTAX

```
ConvertFrom-ExcelClipboard [[-Header] <String[]>] [-Raw]
```

## DESCRIPTION
A range of cells copied into the clipboard is converted into PSObject taking the first row (or provided property names via Header parameter) as the properties.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
#Considering a range of cells including header has been copied to the clipboard


ConvertFrom-ExcelClipboard
```
### -------------------------- EXAMPLE 2 --------------------------
```
#Convert excel range without headers providing property names through argument to the Headers parameter


ConvertFrom-ExcelClipboard -Header test1,test2,test3
```
## PARAMETERS

### -Header
Specifies an alternate column header row.
The column header determines the names of the properties of the object(s) created.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: 

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Raw
If specified, the content of the clipboard is returned as is.

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

[https://powershellone.wordpress.com/2016/06/02/powershell-tricks-convert-copied-range-from-excel-to-an-array-of-psobjects/](https://powershellone.wordpress.com/2016/06/02/powershell-tricks-convert-copied-range-from-excel-to-an-array-of-psobjects/)





