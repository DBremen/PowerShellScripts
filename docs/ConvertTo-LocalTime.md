# ConvertTo-Localtime

## SYNOPSIS
Convert a datetime from a remote timezone to the local time.

## Script file
Utils\ConvertTo-LocalTime.ps1

## Related blog post
https://powershellone.wordpress.com/2020/06/30/convert-remote-time-to-local-time-with-argumentcompleter-and-argumenttransformation-attributes/

## SYNTAX

```
ConvertTo-Localtime [-Datetime] <DateTime> -RemoteTimeZone <Object>
```

## DESCRIPTION
The function uses Windows 10 built-in methods to retrieve time zone information and convert the time.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
#Convert from CET to Localtime using the function's alias amd a string that normally wouldn't be converted to [datetime].


clt -TimeZoneArea 'W.
Europe Standard Time' -Datetime "6/14 9:35AM"
```
### -------------------------- EXAMPLE 2 --------------------------
```
#Convert from CET to Localtime using the function's alias amd a string that normally wouldn't be converted to [datetime].


clt -TimeZoneArea 'W.
Europe Standard Time' -Datetime "14/6 9:35AM"
```
## PARAMETERS

### -Datetime
The DateTime to be converted to the local time.
This parameter uses a custom transformation attribute in order to accept some non-standard datetime formats.
Such as 'M/dd h:mmtt', 'MM/dd hh:mmtt', 'M/dd hh:mm tt', and 'dd/M h:mmtt'

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RemoteTimeZone
The time zone for which the provided DateTime should be converted.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: tz

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

### DateTime

## NOTES

## RELATED LINKS

[https://powershellone.wordpress.com/2020/06/30/convert-remote-time-to-local-time-with-argumentcompleter-and-argumenttransformation-attributes/](https://powershellone.wordpress.com/2020/06/30/convert-remote-time-to-local-time-with-argumentcompleter-and-argumenttransformation-attributes/)

[https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/world-time-clock](https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/world-time-clock)

[https://powershell.one/powershell-internals/attributes/transformation](https://powershell.one/powershell-internals/attributes/transformation)

[https://powershell.one/powershell-internals/attributes/custom-attributes#custom-transformation-attribute](https://powershell.one/powershell-internals/attributes/custom-attributes#custom-transformation-attribute)





