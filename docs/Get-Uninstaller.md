# Get-Uninstaller

## SYNOPSIS
Function to get the uninstaller for installed software via registry (PowerShell v4 and \<) or Get-Package)

## Script file
Utils\Get-Uninstaller.ps1

## Related blog post
https://powershellone.wordpress.com/2016/02/13/retrieve-uninstallstrings-to-fix-installer-issues/

## SYNTAX

```
Get-Uninstaller [[-Name] <Object>] [[-Hive] <String[]>]
```

## DESCRIPTION
I have encountered several installer related issues on my machine.
Most of them seemed to be caused by insufficient privileges.
This kind of issue can be usually fixed by running the installer "As Administrator". 
In case the issue is in relation to an already installed software packet, 
it's sometimes not so easy to locate the respective uninstaller/MSI packet, though.
For that purpose,

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
#Powershell v4 and lower


#search for the chrome uinstaller only in the machine wide registry hive
Get-Uninstaller *chrome* -Hive HKLM
#v5 and higher
Get-Uninstaller *chrome*
```
## PARAMETERS

### -Name
Search for software by name including wildcards.
Defaults to '*'

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: False
Position: 1
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### -Hive
Only the be used for PowerShell v4 or lower.
Search through user specific (HKCU) and/or machine specific 
      (HKLM) registry hives (parameter Hive defaults to HKLM, HKCU only accepts a combination of 'HKCU' and/or 'HKLM')

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: 

Required: False
Position: 2
Default value: @('HKLM','HKCU')
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://powershellone.wordpress.com/2016/02/13/retrieve-uninstallstrings-to-fix-installer-issues/](https://powershellone.wordpress.com/2016/02/13/retrieve-uninstallstrings-to-fix-installer-issues/)



