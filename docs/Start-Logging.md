# Start-Logging

## SYNOPSIS
Module to provide a logging functionality for scripts originally written by Oisin Grehan
see link.

## Script file
Logging\Logging.psm1

## SYNTAX

```
Start-Logging [-scriptPath] <Object>
```

## DESCRIPTION
The module exports only one function Start-Logging.
This function provides logging 
functionality for script files
Errors are written to the event log and are sent by email
The logging can be implemented in any script by adding the following two lines at the beginning of the Main function:
- ipmo "$script:scriptPath\get-stats\Helper\Logging.psm1" -Force
- Start-Logging (Get-ScriptDirectory);exit (where Get-ScriptDirectory is a function that retrieves the directory the script is running in (see example))
-the Start-Logging function will read the script (replacing the lines that call the logging) and create a scriptblock that runs asynchronously
- providing the logging functionality where errors are logged to the "PowerShell Scripts" event log and send by email

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
function MyFunc{


$script:scriptDir = Get-ScriptDirectory | Split-Path -Parent
	#setup the logging and exit.
this will start the whole script in a new thread with logging facility
	#uncomment next two lines for debugging (without logging)
	Import-Module "$scriptDir\Helper\Logging.psm1" -Force
	Start-Logging (Get-ScriptDirectory);exit
	#actual code comes here
}
function Get-ScriptDirectory{
	$Invocation = (Get-Variable MyInvocation -Scope 1).Value
	$Invocation.ScriptName
}
```
## PARAMETERS

### -scriptPath
The fullpath to the script to enable the logging for.

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

## INPUTS

## OUTPUTS

### - in case of error:
	- email with error details
	- event log entry

## NOTES

## RELATED LINKS

[http://web.archive.org/web/20110130052044/http://www.nivot.org/2009/08/19/PowerShell20AConfigurableAndFlexibleScriptLoggerModule.aspx](http://web.archive.org/web/20110130052044/http://www.nivot.org/2009/08/19/PowerShell20AConfigurableAndFlexibleScriptLoggerModule.aspx)



