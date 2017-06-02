#helper function
function Browse-ForFolder($message){
	$shApp = New-Object -comObject Shell.Application
	$folder = $shApp.BrowseForFolder(0,$message,0,0)
	if ($folder -ne $null){ return $folder.self.path }
}

function Migrate-ScheduledTask{
     <#    
        .SYNOPSIS
            Script to migrate scheduled tasks from Windows XP/Server 2003 to Windows 7/Server 2008 task scheduler
        .DESCRIPTION
            Script to migrate scheduled tasks from Windows XP/Server 2003 to Windows 7/Server 2008 task scheduler
            provides an alternative,if running schtasks /query /s from the Win 7 machine connecting to the XP machine remotely 
            is not an option (http://www.simonhampel.com/how-to-convert-scheduled-tasks-from-windows-xp-to-windows-7/)
            Usage:
            1. Run the script from the XP machine (in order to export the .job files, the schtasks commandline and the script itself)
            2. Run the script from the Windows 7 machine in order to copy the .job files, and run the XP schtasks command in order to "register" the files on the 7 machine.
	    .EXAMPLE
            #1. Run the script from the XP machine (in order to export the .job files, the schtasks commandline and the script itself)
		    Migrate-ScheduledTask
            #2. Run the script from the Windows 7 machine in order to copy the .job files, and run the XP schtasks command in order to "register" the files on the 7 machine.
            Migrate-ScheduledTask
        .Link
            http://www.digitalforensics.be/blog/?p=205
    #>
    [CmdletBinding()]
    Param()
    $isXP=(gwmi Win32_OperatingSystem).Version.StartsWith("5")

    if ($isXP){  
	    $folder=Browse-ForFolder "Select the destination folder for the backup"
	    if ($folder -ne $null){
		    #copy all the .jobs files,the xp schtasks commandline and the script itself
		    copy "$env:SystemRoot\Tasks\*" -filter "*.job" -recurse -dest $folder
		    copy "$env:SystemRoot\system32\schtasks.exe" -Destination $folder
		    copy "$env:SystemRoot\system32\schedsvc.dll" -Destination $folder
		    copy $MyInvocation.MyCommand.Path.ToString() -Destination $folder
	    }
	    exit
    }
    #on windows 7 machine
    else{
	    $folder=Browse-ForFolder "Select the source folder of the backup"
	    if ($folder -ne $null){
		    #copy all the .jobs files to the c:\windows\task folder on the destination machine
		    copy "$folder\*" -filter "*.job" -recurse -dest "$env:SystemRoot\Tasks"
		    $credential = Get-Credential
		    $pw=[Runtime.InteropServices.Marshal]::PtrToStringAuto(`
			    [Runtime.InteropServices.Marshal]::SecureStringToBSTR($credential.Password))
		    $user=$credential.Username
		    # if non-domain credentials skip the backslash
		    if ($user.StartsWith("\")){
			    $user=$credential.Username.Substring(1)
		    }
		    $tasks=gci $folder -Filter "*.job"
		    foreach ($task in $tasks){
			    #run the xp schtasks command in order to register the tasks on the windows 7 machine
			    #skip .job postfix and add quotation-marks
			    $taskName="'" + $task.Name.substring(0,$task.Name.Length-4) + "'" 
			    $allArgs = @("/change", "/TN", "$taskName","/RU" , "$user" , "/RP" ,"$pw" )
			    & "$folder\schtasks.exe" $allArgs 
		    }
	    }
    }
}
