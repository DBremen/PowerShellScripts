# Get-CartesianProduct

## SYNOPSIS
Get the cartesian product for an object that contains array properties.
See example.

## Script file
programming exercises\Get-CartesianProduct.ps1

## SYNTAX

```
Get-CartesianProduct [-InputObject] <Object> [[-CurrPropIndex] <Object>]
```

## DESCRIPTION
Given an object that contains properties that contain arrays.
The function will build a cartesian product returning each possible combination
given the array entries (see Example)

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
# Build an array of order objects with array entries


function New-Order ($Name,$Product,$Preference){
    \[PSCustomObject\]\[Ordered\]@{Name=$Name;Product=$Product;Preference=$Preference}
}
$orders = @()
$orders += New-Order Peter Product1 'Fast Delivery'
$orders += New-Order Nigel ('Product1', 'Product2') ('Fast Delivery', 'Product Quality')
$orders += New-Order Carmen ('Product3', 'Product5') Support
$orders += New-Order Rene Product2 ('Price', 'Fast Delivery')
# Get the cartesian product of the order objects array, splitting each of the possible combinations from the array properties
# into a separate object
$orders | Get-CartesianProduct
```
## PARAMETERS

### -InputObject
The object(s) that is used to build the cartesian product

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

### -CurrPropIndex
Just used internally for recursive calls of the function when iterating through the properties

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: False
Position: 2
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS



