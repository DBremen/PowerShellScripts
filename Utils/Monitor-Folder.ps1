function Monitor-Folder {
    <#
    .SYNOPSIS
        Monitors a folder for changes using non-persistent asynchronous events
    .DESCRIPTION
        A wrapper around IO.FileSystemWatcher and Register-ObjectEvent to monitor a folder for file system events (Created, Deleted, Changed, and/or Renamed).
        The function returns a custom object with a Watcher and an Events property which can be used to dispose of the events and the filesystemwatcher.
    .PARAMETER Folder
        The Name of the folder to monitor
    .PARAMETER EventName
        An event or list of events to watch out for possible values are Created, Deleted, Changed, and/or Renamed or All to watch for all events.Default = 'All'
    .PARAMETER Filter
        (Optional) The filter for the files within the folder to monitor. Default = '*'
    .PARAMETER EventIdentifierPrefix
        (Optional) A prefix to identify the events that are created. The eventIdentifier is name is "$EventName_$EventIdentifierPrefix". Default = (Get-Random)
    .PARAMETER Action
        (Optional in case DefaultOutput is specified) The scriptblock to invoke when the event is triggered. Default variables within the scriptblock are ($fullName, $name, $time, $changeType and for Renamed $oldFullName, $oldName)
    .PARAMETER NotifyFilter
		(Optional) specifiy a notifiy filter for the file system watcher of type [IO.NotifyFilters]. Defaults to 'FileName, LastWrite'.
	.PARAMETER Recurse
        Switch if specified will include monitoring subdirectories of the folder
    .PARAMETER DefaultOutput
        Switch if specified will assign action scriptblocks to the event(s) that output "The file '$name' was $changeType at $time" and "The file '$oldName' was $changeType to '$name' at $time" (for Renamed events)
    .EXAMPLE
        $monitor = Monitor-Folder "$env:USERPROFILE\Desktop\test" -EventName All -DefaultOutput
        #Will start monitoring the folder for all events outputting the default output as action

        #stop monitoring the folder
        $monitor.Watcher.EnableRaisingEvents = $false
        $monitor.Events | ForEach-Object {
            Unregister-Event -SourceIdentifier $_.Name
        }
        $monitor.Events| Remove-Job
        $monitor.Watcher.Dispose()
    .EXAMPLE
        $monitor = Monitor-Folder "$env:USERPROFILE\Desktop\test\Desktop\test" -EventName Deleted -Action {write-host "$fullName was deleted at $time";[console]::beep(500,500)}
        #Will start monitoring the folder for file deletion and invoke the custom action using the default variables

        #stop monitoring the folder
        $monitor.Watcher.EnableRaisingEvents = $false
        $monitor.Events | ForEach-Object {
            Unregister-Event -SourceIdentifier $_.Name
        }
        $monitor.Events| Remove-Job
        $monitor.Watcher.Dispose()
    #>
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0)]
        [ValidateScript( {
                if (-not (Test-Path $_ -PathType Container)) {
                    throw throw "Path '$_' does not exist. Please provide the path to a an existing folder."
                }
                $true
            })]
        $Folder,

        [Parameter(Position = 1)]
        [ValidateSet('All', 'Changed', 'Created', 'Deleted', 'Renamed')]
        [String[]]
        $EventName = 'All',

        $Filter = "*",

        [string]$EventIdentifierPrefix = (Get-Random),

        [scriptblock]$Action,
		
		[IO.NotifyFilters]$NotifyFilter =  'FileName, LastWrite',

        [switch]$Recurse,

        [switch]$DefaultOutput
    )
    if (!$DefaultOutput -and !$Action) {
        throw "Please provide a scriptblock for the action parameter or use the 'defaultOutput' switch for the default output"
    }
    $fsw = New-Object IO.FileSystemWatcher $Folder, $Filter -Property @{
        IncludeSubdirectories = $Recurse
        NotifyFilter          = $NotifyFilter
    }
    $defaultAction = {
        $name = $event.SourceEventArgs.Name
        $fullName = $event.SourceEventArgs.FullPath
        $changeType = $event.SourceEventArgs.ChangeType
        $time = $event.TimeGenerated
    }
    $renameAction = {
        $name = $event.SourceEventArgs.Name
        $fullName = $event.SourceEventArgs.FullPath
        $oldName = $event.SourceEventArgs.OldName
        $oldFullName = $event.SourceEventArgs.OldFullName
        $changeType = $event.SourceEventArgs.ChangeType
        $time = $event.TimeGenerated
    }
    if ($DefaultOutput) {
        $defaultAction = [scriptblock]::Create($defaultAction.ToString() + ';' + 'Write-Host "The file ''$name'' was $changeType at $time"')
        $renameAction = [scriptblock]::Create($renameAction.ToString() + ';' + 'Write-Host "The file ''$oldName'' was $changeType to ''$name'' at $time"')
    }
    if ($Action) {
        $defaultAction = [scriptblock]::Create($defaultAction.ToString() + "`n" + $Action.ToString())
        $renameAction = [scriptblock]::Create($renameAction.ToString() + "`n" + $Action.ToString())
    }

    if ($EventName -eq 'All') { $EventName = 'Changed', 'Created', 'Deleted', 'Renamed' }

    $eventHandlers = foreach ($evt in $EventName) {
        if ($evt -eq 'Renamed') {
            Register-ObjectEvent $fsw $evt -SourceIdentifier ($EventIdentifierPrefix + "_" + $evt) -Action $renameAction
        }
        else {
            Register-ObjectEvent $fsw $evt -SourceIdentifier ($EventIdentifierPrefix + "_" + $evt) -Action $defaultAction
        }
    }
    $fsw.EnableRaisingEvents = $true
    [PSCustomObject][ordered]@{
        Watcher = $fsw
        Events  = $eventHandlers
    }
}