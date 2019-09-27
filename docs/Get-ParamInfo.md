# Get-ParamInfo

## SYNOPSIS
Retrieve extensive parameter information about a cmdlet

## Script file
Utils\Get-ParamInfo.ps1

## SYNTAX

```
Get-ParamInfo [[-Command] <String>] [-VerboseOutputOutput]
```

## DESCRIPTION
I don't remember the original source of this script anymore.
    Format the Get-Command information in a way to show info for each parameter for each parameter set of a given cmdlet.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-ParamInfo Get-Command
```
## PARAMETERS

### -Command
The name of the command to get the parameter info for.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -VerboseOutputOutput
{{Fill VerboseOutputOutput Description}}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS



