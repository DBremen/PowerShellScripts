# New-PSObject

## SYNOPSIS
Helper function to create PSCustomObjects based on array of names and array of properties.

## Script file
Utils\New-PSObject.ps1

## SYNTAX

```
New-PSObject [-PropertyNames] <Array> [-Values] <Object>
```

## DESCRIPTION
Enables rapid creation of PSCustomObjects

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$props= echo City Country CurrencySymbol


$result = & {
    new-psobject $props Berlin Germany EUR
    new-psobject $props Zurich Switzerland CHF
}
$result
```
## PARAMETERS

### -PropertyNames
An array of property names

```yaml
Type: Array
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Values
The values to be assigned to the properties in the same order as the property names

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

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS



