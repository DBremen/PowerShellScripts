function Get-WIFIPassword{
    netsh wlan show profile | where {$_ -match '\:\s(.+)$'} | 
        foreach {
            $name = $Matches[1]
            netsh wlan show profile name="$name" key=clear | where {$_ -match 'Key Content\W+\:\s(.+)$'} | 
                foreach{
                    [PSCustomObject]@{ProfileName=$name;Password=$Matches[1]}
                }
        }
}





