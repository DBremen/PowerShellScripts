filter Get-FileSize {
	"{0:N2} {1}" -f $(
	if ($_ -lt 1kb) { $_, 'Bytes' }
	elseif ($_ -lt 1mb) { ($_/1kb), 'KB' }
	elseif ($_ -lt 1gb) { ($_/1mb), 'MB' }
	elseif ($_ -lt 1tb) { ($_/1gb), 'GB' }
	elseif ($_ -lt 1pb) { ($_/1tb), 'TB' }
	else { ($_/1pb), 'PB' }
	)
}
function Get-FileWCSynchronous{
    param(
        [Parameter(Mandatory=$true)]
        $url, 
        $destinationFolder="$env:USERPROFILE\Downloads",
        [switch]$includeStats
    )
    $wc = New-Object Net.WebClient
    $wc.UseDefaultCredentials = $true
    $destination = Join-Path $destinationFolder ($url | Split-Path -Leaf)
    $start = Get-Date
    $wc.DownloadFile($url, $destination)
    $elapsed = ((Get-Date) - $start).ToString('hh\:mm\:ss')
    $totalSize = (Get-Item $destination).Length | Get-FileSize
    if ($includeStats.IsPresent){
        [PSCustomObject]@{Name=$MyInvocation.MyCommand;TotalSize=$totalSize;Time=$elapsed}
    }
    Get-Item $destination | Unblock-File
}

#https://msdn.microsoft.com/en-us/library/ms127882%28v=vs.110%29.aspx
function Get-FileVB{
    param(
        [Parameter(Mandatory=$true)]
        $url, 
        $destinationFolder="$env:USERPROFILE\Downloads", 
        [switch]$includeStats

    )
    Add-Type -AssemblyName Microsoft.VisualBasic
    #resolve potential redirect
    $response = [System.Net.WebRequest]::Create($url).GetResponse()
    $url = $response.ResponseUri.OriginalString
    $response.Close()
    $destination = Join-Path $destinationFolder ($url | Split-Path -Leaf)
    $net = New-Object Microsoft.VisualBasic.Devices.Network
    $start = Get-Date
    #signature DownloadFile(url, destination, username, password, [bool]showUI, [int]connecdtionTimeOutInMS,[Microsoft.VisualBasic.FileIO.UICancelOption]OnUserCancel)
    $net.DownloadFile($url, $destination, '', '', $true, 500, [Microsoft.VisualBasic.FileIO.UICancelOption]::DoNothing )
    $elapsed = ((Get-Date) - $start).ToString('hh\:mm\:ss')
    $totalSize = (Get-Item $destination).Length | Get-FileSize
    if ($includeStats.IsPresent){
        [PSCustomObject]@{Name=$MyInvocation.MyCommand;TotalSize=$totalSize;Time=$elapsed}
    }
    Get-Item $destination | Unblock-File
}

function Get-FileInvokeWebRequest{
    param(
        [Parameter(Mandatory=$true)]
        $url, 
        $destinationFolder="$env:USERPROFILE\Downloads", 
        [switch]$includeStats
    )
    $destination = Join-Path $destinationFolder ($url | Split-Path -Leaf)
    $start = Get-Date
    Invoke-WebRequest $url -OutFile $destination
    $elapsed = ((Get-Date) - $start).ToString('hh\:mm\:ss')
    $totalSize = (Get-Item $destination).Length | Get-FileSize
    if ($includeStats.IsPresent){
        [PSCustomObject]@{Name=$MyInvocation.MyCommand;TotalSize=$totalSize;Time=$elapsed}
    }
    Get-Item $destination | Unblock-File
}


#BITS or Background Intelligent Transfer service is basically a windows service that is used to transfer files
#Get-BitsTransfer -AllUsers | Select -ExpandProperty FileList
function Get-FileBitsTransferSynchronous{
    param(
        [Parameter(Mandatory=$true)]
        $url, 
        $destinationFolder="$env:USERPROFILE\Downloads"
    )
    Import-Module BitsTransfer
    $destination = Join-Path $destinationFolder ($url | Split-Path -Leaf)
    $start = Get-Date
    Start-BitsTransfer -Source $url -Destination $destination
    $elapsed = ((Get-Date) - $start).ToString('hh\:mm\:ss')
    $totalSize = (Get-Item $destination).Length | Get-FileSize
    if ($includeStats.IsPresent){
        [PSCustomObject]@{Name=$MyInvocation.MyCommand;TotalSize=$totalSize;Time=$elapsed}
    }
    Get-Item $destination | Unblock-File
}

