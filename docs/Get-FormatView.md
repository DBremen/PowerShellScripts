# Get-FormatView

## SYNOPSIS
Function to get the format views for a particular type.

## Script file
format output\Get-FormatView.ps1

## Related blog post
https://powershellone.wordpress.com/2015/03/09/powershell-format-table-views/

## SYNTAX

```
Get-FormatView [-TypeName] <Object>
```

## DESCRIPTION
Format views are defined inside the *format.ps1xml files and represent named sets of properties per type which can be used with any of the Format-* cmdlets. 
Retrieving the format views for a particular type can be accomplished by pulling out the information from the respective XML files using this function.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-Process | Get-FormatView | Format-Table -Auto
```
## PARAMETERS

### -TypeName
{{Fill TypeName Description}}

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

[https://powershellone.wordpress.com/2015/03/09/powershell-format-table-views/](https://powershellone.wordpress.com/2015/03/09/powershell-format-table-views/)

[Add-FormatTableView]()



