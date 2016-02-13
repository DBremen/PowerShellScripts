function Get-Uninstaller {
	[CmdletBinding()]
    Param(
    	$DisplayName = '*',
        [ValidateSet('HKLM', 'HKCU')]
        [string[]]$Hive = @('HKLM','HKCU')
    )
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
                if($subKey.DisplayName -like "$DisplayName" -and $subKey.UninstallString){
                    $uninstallString = $subKey.UninstallString
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
                    New-Object PSObject -Property $htProps
                }
            }
        }
    }
}



