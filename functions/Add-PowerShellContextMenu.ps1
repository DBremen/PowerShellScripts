#http://www.howtogeek.com/107965/how-to-add-any-application-shortcut-to-windows-explorers-context-menu/

function Add-PowerShellContextMenu{
    [CmdletBinding()]
    param(
        [Parameter(Position=0)]
        [ValidateSet('openPowerShellHere','editWithPowerShellISE')]
        $contextType,
        [switch]$platform='x64',
        [switch]$noProfile,
        [switch]$asAdmin
    )
    $versionToOpen = 'PowerShell (x64)'
    $powerShellExe = 'powershell.exe'
    if ($contextType -eq 'editWithPowerShellISE') { 
        $powerShellExe = 'PowerShell_ISE.exe' 
         $versionToOpen = 'PowerShell ISE (x64)'
    }
    $powerShellPath = "$env:WINDIR\sysWOW64\WindowsPowerShell\v1.0\$powershellExe"
    if ($platform -eq 'x86'){ 
        $powerShellPath = "$env:WINDIR\sysWOW64\WindowsPowerShell\v1.0\$powershellExe" 
        $versionToOpen = $versionToOpen -replace 'x64','x86'
    }
    if ($contextType -eq 'openPowerShellHere'){
        $menu = "Open Windows $versionToOpen here"
        $command = "$powerShellPath -NoExit -Command ""Set-Location '%V'"""
        if ($noProfile.IsPresent){
            $command = $command -replace 'NoExit', 'NoExit -noProfile'
        }
        if ($asAdmin.IsPresent){
            $menu += ' as Administrator'
            'directory', 'directory\background', 'drive' | foreach {
                New-Item -Path "Registry::HKEY_CLASSES_ROOT\$_\shell" -Name runas\command -Force |
                Set-ItemProperty -Name '(default)' -Value $command -PassThru |
                Set-ItemProperty -Path {$_.PSParentPath} -Name '(default)' -Value $menu -PassThru |
                Set-ItemProperty -Name HasLUAShield -Value ''
            }
        }
        else{
            'directory', 'directory\background', 'drive' | foreach {
                New-Item -Path "Registry::HKEY_CLASSES_ROOT\$_\shell" -Name $menu -Value $menu -Force | Out-Null
                New-Item -Path "Registry::HKEY_CLASSES_ROOT\$_\shell\$menu\command" -Value $command | Out-Null
            }
        }
    }
    elseif($contextType -eq 'editWithPowerShellISE'){
        $menu = "Edit with $versionToOpen"
        $command = $powerShellPath
        if ($noProfile.IsPresent){
            $command += ' -noProfile'
        }
        if($asAdmin.IsPresent){
            $menu += ' as Administrator'
            dir "Registry::HKEY_CLASSES_ROOT" | where PSChildName -like 'Microsoft.PowerShell*' | foreach{
                if (!(Test-Path "Registry::$($_.Name)\shell")){
                    New-Item "Registry::$($_.Name)\shell" | Out-Null
                }
                New-Item "Registry::$($_.Name)\shell\" -Name runas\command -Force |
                Set-ItemProperty -Name '(default)' -Value "$command ""%1""" -PassThru |
                Set-ItemProperty -Path {$_.PSParentPath} -Name '(default)' -Value $menu -PassThru |
                Set-ItemProperty -Name HasLUAShield -Value ''
            }
        }
        else{
            dir "Registry::HKEY_CLASSES_ROOT" | where PSChildName -like 'Microsoft.PowerShell*' | foreach{
                if (!(Test-Path "Registry::$($_.Name)\shell")){
                    New-Item "Registry::$($_.Name)\shell" | Out-Null
                }
                New-Item "Registry::$($_.Name)\shell\$menu\command" -Value "$command ""%1""" -Force | Out-Null  
            }
        }
        
    }
    
}

 Add-PowerShellContextMenu -contextType editWithPowerShellISE -platform x86 -asAdmin