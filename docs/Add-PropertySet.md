# Add-PropertySet

## SYNOPSIS
Function to create property sets

## Script file
format output\Add-PropertySet.ps1

## Related blog post
https://powershellone.wordpress.com/2015/03/06/powershell-propertysets-and-format-views/

## SYNTAX

```
Add-PropertySet -InputObject <Object> [-PropertySetName] <Object> [-properties] <Object>
```

## DESCRIPTION
Property sets are named groups of properties for certain types that can be used through Select-Object.
The function adds a new property set to a type via a types.ps1xml file.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$fileName = dir | Add-PropertySet Testing ('Name', 'LastWriteTime', 'CreationTime')


dir | Get-Member -MemberType PropertySet
      dir | select Testing
      #add this to the profile to have the property set available in all sessions
      Update-TypeData -PrependPath $fileName
```
### -------------------------- EXAMPLE 2 --------------------------
```
Get-Process | Add-PropertySet RAM ('Name', 'PagedMemorySize', 'PeakWorkingSet')


Get-Process | select RAM
```
## PARAMETERS

### -InputObject
The object or collection of objects where the property set is added

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -PropertySetName
The name of the porperty set

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

### -properties
{{Fill properties Description}}

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

[https://powershellone.wordpress.com/2015/03/06/powershell-propertysets-and-format-views/](https://powershellone.wordpress.com/2015/03/06/powershell-propertysets-and-format-views/)





