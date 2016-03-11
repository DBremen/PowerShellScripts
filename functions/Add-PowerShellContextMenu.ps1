function Add-PowerShellContextMenu{
    [CmdletBinding()]
    param(
        [Parameter(Position=0)]
        [ValidateSet('openPowerShellHere','editWithPowerShellISE')]
        $contextType,
        [ValidateSet('x86','x64')]
        $platform='x64',
        [switch]$noProfile,
        [switch]$asAdmin
    )
    $versionToOpen = "PowerShell ($platform)"
    $powerShellExe = 'powershell.exe'
    if ($contextType -eq 'editWithPowerShellISE') { 
        $powerShellExe = 'PowerShell_ISE.exe' 
        $versionToOpen = "PowerShell ISE ($platform)"
    }
    $powerShellPath = "$env:WINDIR\System32\WindowsPowerShell\v1.0\$powershellExe"
    if ($platform -eq 'x86'){ 
        $powerShellPath = "$env:WINDIR\sysWOW64\WindowsPowerShell\v1.0\$powershellExe" 
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