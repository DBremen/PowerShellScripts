# Get-Breaktimer

## SYNOPSIS
Function to display a break timer with a countdown based on absolute or relative times.

## Script file
Utils\Get-Breaktimer.ps1

## SYNTAX

### AbsoluteTime
```
Get-Breaktimer -StopTime <DateTime>
```

### RelativeTime
```
Get-Breaktimer -StopInMinutes <Decimal>
```

## DESCRIPTION
The break timer is implemented using Write-Progress.
Not sure if I found this idea somewhere else
or came up with it on my own.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
# Display the break timer for 30 Seconds


Get-BreakTimer -StopInMinutes .5
```
### -------------------------- EXAMPLE 2 --------------------------
```
# Display the break timer until a fixed endtime


Get-BreakTimer -StopTime (\[datetime\]"18:15")
```
## PARAMETERS

### -StopTime
Absolute time when the timer should stop.
Should be a recognizable DateTime.

```yaml
Type: DateTime
Parameter Sets: AbsoluteTime
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StopInMinutes
Relative time when the timer should stop in minutes.

```yaml
Type: Decimal
Parameter Sets: RelativeTime
Aliases: 

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS





