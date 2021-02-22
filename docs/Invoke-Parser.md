# Invoke-Parser

## SYNOPSIS
Uses PowerShell's parser and returns the AST, Tokens and Errors

## Script file
Utils\Invoke-Parser.ps1

## SYNTAX

```
Invoke-Parser [-Target] <String>
```

## DESCRIPTION
I don't know the source of this script.
Handles parsing PowerShell script files or strings.
Uses the builtin System.Management.Automation.Language.Parser and returns
an object that has the AST (Abstract Syntax Tree), raw tokens and errors.
Plus, it adds to script properties that surfaces the tokens and errors
in a specific format

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Invoke-ParseScript c:\test.ps1
```
## PARAMETERS

### -Target
The script to parse, can be a path to a script file or a string of code.

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

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS



