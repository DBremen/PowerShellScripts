# Monitor-Folder

## SYNOPSIS
Monitors a folder for changes using non-persistent asynchronous events Monitor-Folder.ps1

## Script file
Monitor-Folder.ps1

## SYNTAX

```
Monitor-Folder [-Folder] <Object> [[-EventName] <String[]>] [-Filter <Object>]
 [-EventIdentifierPrefix <String>] [-Action <ScriptBlock>] [-Recurse] [-DefaultOutput]
```

## DESCRIPTION
A wrapper around IO.FileSystemWatcher and Register-ObjectEvent to monitor a folder for file system events (Created, Deleted, Changed, and/or Renamed)

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$events = Monitor-Folder "$env:USERNAME\Desktop\test" -EventName All -DefaultOutput
```

#Will start monitoring the folder for all events outputting the default output as action
$events.Dispose()
#stop monitoring the folder

### -------------------------- EXAMPLE 2 --------------------------
```
$events = Monitor-Folder "$env:USERNAME\Desktop\test -EventName Deleted -Action {write-host "$fullName was deleted at $time";[console]::beep(500,500)}
```

#Will start monitoring the folder for file deletion and invoke the custom action using the default variables

## PARAMETERS

### -Folder
The Name of the folder to monitor

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

### -EventName
An event or list of events to watch out for possible values are Created, Deleted, Changed, and/or Renamed or All to watch for all events.Default = 'All'

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: 

Required: False
Position: 2
Default value: All
Accept pipeline input: False
Accept wildcard characters: False
```

### -Filter
(Optional) The filter for the files within the folder to monitor.
Default = '*'

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### -EventIdentifierPrefix
(Optional) A prefix to identify the events that are created.
The eventIdentifier is name is "$EventName_$EventIdentifierPrefix".
Default = (Get-Random)

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: (Get-Random)
Accept pipeline input: False
Accept wildcard characters: False
```

### -Action
(Optional in case DefaultOutput is specified) The scriptblock to invoke when the event is triggered.
Default variables within the scriptblock are ($fullName, $name, $time, $changeType and for Renamed $oldFullName, $oldName)

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Recurse
Switch if specified will include monitoring subdirectories of the folder

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

### -DefaultOutput
Switch if specified will assign action scriptblocks to the event(s) that output "The file '$name' was $changeType at $time" and "The file '$oldName' was $changeType to '$name' at $time" (for Renamed events)

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

