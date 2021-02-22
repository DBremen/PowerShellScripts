# Get-Range

## SYNOPSIS
Function to retrieve a continuous or stepwise Range of integers,decimals,dates,month names, day names or chars.
Simulating Haskell\`s Range operator

## Script file
Extend Builtin\Get-Range.ps1

## Related blog post
https://powershellone.wordpress.com/2015/03/15/extending-the-powershell-Range-operator/

## SYNTAX

```
Get-Range [[-Range] <Object>]
```

## DESCRIPTION
The function works similar to the built-in Range operator (..).
But adds functionality to retrieve stepwise Ranges date, month name, day name and 
character Ranges like in Haskell.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Set-Alias gr Get-Range


#same as built-in
gr 1..10

#Range of numbers from 1 to 33 with steps of .2
gr 1,1.2..33

#Range of numbers from 10 to 40 with steps of 10
gr 10,20..40

#Range of numbers from -2 to 1024 with steps of 6
gr -2,4..1kb

#Range of numbers from 10 to 1 with steps of -2
gr 10,8..1

#Range of characters from Z to A
gr Z..A

#Range of date objects 
gr 1/20/2014..1/1/2014

#Range of month names
gr March..May

#Range of day names
gr Monday..Wednesday
```
## PARAMETERS

### -Range
A string that represents the Range.
The Range can be specified as START..END or as FIRST,SECOND..END where the difference between
FIRST and SECOND (positive or negative) determines the step increment or decrement.
The elements of the Range can consist of only characters, integers,decimals,dates,month names,day names
or special PowerShell notation like 1kb,1mb,1e6...

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

[https://powershellone.wordpress.com/2015/03/15/extending-the-powershell-Range-operator/](https://powershellone.wordpress.com/2015/03/15/extending-the-powershell-Range-operator/)



