# Restart-Process

## SYNOPSIS
Function to restart process(es)

## Script file
Utils\Restart-Process.ps1

## Related blog post
https://powershellone.wordpress.com/2016/02/25/fix-clipboard-is-not-working-restart-process-with-powershell/

## SYNTAX

```
Restart-Process [-Process] <Process>
```

## DESCRIPTION
Takes input via pipeline from Get-Process and restarts the process(es).
If there is more than one instance of the same application:
Then the function prompts to select the instance of the application to restart by index.
An index of -1 stops all instances of the application and
restarts the first.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
#start 2 instances of notepad and restart the second


notepad
notepad
Get-Process notepad | Restart-Process
#enter index 2 when prompted
```
### -------------------------- EXAMPLE 2 --------------------------
```
#start 3 instances of notepad restart the first and stop the others


notepad
notepad
notepad
Get-Process notepad | Restart-Process
#enter index -1 when prompted
```
### -------------------------- EXAMPLE 3 --------------------------
```
#start notepad and calc and restart


Get-Process notepad,calc | Restart-Process
```
## PARAMETERS

### -Process
Process(es) to restart piped in via Get-Process

```yaml
Type: Process
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

[https://powershellone.wordpress.com/2016/02/25/fix-clipboard-is-not-working-restart-process-with-powershell/](https://powershellone.wordpress.com/2016/02/25/fix-clipboard-is-not-working-restart-process-with-powershell/)







