# Add-PowerShellContextMenu

## SYNOPSIS
Function to create context menu entries in order to invoke PowerShell

## Script file
Utils\Add-PowerShellContextMenu.ps1

## Related blog post
https://powershellone.wordpress.com/2015/09/16/adding-edit-with-powershell-ise-and-open-powershell-here-as-admin-to-the-context-menu/

## SYNTAX

```
Add-PowerShellContextMenu [[-ContextType] <Object>] [-Platform <Object>] [-NoProfile] [-AsAdmin]
```

## DESCRIPTION
While there is already a default 'Edit' context menu entry for PowerShell ISE I wanted to have it open a specific Platform version elevated without loading profile). 
In addition to that I also like to add a context menu entry to open up a PowerShell command prompt from any folder or drive in Windows Explorer.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Add-PowerShellContextMenu -ContextType editWithPowerShellISE -Platform x86 -AsAdmin
```
### -------------------------- EXAMPLE 2 --------------------------
```
Add-PowerShellContextMenu -ContextType openPowerShellHere -Platform x86 -AsAdmin
```
## PARAMETERS

### -ContextType
Indicates the type of context menu entry to create.
Possible values are openPowerShellHere and editWithPowerShellISE

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

### -Platform
The platform type of Powershell to create the context menu entry for.
Defaults to x64.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: X64
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoProfile
{{Fill NoProfile Description}}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -AsAdmin
{{Fill AsAdmin Description}}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://powershellone.wordpress.com/2015/09/16/adding-edit-with-powershell-ise-and-open-powershell-here-as-admin-to-the-context-menu/](https://powershellone.wordpress.com/2015/09/16/adding-edit-with-powershell-ise-and-open-powershell-here-as-admin-to-the-context-menu/)





