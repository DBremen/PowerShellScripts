# WhereEx

## SYNOPSIS
POC for a simplified Where-Object with multiple conditions on the same property for PowerShell.

## Script file
Extend Builtin\WhereEx.ps1

## Related blog post
https://powershellone.wordpress.com/2015/11/02/simplified-where-object-for-multiple-conditions-on-the-same-property-for-powershell/

## SYNTAX

```
WhereEx [-InputObject <Object>] [-PredicateString] <Object>
```

## DESCRIPTION
Allows for avoiding multiple mentions of the property name when using Where-Object with multiple conditions on the same property.
Parentheses indicate that the preceding variable should be considered as the (left-hand) parameter for the operator. 
(see Example)

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
1..10 | WhereEx {$_ (-gt 5 -and -lt 8)}
```
### -------------------------- EXAMPLE 2 --------------------------
```
Get-Process | WhereEx {$_.Name (-like 'power*' -and -notlike '*ise')}
```
## PARAMETERS

### -InputObject
The object or collection to filter.

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

### -PredicateString
The predicate as a String that determines the filter logic.
      Parentheses indicate that the preceding variable should be considered as the (left-hand) parameter for the operator.
 
      (See Example)

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

[https://powershellone.wordpress.com/2015/11/02/simplified-where-object-for-multiple-conditions-on-the-same-property-for-powershell/](https://powershellone.wordpress.com/2015/11/02/simplified-where-object-for-multiple-conditions-on-the-same-property-for-powershell/)





