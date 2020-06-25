function Get-OutlookSentItems {
<#
    .SYNOPSIS
        Get emails in "Sent Items"
        
    .DESCRIPTION
	    The function retrieves emails or the count of emails in the Outlook "Sent Items" folder via COM object.
        To workaround a problem when Outlook and PowerShell are running as Admin it uses another custom function 
        Start-ProcessUnelvated (can be found in this Module) to open another unelevated PowerShell prompt if Outlook 
        is currently running and the current PowerShell session is elevated.
		
    .PARAMETER LastXDays
        The last x days (betwenn 1-30) the Sent Emails should be retrieved for. By default the last five days are retrieved.

    .PARAMETER Group
        Switch parameter. If used only the count of emails per day is returned instead of the individual items.
        
    .EXAMPLE  
        #Get all sent emails for the last 5 days
        Get-OutlookSentItems

    .EXAMPLE  
        #Get the count of emails per day for the last 7 days
        Get-OutlookSentItems -LastXDays 7 -Group

#>
    [CmdletBinding()]
	param(
        [ValidateRange(1,30)]
        [int]$LastXDays = 5,
        [Switch]$Group
    )
    $scriptDir = $PSScriptRoot
    $scriptDir = Split-Path $scriptDir -Parent
    $admin = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")
    $runningOutlook = Get-Process outlook -ErrorAction SilentlyContinue
    if ($admin -and $runningOutlook) {
        $poshArgs = "Get-OutlookSentItems -Group:`$" + $Group + " -LastXDays `$" + $LastXDays
        Start-ProcessUnelevated powershell ("-noexit -nop -command Import-Module $scriptDir -DisableNameChecking;" + $poshArgs)
    }
    else {
        $null = Add-type -assembly 'Microsoft.Office.Interop.Outlook'
        $olFolders = 'Microsoft.Office.Interop.Outlook.olDefaultFolders' -as [type]
        $outlook = new-object -comobject outlook.application
        $namespace = $outlook.GetNameSpace('MAPI')
        $folder = $namespace.getDefaultFolder($olFolders::olFolderSentMail)
        $filter = "[ReceivedTime] > '{0:MM/dd/yyyy hh:mm tt}'" -f (Get-Date).AddDays(-5)
        $emails = $folder.items.Restrict($filter) | Select-Object -Property Subject, SentOn, To
        if ($Group) {
            $emails = $emails | Group-Object { $_.SentOn.Date }
        }
        $emails
        if (!$runningOutlook){
            Stop-Process -Name Outlook
        }
    }
}

