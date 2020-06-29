# Set-IPAddress

## SYNOPSIS
Set a network interfacres IPv4 address (hard coded 24bit mask) either dynamic or static including DNS settings.

## Script file
Utils\Set-IPAddress.ps1

## SYNTAX

```
Set-IPAddress [[-AdapterName] <Object>] [[-BaseAddress] <Object>] [[-LastTriplet] <Object>]
 [[-GateWayAddress] <Object>] [[-DNSServerAddress] <Object>] [-Dynamic]
```

## DESCRIPTION
The function uses built-in Windows 10 Methods to set IPv4 address properties of a network adapter.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
#set Wi-Fi adpater's IP to 192.168.15.44


Set-IPAddress -LastTriplet 44
```
### -------------------------- EXAMPLE 2 --------------------------
```
set Wi-Fi adpater's IP to dynamic


Set-IPAddress -Dynamic
```
## PARAMETERS

### -AdapterName
Specifies the name of the network adapter to set the IP address for.
Names can be retrieved using Get-NetAdapter.
Defaults to Wi-Fi.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: False
Position: 1
Default value: Wi-Fi
Accept pipeline input: False
Accept wildcard characters: False
```

### -BaseAddress
First three triplets of the IP address to be set.
Defaults to 192.168.15

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: False
Position: 2
Default value: 192.168.15
Accept pipeline input: False
Accept wildcard characters: False
```

### -LastTriplet
Last triplet of the IP address to be set.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GateWayAddress
IPv4 address of the gateway to be set.
Defaults to 192.168.15.1

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: False
Position: 4
Default value: 192.168.15.1
Accept pipeline input: False
Accept wildcard characters: False
```

### -DNSServerAddress
IPv4 addresses of the primary and secondary DNS servers to be set.
Defaults to ('1.1.1.1', '1.0.0.1').

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: False
Position: 5
Default value: ('1.1.1.1', '1.0.0.1')
Accept pipeline input: False
Accept wildcard characters: False
```

### -Dynamic
Switch parameter.
If specified the adapters IP settins are set to automatic w/o static DNS servers.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS





