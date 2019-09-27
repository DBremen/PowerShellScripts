function Send-ErrorEmail($subject, $errMessage) {
	
    #prepare body message and signature
    $signature = Get-Content "$env:APPDATA\Microsoft\Signatures\Dirk.txt"
    $body = "Hi,`n`nThis is to notify you about an error in the script. You can check the event log 'PowerShell Scripts' on the script machine for more details"
    foreach ($item in $errMessage) { $body += "$item`n" }
    $body += "`n`n`nKind regards,"
    foreach ($item in $signature) { $body += "`n$item" }
    $olMailItem = 0 
    $olApp = new-object -comobject outlook.application 
    $NewMail = $olApp.CreateItem($olMailItem) 
    $NewMail.Body = $body
    $NewMail.Subject = $subject
    $NewMail.To = "michaela_langevin@symantec.com"
    $NewMail.CC = ""
    $null = $NewMail.Send() 
}



function Resolve-Error($ErrorRecord = $Error[0]) {
    $error_message = "`nErrorRecord:{0}ErrorRecord.InvocationInfo:{1}Exception:{2}"
    $formatted_errorRecord = $ErrorRecord | format-list * -force | out-string 
    $formatted_invocationInfo = $ErrorRecord.InvocationInfo | format-list * -force | out-string 
    $formatted_exception = ""
    $Exception = $ErrorRecord.Exception
    for ($i = 0; $Exception; $i++, ($Exception = $Exception.InnerException)) {
        $formatted_exception += ("$i" * 70) + "`n"
        $formatted_exception += $Exception | format-list * -force | out-string
        $formatted_exception += "`n"
    }
	
    return $error_message -f $formatted_errorRecord, $formatted_invocationInfo, $formatted_exception
}

function Write-Log ($scriptName, $entryType, $message, $id, [switch]$isError) {
    New-EventLog -LogName "PowerShell Scripts" -Source "$scriptName" -ErrorAction SilentlyContinue
    if ($isError) {
        Write-EventLog -LogName "PowerShell Scripts" -Source "$scriptName" -EntryType $entryType -Message $message -EventId 1111
        $Error.Clear()
    }
    else {
        Write-EventLog -LogName "PowerShell Scripts" -Source "$scriptName" -EntryType Information -Message $message -EventId $id

    }
}
#Write-Log testScript
#Get-EventLog -LogName "PowerShell Scripts"

function Write-ColoredOutput($message, [System.ConsoleColor]$foregroundColor, [System.ConsoleColor]$backgroundColor) {
    $currFGColor, $currBGColor = $Host.UI.RawUI.ForegroundColor, $Host.UI.RawUI.BackgroundColor
    $Host.UI.RawUI.ForegroundColor, $Host.UI.RawUI.BackgroundColor = $fgcolor, $bgColor
    Write-Output $message
    $Host.UI.RawUI.ForegroundColor, $Host.UI.RawUI.BackgroundColor = $currFGColor, $currBGColor
}


#Write-ColoredOutput "test" -fgColor Green -bgColor Red


#\MyScript.ps1 2>&1 | tee -filePath c:\results.txt


