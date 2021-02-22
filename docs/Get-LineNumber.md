# Get-LineNumber

## SYNOPSIS
Retrieve specific Linenumber(s) from afile.

## Script file
Data Wrangling\Get-LineNumber.ps1

## SYNTAX

```
Get-LineNumber -Path <Object> [-LineNumber] <Object>
```

## DESCRIPTION
Retrieve specific Linenumber(s) from a file.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
dir .\test.txt | Get-LineNumber 1,3,4
```
## PARAMETERS

### -Path
The path to the file to get the line(s) from.
Should be provided by pipeline for ease of use.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: FullName

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -LineNumber
The line number(s) to retrieve from the file.
Multiple numbers can be provided as an array of integers.

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



