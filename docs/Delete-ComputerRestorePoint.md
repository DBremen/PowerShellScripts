# Delete-ComputerRestorePoint

## SYNOPSIS
Function to Delete Windows System Restore points

## Script file
Utils\Delete-ComputerRestorePoint.ps1

## SYNTAX

```
Delete-ComputerRestorePoint [-RestorePoint] <Object> [-WhatIf] [-Confirm]
```

## DESCRIPTION
Deletes Windows System Restore point(s) passed as an argument or via pipeline

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
#use -WhatIf to see what would have happened


Get-ComputerRestorePoint | Delete-ComputerRestorePoints -WhatIf
```
### -------------------------- EXAMPLE 2 --------------------------
```
#delete all System Restore Points older than 14 days


$removeDate = (Get-Date).AddDays(-14)
Get-ComputerRestorePoint | 
 Where { $_.ConvertToDateTime($_.CreationTime) -lt  $removeDate } | 
 Delete-ComputerRestorePoints
```
## PARAMETERS

### -RestorePoint
Restore point(s) to be deleted (retrieved and optionally filtered from Get-ComputerRestorePoint

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS





