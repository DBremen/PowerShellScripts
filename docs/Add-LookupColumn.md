# Add-LookupColumn

## SYNOPSIS
Funciton to use Excel's vlookup through PowerShell.
Requires Excel to be installed.

## Script file
Data Wrangling\Add-LookupColumn.ps1

## SYNTAX

```
Add-LookupColumn [-Table] <Object> [-LookupTable] <Object> [-LookupProperty] <Object>
 [[-ReturnProperty] <Object>]
```

## DESCRIPTION
Uses Excel's vlookup to return matching values for a column (property) in another table(object of arrays)
based on a Lookup column (property).
Property values that have no matching entry in the LookupTable will 
get a value of -1.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$test = @'


Name,LastName
Dirk,Smith
Carol,Carlson
Gisela,Knight
Aidan, Gray
'@ | ConvertFrom-Csv

$test2 = @'
Name,City
Dirk,Dublin
Carol,London
Gisela,Cologne
'@ | ConvertFrom-Csv
#Add a new column City to $test based on matching Names in $test2
vLookup $test $test2 Name City
```
## PARAMETERS

### -Table
The array of objects (Table), that contains the values to lookup and that the new column will be added to. 
based on matching values in the LookupTable.

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

### -LookupTable
The array of objects (Table), that contains the matching values.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LookupProperty
The property to match both array of objects based upon.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReturnProperty
The property to add to the table based on the matches from the lookupTable

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://support.office.com/en-us/article/vlookup-function-0bbc8083-26fe-4963-8ab8-93a18ad188a1](https://support.office.com/en-us/article/vlookup-function-0bbc8083-26fe-4963-8ab8-93a18ad188a1)



