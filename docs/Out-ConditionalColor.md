# Out-ConditionalColor

## SYNOPSIS
Filter to conditionally format PowerShell output within the PowerShell console.

## Script file
format output\Out-ConditionalColor.ps1

## SYNTAX

```
Out-ConditionalColor [[-ConditionColor] <Hashtable>]
```

## DESCRIPTION
Filter to conditionally format PowerShell output.
Does not turn the output into string.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
#build the hashtable with condition/color pairs


$ht=@{}
      $upperLimit=1000
      $ht.Add("\`$_.handles -gt $upperLimit",\[ConsoleColor\]::Red)
      $ht.Add('$_.handles -lt 50',\[ConsoleColor\]::Green)
      $ht.Add('$_.Name -eq "svchost"',\[ConsoleColor\]::Blue)
      Get-Process | Out-ConditionalColor -conditionColor $ht
      #proof that we are still working with objects 
      Get-Process | Out-ConditionalColor -conditionColor $ht | where {$_.Name -eq 'svchost'}
```
## PARAMETERS

### -ConditionColor
HashTable:
          - Key(s) = Predicate representing the condition as string
          - Value(s) = The foreground color to be applied to the items matching the condition (\[ConsoleColor\])

```yaml
Type: Hashtable
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

[Out-ConditionalColorProperties]()



