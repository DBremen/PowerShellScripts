# Get-FormatStrings

## SYNOPSIS
Show common format strings for a given input and the respective outputs

## Script file
Utils\Get-FormatStrings.ps1

## Related blog post
https://powershellone.wordpress.com/2018/07/19/get-net-format-strings-for-given-input/

## SYNTAX

```
Get-FormatStrings [-ToBeFormatted] <Object>
```

## DESCRIPTION
Show common format strings for a given input and the respective outputs

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-FormatStrings (Get-Date)


#Return common format strings for date objects

FormatString                          Output                          
------------                          ------                          
'{0:d}'       -f 05/15/2018 15:33:46  5/15/2018                       
'{0:D}'       -f 05/15/2018 15:33:46  Tuesday, May 15, 2018           
'{0:f}'       -f 05/15/2018 15:33:46  Tuesday, May 15, 2018 3:33 PM   
'{0:F}'       -f 05/15/2018 15:33:46  Tuesday, May 15, 2018 3:33:46 PM
'{0:g}'       -f 05/15/2018 15:33:46  5/15/2018 3:33 PM               
'{0:G}'       -f 05/15/2018 15:33:46  5/15/2018 3:33:46 PM    
...
```
## PARAMETERS

### -ToBeFormatted
The input that should be formatted.
This should either be of type \[int\], \[double\], or \[datetime\] otherwise the function returns a warning and exits.

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

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://powershellone.wordpress.com/2018/07/19/get-net-format-strings-for-given-input/](https://powershellone.wordpress.com/2018/07/19/get-net-format-strings-for-given-input/)