function New-ScriptLogger {
    New-Module -AsCustomObject -ScriptBlock {
         
        $rs = [RunSpaceFactory]::CreateRunspace()
        $rs.ApartmentState = "STA"
        $rs.ThreadOptions = "ReuseThread"
        $rs.Open()
        $script:ps = [powershell]::Create()
        $script:ps.Runspace = $rs
        $script:ar = $null
        $script:module = $ExecutionContext.SessionState.Module
         
        [scriptblock]
        $script:ErrorHandler = {
            param(
                [Management.Automation.ErrorRecord]
                $record
            )
            [diagnostics.debug]::writeline(
                "Error: " + $record.tostring());
        }
        [scriptblock]
        $script:WarningHandler = {
            param(
                [Management.Automation.WarningRecord]
                $record
            )       
            [diagnostics.debug]::writeline(
                "Warning: " + $record.message);
        }
        [scriptblock]
        $script:VerboseHandler = {
            param(
                [Management.Automation.VerboseRecord]
                $record
            )
            [diagnostics.debug]::writeline(
                "Verbose: " + $record.message);
        }
        [scriptblock]
        $script:DebugHandler = {
            param(
                [Management.Automation.DebugRecord]
                $record
            )
            [diagnostics.debug]::writeline(
                "Debug: " + $record.message);
        }
        [scriptblock]
        $script:ProgressHandler = {
            param(
                [Management.Automation.ProgressRecord]
                $record
            )       
            [diagnostics.debug]::writeline(
                "Progress: " + $record);
        }
		
		
        $script:Handlers = @{
            Error    = Register-ObjectEvent $ps.Streams.Error DataAdded -Action {
                & $event.MessageData { & $ErrorHandler @args } $event.sender[$eventargs.index]
            } -MessageData $module #-SupportEvent
             
            Warning  = Register-ObjectEvent $ps.Streams.Warning DataAdded -Action {
                & $event.MessageData { & $WarningHandler @args } $event.sender[$eventargs.index]
            } -MessageData $module #-SupportEvent 
             
            Verbose  = Register-ObjectEvent $ps.Streams.Verbose DataAdded -Action {
                & $event.MessageData { & $VerboseHandler @args } $event.sender[$eventargs.index]
            } -MessageData $module #-SupportEvent
             
            Debug    = Register-ObjectEvent $ps.Streams.Debug DataAdded -Action {
                & $event.MessageData { & $DebugHandler @args } $event.sender[$eventargs.index]
            } -MessageData $module #-SupportEvent
             
            Progress = Register-ObjectEvent $ps.Streams.Progress DataAdded -Action {
                & $event.MessageData { & $ProgressHandler @args } $event.sender[$eventargs.index]
            } -MessageData $module #-SupportEvent
        }
         
        function Invoke {
            param(
                [validatenotnullorempty()]
                [scriptblock]$script,
                $context
            )
             
            try {
                $ps.commands.clear()
                [scriptblock]$writeHost = {
                    function Write-Host($message, [System.ConsoleColor]$foregroundColor, [System.ConsoleColor]$backgroundColor) {
                        $currFGColor, $currBGColor = [console]::ForegroundColor, [console]::BackgroundColor
                        if ($foregroundColor) { [console]::ForegroundColor = $foregroundColor }
                        if ($backgroundColor) { [console]::BackgroundColor = $backgroundColor }
                        Write-Output $message
                        [console]::ForegroundColor, [console]::BackgroundColor = $currFGColor, $currBGColor
                    }
                }
                write-host -foreground green "Script is running with logging facility."
                $command = new-object management.automation.runspaces.command $writeHost, $true 
                $ps.commands.addcommand($command) > $null 
					
                $command = new-object management.automation.runspaces.command $script, $true 
                $ps.commands.addcommand($command) > $null            
                $result = $ps.BeginInvoke() # returns output               
             
            }
            catch {
            
                write-host -foreground red "Unhandled terminating error: $_"
                $record = new-object management.automation.errorrecord $(
                    new-object exception $_.tostring()), "TerminatingError", "NotSpecified", $null
                & $ErrorHandler $record
             
            }
            finally {
                $ps.EndInvoke($result)
                write-host -foreground green "Complete"
            }
        }
                 
        Export-ModuleMember -Function Invoke -Variable ErrorHandler, WarningHandler, VerboseHandler, DebugHandler, ProgressHandler
    }
}


