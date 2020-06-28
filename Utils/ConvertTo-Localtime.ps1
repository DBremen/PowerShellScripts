class DateTransformAttribute : System.Management.Automation.ArgumentTransformationAttribute {
    [object] Transform([System.Management.Automation.EngineIntrinsics]$engineIntrinsics, [object] $inputData) {
        if ($inputData -as [datetime]) {
            # return as-is:
            return ($inputData -as [datetime])
        }
        #try to convert the string using different variations of ::parseexact
        elseif ($inputData -is [string]) {
            try { $newDate = [datetime]::ParseExact($inputData, 'M/dd h:mmtt', $Null) }
            catch {
                try { $newDate = [datetime]::ParseExact($inputData, 'MM/dd hh:mmtt', $Null) } 
                catch {
                    try { $newDate = [datetime]::ParseExact($inputData, 'M/dd hh:mm tt', $Null) }
                    catch {
                        try { $newDate = [datetime]::ParseExact($inputData, 'dd/M h:mmtt', $Null) } 
                        catch { throw [System.InvalidOperationException]::new('No valid date time.') }
                    }
                }
            }
            if ($newDate) { return $newDate }
        }
        
        # anything else throws an exception:
        throw [System.InvalidOperationException]::new('No valid date time.')
    }
}

function ConvertTo-Localtime {
    <#
    .SYNOPSIS
        Convert a datetime from a remote timezone to the local time.
        
    .DESCRIPTION
	   The function uses Windows 10 built-in methods to retrieve time zone information and convert the time.
		
    .PARAMETER DateTime
        The DateTime to be converted to the local time. This parameter uses a custom transformation attribute in order to accept some non-standard datetime formats.
        Such as 'M/dd h:mmtt', 'MM/dd hh:mmtt', 'M/dd hh:mm tt', and 'dd/M h:mmtt'

    .PARAMETER RemoteTimeZone
        The time zone for which the provided DateTime should be converted. 
        
    .EXAMPLE  
        #Convert from CET to Localtime using the function's alias amd a string that normally wouldn't be converted to [datetime].
        clt -TimeZoneArea 'W. Europe Standard Time' -Datetime "6/14 9:35AM"

    .EXAMPLE  
        #Convert from CET to Localtime using the function's alias amd a string that normally wouldn't be converted to [datetime].
        clt -TimeZoneArea 'W. Europe Standard Time' -Datetime "14/6 9:35AM"

    .LINK
        https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/world-time-clock
    
    .LINK
        https://powershell.one/powershell-internals/attributes/transformation

#>
    [cmdletbinding()]
    [alias("clt")]
    [outputtype("DateTime")]
    Param(
        [Parameter(Position = 0, Mandatory)]
        [DateTime][DateTransform()]$Datetime,
        [Parameter(Mandatory)]
        [ArgumentCompleter(
            {
                param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
                $allTimezones = Get-TimeZone -ListAvailable | Group-Object DisplayName -AsHashTable -AsString
                $allTimezones.GetEnumerator() | Where-Object { $_.Name -like "*${wordToComplete}*" } |
                Sort-Object { $_.Value.Displayname }-Unique | ForEach-Object {
                    New-Object System.Management.Automation.CompletionResult (
                        "'$($_.Value.Id)'",
                        $_.Value.DisplayName,
                        'ParameterValue',
                        $_.Value.DisplayName
                    )
                }
            }
        )]
        [Alias('tz')]
        $RemoteTimeZone
    )
    Begin {
        $timeZoneInfo = Get-TimeZone -id $RemoteTimeZone
        $offset = $timeZoneInfo.BaseUtcOffset
        $dst = $timeZoneInfo.SupportsDaylightSavingTime
    }
    Process {
        $localTime = ($Datetime).AddMinutes( - ($offset.TotalMinutes))
        if ($dst -and $localTime.IsDaylightSavingTime()) {
            $localTime = $localTime.AddHours(-1)
        }
        [PSCustomObject][ordered]@{
            'Remote time zone' = $timeZoneInfo.Id
            'Remote time'      = $Datetime
            'Local time zone'  = (Get-TimeZone).Id
            'Local time'       = $localTime
        }
    }
    End {
    }
}
