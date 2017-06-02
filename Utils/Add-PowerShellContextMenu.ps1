function Add-PowerShellContextMenu{
     <#    
    .SYNOPSIS
        Function to create context menu entries in order to invoke PowerShell
    .DESCRIPTION
        While there is already a default ‘Edit’ context menu entry for PowerShell ISE I wanted to have it open a specific Platform version elevated without loading profile). 
        In addition to that I also like to add a context menu entry to open up a PowerShell command prompt from any folder or drive in Windows Explorer.
	.PARAMETER ContextType
		Indicates the type of context menu entry to create. Possible values are openPowerShellHere and editWithPowerShellISE
	.PARAMETER Platform
		The platform type of Powershell to create the context menu entry for. Defaults to x64.
	.EXAMPLE
		Add-PowerShellContextMenu -ContextType editWithPowerShellISE -Platform x86 -AsAdmin
	.EXAMPLE
		Add-PowerShellContextMenu -ContextType openPowerShellHere -Platform x86 -AsAdmin
    .LINK
        https://powershellone.wordpress.com/2015/09/16/adding-edit-with-powershell-ise-and-open-powershell-here-as-admin-to-the-context-menu/
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0)]
        [ValidateSet('openPowerShellHere','editWithPowerShellISE')]
        $ContextType,
        [ValidateSet('x86','x64')]
        $Platform='x64',
        [switch]$NoProfile,
        [switch]$AsAdmin
    )
    $versionToOpen = "PowerShell ($Platform)"
    $powerShellExe = 'powershell.exe'
    if ($ContextType -eq 'editWithPowerShellISE') { 
        $powerShellExe = 'PowerShell_ISE.exe' 
        $versionToOpen = "PowerShell ISE ($Platform)"
    }
    $powerShellPath = "$env:WINDIR\System32\WindowsPowerShell\v1.0\$powershellExe"
    if ($Platform -eq 'x86'){ 
        $powerShellPath = "$env:WINDIR\sysWOW64\WindowsPowerShell\v1.0\$powershellExe" 
    }
    if ($ContextType -eq 'openPowerShellHere'){
        $menu = "Open Windows $versionToOpen here"
        $command = "$powerShellPath -NoExit -Command ""Set-Location '%V'"""
        if ($NoProfile.IsPresent){
            $command = $command -replace 'NoExit', 'NoExit -NoProfile'
        }
        if ($AsAdmin.IsPresent){
            $menu += ' as Administrator'
            'directory', 'directory\background', 'drive' | ForEach-Object {
                New-Item -Path "Registry::HKEY_CLASSES_ROOT\$_\shell" -Name runas\command -Force |
                Set-ItemProperty -Name '(default)' -Value $command -PassThru |
                Set-ItemProperty -Path {$_.PSParentPath} -Name '(default)' -Value $menu -PassThru |
                Set-ItemProperty -Name HasLUAShield -Value ''
            }
        }
        else{
            'directory', 'directory\background', 'drive' | ForEach-Object {
                New-Item -Path "Registry::HKEY_CLASSES_ROOT\$_\shell" -Name $menu -Value $menu -Force | Out-Null
                New-Item -Path "Registry::HKEY_CLASSES_ROOT\$_\shell\$menu\command" -Value $command | Out-Null
            }
        }
    }
    elseif($ContextType -eq 'editWithPowerShellISE'){
        $menu = "Edit with $versionToOpen"
        $command = $powerShellPath
        if ($NoProfile.IsPresent){
            $command += ' -NoProfile'
        }
        if($AsAdmin.IsPresent){
            $menu += ' as Administrator'
            Get-ChildItem "Registry::HKEY_CLASSES_ROOT" | Where-Object PSChildName -like 'Microsoft.PowerShell*' | ForEach-Object{
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
            Get-ChildItem "Registry::HKEY_CLASSES_ROOT" | Where-Object PSChildName -like 'Microsoft.PowerShell*' | ForEach-Object{
                if (!(Test-Path "Registry::$($_.Name)\shell")){
                    New-Item "Registry::$($_.Name)\shell" | Out-Null
                }
                New-Item "Registry::$($_.Name)\shell\$menu\command" -Value "$command ""%1""" -Force | Out-Null  
            }
        }
        
    }
    
}