function Start-Logging {
    <#
		.Synopsis
			Module to provide a logging functionality for scripts originally written by Oisin Grehan
			see link.
		.Description
			The module exports only one function Start-Logging. This function provides logging 
			functionality for script files
			Errors are written to the event log and are sent by email
			The logging can be implemented in any script by adding the following two lines at the beginning of the Main function:
			- ipmo "$script:scriptPath\get-stats\Helper\Logging.psm1" -Force
			- Start-Logging (Get-ScriptDirectory);exit (where Get-ScriptDirectory is a function that retrieves the directory the script is running in (see example))
			-the Start-Logging function will read the script (replacing the lines that call the logging) and create a scriptblock that runs asynchronously
			- providing the logging functionality where errors are logged to the "PowerShell Scripts" event log and send by email
		.PARAMETER ScriptPath
			The fullpath to the script to enable the logging for.
		.EXAMPLE
			function MyFunc{
				$script:scriptDir = Get-ScriptDirectory | Split-Path -Parent
				#setup the logging and exit. this will start the whole script in a new thread with logging facility
				#uncomment next two lines for debugging (without logging)
				Import-Module "$scriptDir\Helper\Logging.psm1" -Force
				Start-Logging (Get-ScriptDirectory);exit
				#actual code comes here
			}
			function Get-ScriptDirectory{
				$Invocation = (Get-Variable MyInvocation -Scope 1).Value
				$Invocation.ScriptName
			}
		.OUTPUTS
		- in case of error:
			- email with error details
			- event log entry
		.LINK
			http://web.archive.org/web/20110130052044/http://www.nivot.org/2009/08/19/PowerShell20AConfigurableAndFlexibleScriptLoggerModule.aspx
	#>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, Position = 0)]$scriptPath
    )
				
    $Error.Clear()
    $ht = @{
        ScriptName = Split-Path $scriptPath -Leaf;
        ScriptPath = $scriptPath;
        LogFile    = "c:\logs\$([IO.Path]::GetFileNameWithoutExtension((Split-Path $scriptPath -Leaf)))_$((get-date).ToString('MM-dd-yy(hh-mm)')).txt"
    }
    $context = New-Object -TypeName PSObject -Property $ht
    $logger = New-ScriptLogger
    # override handler
    $logger.ErrorHandler = {
        param($record)

        $message = "ErrorRecord.InvocationInfo:" + ($record.InvocationInfo | select MyCommand, Line, PositionMessage, InvocationName | fl | out-string)
        $output = "Error: $record`n" + $(foreach ($item in ($message.Trim().Split("`n"))) { "`t$item" }) 
        if ($context.LogFile) { $output + "`n" >> $context.LogFile }
		
        New-EventLog -LogName "PowerShell Scripts" -Source $context.ScriptName -ErrorAction SilentlyContinue
        Write-EventLog -LogName "PowerShell Scripts" -Source $context.ScriptName -EntryType Error -Message $output  -EventId 1111
		  
        write-host -ForegroundColor Red "Error: $record $($record.InvocationInfo | select -expandProperty PositionMessage)"
        $Error.Clear()
    }

    $logger.VerboseHandler = {
        param($record)
	   
        if ($context.LogFile) { "Verbose: " + $record.message + "`n" >> $context.LogFile }
        write-host  "Verbose: $record"
    }

    $logger.WarningHandler = {
        param($record)
	     
        if ($context.LogFile) { "Warning: " + $record.message + "`n" >> $context.LogFile }
        write-host -ForegroundColor Red "Warning: $record"
    }
	
    $logger.ProgressHandler = {
        param($record)
        Write-Progress -Activity $record.Activity -Status $record.StatusDescription -PercentComplete $record.PercentComplete `
            -CurrentOperation $record.CurrentOperation -ParentId $record.ParentActivityId -SecondsRemaining $record.SecondsRemaining
		
    }
    if (!(Test-Path (split-path $($context.Logfile) -Parent) )) {
        $null = New-Item -ItemType "Container" -Path (split-path $($context.Logfile) -Parent)
    }
    ("#" * 30 ) + " $($context.ScriptPath) " + " ($(Get-Date)) " + ("#" * 30 ) > $context.LogFile
    #invoke the script replacing the call for the logger in order to avoid that it calls itself
    $logger.Invoke(
        ([scriptblock]::Create($(gc "$scriptPath" -ReadCount 0 | Out-String).replace('ipmo "$script:scriptPath\get-stats\Helper\Logging.psm1" -Force', '').replace('Start-Logging (Get-ScriptDirectory);exit', ''))),
        $context
    ) | tee -variable output; @("StdOut:") + $output >> $context.LogFile

    if (-not (Select-String -Path $context.LogFile "Error:" -Quiet)) {
        Write-Log $context.ScriptName -Message "No Errors encountered" -id 1112
    }
    else {
        Send-ErrorEmail "Error with script '$($context.ScriptName)' - $((Get-Date).ToString('ddd-MMM-yy'))" (gc $context.LogFile)
        Write-Log $context.ScriptName -Message ($output | Out-String) -id 1110
    }
    del $context.LogFile -Force
    #Get-EventLog -LogName "PowerShell Scripts" -Source $context.ScriptName
    #Clear-EventLog -LogName "PowerShell Scripts" 
	
}

Export-ModuleMember -Function Start-Logging

