# Get-Choice

## SYNOPSIS
An alternative to the built-in PromptForChoice providing a consistent UI across different hosts.

## Script file
Extend Builtin\Get-Choice.ps1

## Related blog post
https://powershellone.wordpress.com/2015/09/10/a-nicer-promptforchoice-for-the-powershell-console-host/

## SYNTAX

```
Get-Choice [-Title] <Object> [-Options] <String[]> [[-DefaultChoice] <Object>]
```

## DESCRIPTION
The PromptForChoice method on the System.Management.Automation.Host.PSHostUserInterface is declared as an abstract method. 
This basically means that the implementation details are up to the respective PowerShell host (as long as the method complies with the declaration).
As a result your script will not provide a consistent user experience across PowerShell hosts (e.g.
ISE, Console). 
Because of this I wrote a little Windows.Form based helper function that provides the same features as PromptForChoice but will look the same across all PowerShell hosts

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
#Create a dialog with 3 Options, choosing Option2 as the default choice.


Get-Choice "Pick Something!" (echo Option&1 Option&2 Option&3) 2
```
## PARAMETERS

### -Title
Title of the dialog.

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

### -Options
String array of options to be shown.
Each option will be shown as the caption of a button within the dialog.
      Similar to the way it works in PromptForChoice preceding a character from within the option values with an ampersand (e.g.
Option &1) 
      will make the button accessible via ALT-key + the letter (e.g.
ALT + 1)

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: 

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DefaultChoice
Number of the option (1 Option = 1) to be the default.
A value of -1 indicates that the dialog will not have a default option.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: False
Position: 3
Default value: -1
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://powershellone.wordpress.com/2015/09/10/a-nicer-promptforchoice-for-the-powershell-console-host/](https://powershellone.wordpress.com/2015/09/10/a-nicer-promptforchoice-for-the-powershell-console-host/)



