function Set-IPAddress {
    <#
    .SYNOPSIS
        Set a network interfacres IPv4 address (hard coded 24bit mask) either dynamic or static including DNS settings.
        
    .DESCRIPTION
	   The function uses built-in Windows 10 Methods to set IPv4 address properties of a network adapter.
		
    .PARAMETER AdapterName
        Specifies the name of the network adapter to set the IP address for. Names can be retrieved using Get-NetAdapter. Defaults to Wi-Fi.

    .PARAMETER BaseAddress
        First three triplets of the IP address to be set. Defaults to 192.168.15

    .PARAMETER LastTriplet
        Last triplet of the IP address to be set.

    .PARAMETER GatewayAddress
        IPv4 address of the gateway to be set. Defaults to 192.168.15.1
        
    .PARAMETER DNSServerAddress
        IPv4 addresses of the primary and secondary DNS servers to be set. Defaults to ('1.1.1.1', '1.0.0.1').

    .PARAMETER Dynamic
        Switch parameter. If specified the adapters IP settins are set to automatic w/o static DNS servers.
        
    .EXAMPLE  
        #set Wi-Fi adpater's IP to 192.168.15.44
        Set-IPAddress -LastTriplet 44

    .EXAMPLE  
        set Wi-Fi adpater's IP to dynamic
        Set-IPAddress -Dynamic

#>
    [CmdletBinding()]
    param(
        $AdapterName = 'Wi-Fi',
        $BaseAddress = '192.168.15',
        [ValidateRange(1, 255)]
        $LastTriplet, 
        $GateWayAddress = '192.168.15.1',
        $DNSServerAddress = ('1.1.1.1', '1.0.0.1'),
        [switch]$Dynamic
    )
    $adapter = Get-NetAdapter  -Name $AdapterName
    $ipType = 'IPv4'
    if (-Not $Dynamic) {
        Set-ItemProperty -Path “HKLM:\SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\$($adapter.InterfaceGuid)” -Name EnableDHCP -Value 0
        $ip = $BaseAddress + '.' + $LastTriplet
        $mask = 24
        # Remove any existing IP, gateway from our ipv4 adapter double calls are intented because I received errors when only calling this once
        $adapter | Remove-NetIPAddress -AddressFamily $ipType -Confirm:$false -ErrorAction SilentlyContinue
        $adapter | Remove-NetRoute -Confirm:$false -ErrorAction SilentlyContinue

        $adapter | Remove-NetRoute -AddressFamily  $ipType -Confirm:$false -ErrorAction SilentlyContinue
        $adapter | Remove-NetRoute -AddressFamily  $ipType -Confirm:$false -ErrorAction SilentlyContinue
        # Configure the IP address and default gateway
        $adapter | New-NetIPAddress `
            -AddressFamily  $ipType `
            -IPAddress $ip `
            -PrefixLength $mask `
            -DefaultGateway $GateWayAddress
        # Configure the DNS client server IP addresses
        $adapter | Set-DnsClientServerAddress -ServerAddresses $DNSServerAddress
    }
    else {
        $interface = $adapter | Get-NetIPInterface -AddressFamily $ipType
        If ($interface.Dhcp -eq "Disabled") {
            # Remove existing gateway
            $interface | Remove-NetRoute -Confirm:$false -ErrorAction SilentlyContinue

            # Enable DHCP
            $interface | Set-NetIPInterface -DHCP Enabled
            # Configure the DNS Servers automatically
            $interface | Set-DnsClientServerAddress -ResetServerAddresses
        }
    }

}


