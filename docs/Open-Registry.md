# Open-Registry

## SYNOPSIS
Open the regedit at the specified path similar to sysinternals regjump.

## Script file
Utils\Open-Registry.ps1

## SYNTAX

```
Open-Registry [[-regKey] <Object>]
```

## DESCRIPTION
Opens regedit at the specified path accepts multiple paths provided as argument or from the clipboard (if no argument provided).
Registry paths can contain leading abbreviated hive names (e.g.
HKLM, HKCU) or PowerShell paths (e.g.
HKLM:\\). 
If the path does not represent an existing key withn the registry the path is shortened one level until
a valid path is found (warning is displayed if no part of the path is found).

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
#the example opens multiple instances of regedit with at the specified paths via an argument to the regKey paramater


$testKeys =@'
HKLM\Software\Microsoft\Outlook Express
HKLM\Software\Microsoft\PowerShell
HKLM\Software\Microsoft\Windows
'@ -split "\`r\`n"
Open-Registry $testKeys
```
### -------------------------- EXAMPLE 2 --------------------------
```
#the example demonstrates the use case if the keys are in the clipboard


@'
HKLM\Software\Microsoft\Outlook Express
HKLM\Software\Microsoft\PowerShell
HKLM\Software\Microsoft\Windows
'@ -split "\`r\`n" | clip
Open-Registry
```
### -------------------------- EXAMPLE 3 --------------------------
```
#the example will open regedit with the run key open as the last part of the path does not represent a key


Open-Registry HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\skype
```
### -------------------------- EXAMPLE 4 --------------------------
```
#the example provides an invalid path to the function (using the alias) resulting in a warning message and no instance of regedit opening


regJump HKLMm\xxxxx
```
## PARAMETERS

### -regKey
A string or a string array representing one or more registry paths.
The paths can contain leading abbreviated hive names like HKLM:, HKLM:\, HKCU:...

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









