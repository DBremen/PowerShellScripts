# Get-FunctionFromScript

## SYNOPSIS
Gets the functions and filters declared within a script block or a file

## Script file
PowerShellScripts\Generate-ScriptMarkdownHelp.ps1

## SYNTAX

### File (Default)
```
Get-FunctionFromScript -File <String> [-OutputMetaData]
```

### ScriptBlock
```
Get-FunctionFromScript [-ScriptBlock] <ScriptBlock> [-OutputMetaData]
```

## DESCRIPTION
Gets the functions exactly as they are written within a script or file

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-FunctionFromScript {


function foo() {
        "foo"
    }
    function bar() {
        "bar"
    }
}
```
## PARAMETERS

### -ScriptBlock
The script block containing functions

```yaml
Type: ScriptBlock
Parameter Sets: ScriptBlock
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -File
A file containing functions

```yaml
Type: String
Parameter Sets: File
Aliases: FullName

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -OutputMetaData
If set, outputs the command metadatas

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

### System.Management.Automation.ScriptBlock

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS

[http://powershellpipeworks.com/](http://powershellpipeworks.com/)


