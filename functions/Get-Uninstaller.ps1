#see comment below for PowerShell v5 version
function Get-Uninstaller {
	[CmdletBinding()]
    Param(
    	$Name = '*',
        [ValidateSet('HKLM', 'HKCU')]
        [string[]]$Hive = @('HKLM','HKCU')
    )
    if ($PSVersionTable.PSVersion.Major -eq 5){
        Get-Package | where {$_.Name -like "$Name"} | foreach{
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

Get-Uninstaller