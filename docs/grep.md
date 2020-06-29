# grep

## SYNOPSIS
Filter output based on keyword, but still retain PowerShell object format.
Hence it can be even used in the middle of a pipeline (see example):

## Script file
Data Wrangling\grep.ps1

## SYNTAX

```
grep -Text <Object> [-Keyword] <Object>
```

## DESCRIPTION
This was one of the great Idera PowerShell PowerTips (similar to the one in the link but not exactly this one.)

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-Process | grep svchost | select name,id
```
## PARAMETERS

### -Text
{{Fill Text Description}}

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Keyword
The text to filer

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/filter-powershell-results-fast-and-text-based](https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/filter-powershell-results-fast-and-text-based)