function Get-FileWCAsynchronous{
    [CmdletBinding()]
    [Alias('download')]
    param(
        [Parameter(Mandatory=$true)]
        $url, 
        $destinationFolder="$env:USERPROFILE\Desktop", 
        [switch]$includeStats
    )
    $wc = New-Object Net.WebClient
    $wc.UseDefaultCredentials = $true
    $file = $url | Split-Path -Leaf
    $destination = Join-Path $destinationFolder $file
    $start = Get-Date 
    $null = Register-ObjectEvent -InputObject $wc -EventName DownloadProgressChanged `
        -MessageData @{start=$start;includeStats=$includeStats} `
        -SourceIdentifier WebClient.DownloadProgressChanged -Action { 
            filter Get-FileSize {
	            "{0:N2} {1}" -f $(
	            if ($_ -lt 1kb) { $_, 'Bytes' }
	            elseif ($_ -lt 1mb) { ($_/1kb), 'KB' }
	            elseif ($_ -lt 1gb) { ($_/1mb), 'MB' }
	            elseif ($_ -lt 1tb) { ($_/1gb), 'GB' }
	            elseif ($_ -lt 1pb) { ($_/1tb), 'TB' }
	            else { ($_/1pb), 'PB' }
	            )
            }
            $elapsed = ((Get-Date) - $event.MessageData.start)
            #calculate average speed in Mbps
            $averageSpeed = ($EventArgs.BytesReceived * 8 / 1MB) / $elapsed.TotalSeconds
            $elapsed = $elapsed.ToString('hh\:mm\:ss')
            #calculate remaining time considering average speed
            $remainingSeconds = ($EventArgs.TotalBytesToReceive - $EventArgs.BytesReceived) * 8 / 1MB / $averageSpeed
            $receivedSize = $EventArgs.BytesReceived | Get-FileSize
            $totalSize = $EventArgs.TotalBytesToReceive | Get-FileSize        
            Write-Progress -Activity (" $url {0:N2} Mbps" -f $averageSpeed) `
                -Status ("{0} of {1} ({2}% in {3})" -f $receivedSize,$totalSize,$EventArgs.ProgressPercentage,$elapsed) `
                -SecondsRemaining $remainingSeconds `
                -PercentComplete $EventArgs.ProgressPercentage
            if ($EventArgs.ProgressPercentage -eq 100){
                 Write-Progress -Activity (" $url {0:N2} Mbps" -f $averageSpeed) `
                -Status 'Done' -Completed
                if ($event.MessageData.includeStats.IsPresent){
                    ([PSCustomObject]@{Name=$MyInvocation.MyCommand;TotalSize=$totalSize;Time=$elapsed}) | Out-Host
                }
            }
        }    
    $null = Register-ObjectEvent -InputObject $wc -EventName DownloadFileCompleted `
         -SourceIdentifier WebClient.DownloadFileCompleted -Action { 
            Unregister-Event -SourceIdentifier WebClient.DownloadProgressChanged
            Unregister-Event -SourceIdentifier WebClient.DownloadFileCompleted
            Get-Item $destination | Unblock-File
        }  
    try  {  
        $wc.DownloadFileAsync($url, $destination)  
    }  
    catch [System.Net.WebException]  {  
        Write-Warning "Download of $url failed"  
    }   
    finally  {    
        $wc.Dispose()  
    }  
 }

 function Get-FileBitsTransferAsynchronous{
    param(
        [Parameter(Mandatory=$true)]
        $url, 
        $destinationFolder="$env:USERPROFILE\Downloads",
        [switch]$includeStats
    )
    $start = Get-Date
    $job = Start-BitsTransfer -Source $url -Destination $destinationFolder -DisplayName 'Download' -Asynchronous 
    $destination = Join-Path $destinationFolder ($url | Split-Path -Leaf)

    while (($job.JobState -eq 'Transferring') -or ($job.JobState -eq 'Connecting')){ 
         filter Get-FileSize {
	        "{0:N2} {1}" -f $(
	        if ($_ -lt 1kb) { $_, 'Bytes' }
	        elseif ($_ -lt 1mb) { ($_/1kb), 'KB' }
	        elseif ($_ -lt 1gb) { ($_/1mb), 'MB' }
	        elseif ($_ -lt 1tb) { ($_/1gb), 'GB' }
	        elseif ($_ -lt 1pb) { ($_/1tb), 'TB' }
	        else { ($_/1pb), 'PB' }
	        )
        }
        $elapsed = ((Get-Date) - $start)
        #calculate average speed in Mbps
        $averageSpeed = ($job.BytesTransferred * 8 / 1MB) / $elapsed.TotalSeconds
        $elapsed = $elapsed.ToString('hh\:mm\:ss')
        #calculate remaining time considering average speed
        $remainingSeconds = ($job.BytesTotal - $job.BytesTransferred) * 8 / 1MB / $averageSpeed
        $receivedSize = $job.BytesTransferred | Get-FileSize
        $totalSize = $job.BytesTotal | Get-FileSize 
        $progressPercentage = [int]($job.BytesTransferred / $job.BytesTotal * 100) 
        if ($remainingSeconds -as [int]){     
            Write-Progress -Activity (" $url {0:N2} Mbps" -f $averageSpeed) `
                -Status ("{0} of {1} ({2}% in {3})" -f $receivedSize, $totalSize, $progressPercentage, $elapsed) `
                -SecondsRemaining $remainingSeconds `
                -PercentComplete $progressPercentage
        }
    } 
    if ($includeStats.IsPresent){
        ([PSCustomObject]@{Name=$MyInvocation.MyCommand;TotalSize=$totalSize;Time=$elapsed}) | Out-Host
    }
    
    Write-Progress -Activity (" $url {0:N2} Mbps" -f $averageSpeed) `
        -Status 'Done' -Completed
    Switch($job.JobState){
	    'Transferred' {
                        Complete-BitsTransfer -BitsJob $job
                        Get-Item $destination | Unblock-File
                      }
	    'Error'       {
                        Write-Warning "Download of $url failed" 
                        $job | Format-List
                      } 
    }
}

#$url = 'http://speedtest.reliableservers.com/10MBtest.bin'
#Get-FileWCSynchronous $url 
#Get-FileVB $url
#Get-FileBitsTransferSynchronous $url
#Get-FileWCAsynchronous $url -includeStats
#Get-FileBitsTransferAsynchronous $url -includeStats


Export-ModuleMember -Function 'Get-FileWCSynchronous','Get-FileVB','Get-FileInvokeWebRequest','Get-FileBitsTransferSynchronous','Get-FileWCAsynchronous','Get-FileBitsTransferAsynchronous'