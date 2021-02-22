# Out-ConditionalColorProperties

## SYNOPSIS
Filter to conditionally format property values within PowerShell output on the console.

## Script file
format output\Out-ConditionalColorProperties.ps1

## SYNTAX

```
Out-ConditionalColorProperties [[-ConditionColorProp] <Object>]
```

## DESCRIPTION
Filter to conditionally format property values within PowerShell output on the console.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
#build the hashtable with condition/color/"property value to highlight" pairs


$ht=@{}
      $upperLimit=1000
      $ht.Add("\`$_.handles -gt $upperLimit",("red","handles"))
      $ht.Add('$_.handles -lt 50',("green","handles"))
      $ht.Add('$_.Name -eq "svchost"',("blue","name"))
      Get-Process | Out-ConditionalColorProperties -conditionColorProp $ht
```
### -------------------------- EXAMPLE 2 --------------------------
```
$ht=@{}


$ht.Add('$_.Name.StartsWith("A")',("red","name"))
dir | Out-ConditionalColorProperties -conditionColorProp $ht
```
## PARAMETERS

### -ConditionColorProp
{{Fill ConditionColorProp Description}}

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

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS





