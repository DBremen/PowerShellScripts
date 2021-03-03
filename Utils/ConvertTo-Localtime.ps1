class DateTransformAttribute : System.Management.Automation.ArgumentTransformationAttribute {
   
    # property to take additional format strings for transformations
    [string[]]$AdditionalFormatStrings 

    # default constructor:
    DateTransformAttribute() : base() { }

    # 2nd constructor with parameter AdditionalFormatStrings
    DateTransformAttribute([string[]]$AdditionalFormatStrings) : base() {
        $this.AdditionalFormatStrings = $AdditionalFormatStrings
    }

    # Transform() method is called whenever there is a variable or parameter assignment.

    [object] Transform([System.Management.Automation.EngineIntrinsics]$engineIntrinsics, [object] $inputData) {
        if ($inputData -as [datetime]) {
            # return as-is:
            return ($inputData -as [datetime])
        }
        # get the provided format strings first for them to take precedence
        $dateFormatStrings = $this.AdditionalFormatStrings
        # add the static date format strings
        $dayFirstFormats = 'd/M h:mtt', 'dd/MM hh:mmtt', 'dd/MM hh:mm:ss tt'
        # add same with '.' as delimiter
        $dayFirstFormats = $dayFirstFormats.foreach{ $_; $_.Replace('/', '.') }
        $monthFirstFormats = 'M/d h:mtt', 'MM/dd hh:mmtt', 'MM/dd hh:mm:ss tt'
        # check if the local date is in M/d or d/M format
        # check for this format first
        if ('14/6' -as [datetime]) { 
            # local date is d/M
            $dateFormatStrings += $dayFirstFormats + $monthFirstFormats
        }
        else {
            $dateFormatStrings += $monthFirstFormats + $dayFirstFormats
        }
        
        #try to convert a provided string with ParseExact using the different format strings
        if ($inputData -is [string]) {
            foreach ($format in $dateFormatStrings) {
                try {
                    $newDate = [datetime]::ParseExact($inputData, $format, $Null)
                }
                catch {
                    # if the conversion attempt fails keep trying the other formats
                    continue
                }
                # if the conversion succeeds return the date
                if ($newDate) { return $newDate }
            }
        }
        
        # conversion faild throw an exception.
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
        https://powershellone.wordpress.com/2020/06/30/convert-remote-time-to-local-time-with-argumentcompleter-and-argumenttransformation-attributes/

    .LINK
        https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/world-time-clock
    
    .LINK
        https://powershell.one/powershell-internals/attributes/transformation

    .LINK
        https://powershell.one/powershell-internals/attributes/custom-attributes#custom-transformation-attribute

#>
    [cmdletbinding()]
    [alias("clt")]
    [outputtype("DateTime")]
    Param(
        [Parameter(Position = 0, Mandatory)]
        [DateTime][DateTransformAttribute()]$Datetime,
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
        $remoteTz = Get-TimeZone -id $RemoteTimeZone
    }
    Process {
        $localTz = Get-TimeZone
        $localTime = [System.TimeZoneInfo]::ConvertTime($Datetime, $remoteTz, $localTz)
        [PSCustomObject][ordered]@{
            'Remote time zone' = $remoteTz.Id
            'Remote time'      = $Datetime
            'Local time zone'  = $localTz.Id
            'Local time'       = $localTime
        }
    }
    End {
    }
}

