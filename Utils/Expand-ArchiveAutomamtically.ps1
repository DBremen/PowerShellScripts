function Expand-ArchiveAutomamtically {
    #Requires –Modules ThreadJob
    <#
    .SYNOPSIS
        Monitor a downlaod folder and automatically smart expand any new .zip files created in this folder. Requires Monitor-Folder functoin from this module (PowerShellScripts module (https://github.com/DBremen/PowerShellScripts))
        and the ThreadJob module which can be installed via Install-Module ThreadJob.
    .DESCRIPTION
        The script uses a file system watcher to monitor a specified folder for .zip files and expands them (in a separate folder if the .zip file's content is not contained in a folder).
        The whole monitoring happens in a background thread using the ThreadJob module.
    .PARAMETER DownloadFolder
        The Name of the folder to monitor. Defaults to user's Desktop folder.
    .PARAMETER Keep
        Switch parameter, if specified the downloaded .zip file are not removed after the extraction of its content.
    .EXAMPLE
        # start expanding .zip files automatically within the user's Desktop folder while removing the original zip files
        $job = Expand-ArchiveAutomamtically
        # stop and remove the job if desired
		$job | stop-job | remove-job
    #>
    [CmdletBinding()]
    Param
    (
        $DownloadFolder = "$env:USERPROFILE\Desktop\",
        [switch]$Keep
    )
    $job = {
        $action = {
            try {
                Add-Type -Assembly 'System.IO.Compression.FileSystem'
                Unblock-File $fullName
                #check if the .zip content is in a  folder with the same name
                $fileName = [IO.Path]::GetFileNameWithoutExtension((Split-Path $fullName -Leaf))
                $parentFolder = Split-Path $fullName
                $folderPath = Join-Path $parentFolder $fileName
                #Firefox will trigger two create events of which the first will fail here
                $hasFolder = ([IO.Compression.ZipFile]::OpenRead($fullname).Entries.where{ $_.FullName -eq "$fileName/" }).Count -eq 1
                $destFolder = Split-Path $fullName
                if ((-not $hasFolder) -or (Test-Path $folderPath)) {
                    $postFix = 0
                    while (Test-Path $folderPath) {
                        $folderPath = (Join-Path $parentFolder $fileName) + $postFix
                        $postFix++
                    }
                    $destFolder = New-Item -ItemType Directory -Path $folderPath
                }
                Expand-Archive $fullName $destFolder
                #see https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_thread_jobs?view=powershell-7.1
                if (-not $using:Keep) {
                    Remove-Item $fullName
                }
            }
            catch {}
        }
        $monitor = Monitor-Folder $using:DownloadFolder -EventName Created, Renamed  -Filter *.zip -Action $action -NotifyFilter 'FileName, Size'
        do {
            Wait-Event -Timeout 1
        } while ($true)
    }
    $scriptBlock = [ScriptBlock]::Create('function Monitor-Folder{' + (Get-Command Monitor-Folder).Definition + '}' + $job.ToString())
    return Start-ThreadJob -ScriptBlock $scriptblock
}

#get-job -id 19  | stop-job | remove-job