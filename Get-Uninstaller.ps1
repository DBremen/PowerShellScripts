function Get-Uninstaller {
     <#    
        .SYNOPSIS
            Function to get the uninstaller for installed software via registry (PowerShell v4 and <) or Get-Package)
        .DESCRIPTION
            I have encountered several installer related issues on my machine. Most of them seemed to be caused by insufficient privileges.
            This kind of issue can be usually fixed by running the installer “As Administrator”. 
            In case the issue is in relation to an already installed software packet, 
            it’s sometimes not so easy to locate the respective uninstaller/MSI packet, though. For that purpose, 
	    .PARAMETER Name
		   Search for software by name including wildcards. Defaults to ‘*’
	    .PARAMETER Hive
		    Only the be used for PowerShell v4 or lower. Search through user specific (HKCU) and/or machine specific 
            (HKLM) registry hives (parameter Hive defaults to HKLM, HKCU only accepts a combination of ‘HKCU’ and/or ‘HKLM’)
	    .EXAMPLE
           #Powershell v4 and lower
		   #search for the chrome uinstaller only in the machine wide registry hive
           Get-Uninstaller *chrome* -Hive HKLM
           #v5 and higher
           Get-Uninstaller *chrome*
        .LINK
            https://powershellone.wordpress.com/2016/02/13/retrieve-uninstallstrings-to-fix-installer-issues/

    #>
	[CmdletBinding()]
    Param(
    	$Name = '*',
        [ValidateSet('HKLM', 'HKCU')]
        [string[]]$Hive = @('HKLM','HKCU')
    )
    if ($PSVersionTable.PSVersion.Major -eq 5){
        Get-Package | Where-Object {$_.Name -like "$Name"} | ForEach-Object{
            $attributes = $_.meta.attributes
            $htProps = [Ordered]@{msiGUID=''}
            for ($i=0;$i -lt $attributes.keys.count;$i++){
                $htProps.Add($attributes.keys[$i].LocalName,$attributes.values[$i])
            }
            if ($htProps.Contains('DisplayName')){
                $uninstallString = $htProps.UninstallString
                $modifyPath = $htProps.ModifyPath
                if($uninstallString -match "^msiexec"){
                    $htProps.msiGUID = [regex]::match($uninstallString,'\{(.*?\})')
                }
                elseif($modifyPath -match "^msiexec"){
                    $htProps.msiGUID = [regex]::match($modfiyPath,'\{(.*?\})')
                }
                New-Object PSObject -Property $htProps #| select DisplayName, UninstallString, msiGUID, InstallLocation, Version
            }
        }
    }
    else{
        $keys =@'
:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall
:\SOFTWARE\WOW6432NODE\Microsoft\Windows\CurrentVersion\Uninstall
'@ -split "`r`n"
        foreach ($currHive in $Hive){
            foreach($key in $keys){
                $key = "$currHive" + "$key"
                if(Test-Path $key){
                    $subKeys = Get-ItemProperty "$key\*"
                }
                foreach($subKey in $subKeys){
                    if($subKey.DisplayName -like "$Name" -and $subKey.UninstallString){
                        $uninstallString = $subKey.UninstallString
                        $modifyPath = $subKey.ModifyPath
                        $htProps = [Ordered]@{
                            RegistryHive=$currHive
                            DisplayName=$subKey.DisplayName;
                            UninstallString=$uninstallString.Replace('"','');
                            msiGUID='';
                            InstallLocation=$subKey.InstallLocation;
                            Version=$subKey.DisplayVersion
                        }

                        if($uninstallString -match "^msiexec"){
                            $htProps.msiGUID = [regex]::match($uninstallString,'\{(.*?\})')
                        }
                        elseif($modifyPath -match "^msiexec"){
                            $htProps.msiGUID = [regex]::match($modfiyPath,'\{(.*?\})')
                        }
                        New-Object PSObject -Property $htProps
                    }
                }
            }
        }
    }
}