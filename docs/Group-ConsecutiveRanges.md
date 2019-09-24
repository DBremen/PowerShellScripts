# Group-ConsecutiveRanges

## SYNOPSIS
Given an integer array with numbers, return groups of consecutive ranges.

## Script file
Data Wrangling\Group-ConsecutiveRanges.ps1

## SYNTAX

```
Group-ConsecutiveRanges [-IntArray] <Int32[]>
```

## DESCRIPTION
Makes use of the fact that for consecutive numbers (IndexOf(element) - element) is the same.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
7,2,8,5,17,3,4,20,15,9,18,1,16 | Group-ConsecutiveRanges
```
## PARAMETERS

### -IntArray
An array of integers to group by consecutive ranges.

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS



