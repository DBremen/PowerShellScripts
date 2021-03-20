# Generate-ScriptMarkdownHelp

## SYNOPSIS
The function that generated the Markdown help in this repository.
(see Example for usage). 
Generates markdown help for Github for each function containing comment based help (Description not empty) within a folder recursively and a summary table for the main README.md Generate-ScriptMarkdownHelp.ps1

## Script file
PowerShellScripts\Generate-ScriptMarkdownHelp.ps1

## SYNTAX

```
Generate-ScriptMarkdownHelp [[-Path] <Object>]
```

## DESCRIPTION
Functions are extracted via Get-FunctionFromScript, dot sourced and parsed using platyPS.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
#because the functions are dot sourced within the function they are not visible wihtin the global scope


#therefore the script needs to be called by dot-sourcing itself
#open console
.
\<PATHTOTHISSCRIPT\>
#call the function
$path = \<PATHTOSCRIPTSTOBEDOCUMENTED\>
.
Generate-ScriptMarkdownHelp($path)
```
## PARAMETERS

### -Path
Path to the folder containing the scripts

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: False
Position: 1
Default value: C:\Scripts\ps1\PowerShellScripts
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS


