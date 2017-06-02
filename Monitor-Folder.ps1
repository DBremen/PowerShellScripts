function Monitor-Folder{
     <#
    .SYNOPSIS
        Monitors a folder for changes using non-persistent asynchronous events
    .DESCRIPTION
        A wrapper around IO.FileSystemWatcher and Register-ObjectEvent to monitor a folder for file system events (Created, Deleted, Changed, and/or Renamed)
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
    .PARAMETER Recurse
        Switch if specified will include monitoring subdirectories of the folder 
    .PARAMETER DefaultOutput
        Switch if specified will assign action scriptblocks to the event(s) that output "The file '$name' was $changeType at $time" and "The file '$oldName' was $changeType to '$name' at $time" (for Renamed events)
    .EXAMPLE
        $events = Monitor-Folder "$env:USERNAME\Desktop\test" -EventName All -DefaultOutput
        #Will start monitoring the folder for all events outputting the default output as action
        $events.Dispose()
        #stop monitoring the folder
    .EXAMPLE
        $events = Monitor-Folder "$env:USERNAME\Desktop\test -EventName Deleted -Action {write-host "$fullName was deleted at $time";[console]::beep(500,500)}
        #Will start monitoring the folder for file deletion and invoke the custom action using the default variables
    #>
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, Position=0)]
        [ValidateScript({
            if (-not (Test-Path $_ -PathType Container)) {
                throw “Path ‘${_}’ does not exist. Please provide the path to a an existing folder.”
            }
            $true
        })]
        $Folder,

        [Parameter(Position=1)]
        [ValidateSet('All','Changed', 'Created', 'Deleted', 'Renamed')]
        [String[]]
        $EventName = 'All',

        $Filter="*",

        [string]$EventIdentifierPrefix=(Get-Random),

        [scriptblock]$Action,

        [switch]$Recurse,

        [switch]$DefaultOutput
    ) 
    if (!$DefaultOutput -and !$Action) {   
        throw "Please provide a scriptblock for the action parameter or use the 'defaultOutput' switch for the default output"
    }               
    $fsw = New-Object IO.FileSystemWatcher $Folder, $Filter -Property @{
    IncludeSubdirectories = $Recurse
    NotifyFilter = [IO.NotifyFilters]'FileName, LastWrite'
    } 

    $defaultAction = { 
        $name = $eventArgs.Name
        $fullName = $eventArgs.FullPath
        $changeType = $eventArgs.ChangeType
        $time = $event.TimeGenerated
    }
    $renameAction = { 
        $name = $eventArgs.Name
        $fullName = $eventArgs.FullPath
        $oldName = $eventArgs.OldName
        $oldFullName = $eventArgs.OldFullName
        $changeType = $eventArgs.ChangeType
        $time = $event.TimeGenerated
    }
    if ($DefaultOutput){
        $defaultAction = [scriptblock]::Create($defaultAction.ToString()  + ';' + 'Write-Host "The file ''$name'' was $changeType at $time"')
        $renameAction = [scriptblock]::Create($renameAction.ToString()  + ';' + 'Write-Host "The file ''$oldName'' was $changeType to ''$name'' at $time"')
    }
    if ($Action){
        $defaultAction = [scriptblock]::Create($defaultAction.ToString()  + "`n" + $Action.ToString())
        $renameAction = [scriptblock]::Create($renameAction.ToString() + "`n" + $Action.ToString())
    }
    
    if ($EventName -eq 'All') { $EventName = 'Changed', 'Created', 'Deleted', 'Renamed' }
    foreach ($event in $EventName){
        if ($event -eq 'Renamed'){
             Register-ObjectEvent $fsw $event -SourceIdentifier ($EventIdentifierPrefix + "_" + $event) -Action $renameAction
        }
        else{
            Register-ObjectEvent $fsw $event -SourceIdentifier ($EventIdentifierPrefix + "_" + $event) -Action $defaultAction
        }
    }
}

