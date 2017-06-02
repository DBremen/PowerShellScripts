function Open-Registry{
    <#    
        .SYNOPSIS
            Open the regedit at the specified path similar to sysinternals regjump.
        .DESCRIPTION
           Opens regedit at the specified path accepts multiple paths provided as argument or from the clipboard (if no argument provided).
           Registry paths can contain leading abbreviated hive names (e.g. HKLM, HKCU) or PowerShell paths (e.g. HKLM:\). 
           If the path does not represent an existing key withn the registry the path is shortened one level until
           a valid path is found (warning is displayed if no part of the path is found).
        .PARAMETER regKey
            A string or a string array representing one or more registry paths. The paths can contain leading abbreviated hive names like HKLM:, HKLM:\, HKCU:...
        .EXAMPLE
            #the example opens multiple instances of regedit with at the specified paths via an argument to the regKey paramater
            $testKeys =@'
HKLM\Software\Microsoft\Outlook Express
HKLM\Software\Microsoft\PowerShell
HKLM\Software\Microsoft\Windows
'@ -split "`r`n"
            Open-Registry $testKeys
        .EXAMPLE
            #the example demonstrates the use case if the keys are in the clipboard
            @'
HKLM\Software\Microsoft\Outlook Express
HKLM\Software\Microsoft\PowerShell
HKLM\Software\Microsoft\Windows
'@ -split "`r`n" | clip
            Open-Registry
        .EXAMPLE
            #the example will open regedit with the run key open as the last part of the path does not represent a key
            Open-Registry HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\skype
        .EXAMPLE
            #the example provides an invalid path to the function (using the alias) resulting in a warning message and no instance of regedit opening
            regJump HKLMm\xxxxx
        .LINK
    #>
	[CmdletBinding()]
    [Alias("regJump")]
	param(
    [Parameter(Position=0)]
    $regKey
    )
    #check for clipbaord only if no argument provided
    if (!$regKey){
        #split the clipboard content by crlf and get of trailing crlf in case clipboard populated via piping it to clip.exe
		$cmd = {
			Add-Type -Assembly PresentationCore
			[Windows.Clipboard]::GetText() -split "`r`n" | where {$_}
		}
        #in case its run from the powershell commandline
	    if([Threading.Thread]::CurrentThread.GetApartmentState() -eq 'MTA') {
		    $regKey = & powershell -STA -Command $cmd
	    } 
        else {
		    $regKey = & $cmd
	    }
    }
    foreach ($key in $regKey){
        $replacers = @{
            'HKCU:?\\'='HKEY_CURRENT_USER\'
            'HKLM:?\\'='HKEY_LOCAL_MACHINE\'
            'HKU:?\\'='HKEY_USERS\'
            'HKCC:?\\'='HKEY_CURRENT_CONFIG\'
            'HKCR:?\\'='HKEY_CLASSES_ROOT\'
        }
        #replace hive shortnames with or without PowerShell Syntax + remove trailing backslash
        $properKey = $key
	    $replacers.GetEnumerator() | foreach {
		    $properKey = $properKey.ToUpper() -replace $_.Key, $_.Value -replace '\\$'
	    }
        #check if the path points to an existing key or its parent is an existing value 
        #add one level since we don't want the first iteration of the loop to remove a level
        $path = "$properKey\dummyFolder"
        #test the registry path and revert to parent path until valid path is found otherwise return $false
        while(Split-Path $path -OutVariable path){
            $providerPath = $providerPath = "Registry::$path"
            if (Test-Path $providerPath){
               break
            }
        }
        if ($path){
	        Set-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\Applets\Regedit\ -Name LastKey -Value $path -Force
            #start regedit using m switch to allow for multiple instances
            $regeditInstance = [Diagnostics.Process]::Start("regedit","-m")
            #wait the regedit window to appear
            while ($regeditInstance.MainWindowHandle -eq 0){
                sleep -Milliseconds 100
            }
        }
        else{
            Write-Warning "Neither ""$key"" nor any of its parents does exist"
        }
    }
}

 