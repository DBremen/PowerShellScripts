# Sort-CustomList

## SYNOPSIS
Sort data using a custom list in PowerShell.

## Script file
Data Wrangling\Sort-CustomList.ps1

## Related blog post
https://powershellone.wordpress.com/2015/07/30/sort-data-using-a-custom-list-in-powershell/

## SYNTAX

```
Sort-CustomList [-InputObject <Object>] [[-CustomList] <Object>] [[-PropertyName] <Object>]
 [[-AdditionalProperty] <Object>]
```

## DESCRIPTION
Sort data based on a custom list similar to the functionality provided in Excel.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$CustomList = 'iexplore', 'excel', 'notepad'


Get-Process | Sort-CustomList $CustomList Name
```
## PARAMETERS

### -InputObject
The object or collection of objects to be sorted.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -CustomList
The custom list that determines the sort order.

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

### -PropertyName
The name of the property that should be sorted.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AdditionalProperty
One or more property names to be sorted against.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://powershellone.wordpress.com/2015/07/30/sort-data-using-a-custom-list-in-powershell/](https://powershellone.wordpress.com/2015/07/30/sort-data-using-a-custom-list-in-powershell/)



