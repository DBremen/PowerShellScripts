function Get-FirstPSVersion ($command){
    $baseUri = 'https://docs.microsoft.com/en-us/powershell/module/Microsoft.PowerShell.Archive'
	foreach ($version in ('3.0','4.0','5.0','5.1','6')){
	    $url = (Invoke-WebRequest -uri ("$baseUri/$command" + "?view=powershell-$version") -MaximumRedirection 0 -ea SilentlyContinue).Headers.Location
	    if ($url -notlike '*FallbackFrom*'){
            return [Version]$version
        }
    }
}