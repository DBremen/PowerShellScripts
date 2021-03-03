# Get-HelpSyntax

## SYNOPSIS
Get the syntax for a cmdlet pretty printed + explanation

## Script file
Extend Builtin\Get-HelpSyntax.ps1

## Related blog post
https://powershellone.wordpress.com/2018/07/25/powershell-get-command-syntax-output-explained/

## SYNTAX

```
Get-HelpSyntax [-Command] <Object>
```

## DESCRIPTION
Splits Get-Command CMD -Syntax output based on Regex (seen at PowerShell Conf EU I believe from Stefan Gustavson).
Adds explanatory text on the syntax of the syntax

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-HelpSyntax Get-Command
```
## PARAMETERS

### -Command
Name of the command to get the syntax for.

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

## NOTES

## RELATED LINKS

[https://powershellone.wordpress.com/2018/07/25/powershell-get-command-syntax-output-explained/](https://powershellone.wordpress.com/2018/07/25/powershell-get-command-syntax-output-explained/)



