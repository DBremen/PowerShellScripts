# Get-LegacyHelp

## SYNOPSIS
Display help for windows commandline commands

## Script file
Get-LegacyHelp\Get-LegacyHelp.psm1

## Related blog post
https://powershellone.wordpress.com/2016/05/23/get-help-for-windows-built-in-command-line-tools-with-powershell/

## SYNTAX

### Set1 (Default)
```
Get-LegacyHelp [-Name] <String> [-Full]
```

### Set3
```
Get-LegacyHelp [-Name] <String> [-Examples]
```

### Set2
```
Get-LegacyHelp [-Name] <String> [-Parameter <String>]
```

## DESCRIPTION
Similar to the built-in PowerShell help this function displays help for windows commmandline commands

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-LegacyHelp chkdsk
```
### -------------------------- EXAMPLE 2 --------------------------
```
Get-LegacHelp chkd* -Parameter c
```
### -------------------------- EXAMPLE 3 --------------------------
```
Get-LegacHelp chkd* -Parameter *
```
## PARAMETERS

### -Name
The name of the legacy windows command to find the help for.
Wildcards are permitted.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Parameter
Displays only the detailed descriptions of the specified parameters.
Wildcards are permitted.

```yaml
Type: String
Parameter Sets: Set2
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Examples
Displays only the Name, Description and the examples for the legacy command

```yaml
Type: SwitchParameter
Parameter Sets: Set3
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Full
Displays the entire help topic for a windows legacy command, including parameter descriptions

```yaml
Type: SwitchParameter
Parameter Sets: Set1
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

[https://powershellone.wordpress.com/2016/05/23/get-help-for-windows-built-in-command-line-tools-with-powershell/](https://powershellone.wordpress.com/2016/05/23/get-help-for-windows-built-in-command-line-tools-with-powershell/)







