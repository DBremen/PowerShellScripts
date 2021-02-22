# Invoke-LegacyCommand

## SYNOPSIS
Helper to invoke legacy command with switches from PowerShell in a convenient way. 
Also supports pipeline input to invoke the command with arguments multiple times.

## Script file
Utils\Invoke-LegacyCommand.ps1

## SYNTAX

```
Invoke-LegacyCommand [-CommandAndArgs] <String[]> [-PipelineInput <String>]
```

## DESCRIPTION
Supports convenient way to invoke legacy command through PowerShell without quotes and escaping needed.
See Example

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
1,2,3 | legacy cmd /c echo


#runs cmd /c echo with 1, 2, and, 3
```
## PARAMETERS

### -CommandAndArgs
The command to invoke and its options/switches as string.
See Example.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PipelineInput
Optional input via pipeline to invoke the command and its switches multiple times against.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS



