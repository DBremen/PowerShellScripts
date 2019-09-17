# ConvertTo-PSFunction

## SYNOPSIS
Function to "convert" legacy command line commands to PowerShell functions

## Script file
Utils\ConvertTo-PSFunction.ps1

## SYNTAX

```
ConvertTo-PSFunction [[-nativeCommands] <String[]>]
```

## DESCRIPTION
The function creates dynamically functions that call legacy commands which support the output
format csv (/fo csv).
The new functions pass all provided switches + "/fo csv" to the legacy command and 
pipe the output to ConverFrom-CSV in order to receive PowerShell objects.
The names of the dynamically created functions consist of the prefix "PS" and the name of the command.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
#Convert some built-in commandline tools and use them


ConverTo-PSFunction driverquery,systeminfo,getmac,whoami
#the out-host calls are just necessary to workaround an issue where the output is not displayed when multiple "table" results are displayed
PSgetmac /v | where {$_."Connection Name" -eq "Ethernet"} | Out-Host
PSwhoami /groups | Out-Host
PSsysteminfo | Out-Host
PSdriverquery /s .
/si | where {$_."Manufacturer" -eq "Microsoft"} | Out-Host
```
## PARAMETERS

### -nativeCommands
Array of commandline tool name(s) (in case those reside within the SYSTEMPATH, the name without .exe is sufficient)

```yaml
Type: String[]
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



