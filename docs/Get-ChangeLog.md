# Get-ChangeLog

## SYNOPSIS
Comparing two objects or .csv files column by column.

## Script file
Data Wrangling\Get-ChangeLog.ps1

## Related blog post
https://powershellone.wordpress.com/2015/06/30/comparing-two-objects-or-csv-files-column-by-column/

## SYNTAX

```
Get-ChangeLog [[-ReferenceObject] <Object>] [[-DifferenceObject] <Object>] [[-Identifier] <Object>]
```

## DESCRIPTION
Compare objects showing which property has changed along with the old and new values

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$referenceObject=@'


ID,Name,LastName,Town
    1,Peter,Peterson,Paris
    2,Mary,Poppins,London
    3,Dave,Wayne,Texas
    4,Sandra,Mulls,Berlin
'@ | ConvertFrom-CSV

$differenceObject=@'
    ID,Name,LastName,Town
    1,Peter,Peterson,Paris
    2,Mary,Poppins,Cambridge
    5,Bart,Simpson,Springfield
    4,Sandra,Mulls,London
'@ | ConvertFrom-CSV
Get-ChangeLog $referenceObject $differenceObject ('ID') | Format-Table -AutoSize
```
## PARAMETERS

### -ReferenceObject
Object that represents the reference object for the comparison

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

### -DifferenceObject
Object that represents the difference object for the comparison

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

### -Identifier
A property (can be also multiple properties) that acts as a unique identifier for the object.
      This is in order to be able to know what to compare to across both objects.

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

[https://powershellone.wordpress.com/2015/06/30/comparing-two-objects-or-csv-files-column-by-column/](https://powershellone.wordpress.com/2015/06/30/comparing-two-objects-or-csv-files-column-by-column/)



