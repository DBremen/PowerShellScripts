function Get-Breaktimer {
    <#    
        .SYNOPSIS
            Function to display a break timer with a countdown based on absolute or relative times.
        .DESCRIPTION
            The break timer is implemented using Write-Progress. Not sure if I found this idea somewhere else
            or came up with it on my own.
	    .PARAMETER StopTime
           Absolute time when the timer should stop. Should be a recognizable DateTime.
        .PARAMETER StopInMinutes
            Relative time when the timer should stop in minutes.
	    .EXAMPLE
            # Display the break timer for 30 Seconds
            Get-BreakTimer -StopInMinutes .5
        .EXAMPLE
            # Display the break timer until a fixed endtime
            Get-BreakTimer -StopTime ([datetime]"18:15")

    #>
    [CmdletBinding()]
    param( 
        [Parameter(ParameterSetName = 'AbsoluteTime', Mandatory)]   
        [DateTime]$StopTime,
        [Parameter(ParameterSetName = 'RelativeTime', Mandatory)] 
        [Decimal]$StopInMinutes
    )
    if ($stopTime) {
        $stopDT = [datetime]$stopTime
    }
    else {
        $stopDT = [datetime]::Now.AddMinutes($stopInMinutes)
        $stopTime = $stopDT.toString('HH:mm:ss')
    }
    $startDT = [datetime]::Now
    $delta = $stopDT - $startDT
    $totalSeconds = $delta.TotalSeconds
    1..$totalSeconds |
    ForEach-Object { 
        $elapsed = ([datetime]::now - $startDT).TotalSeconds
        $percent = ($elapsed + 1) * 100 / $totalSeconds
        $remaining = [timespan]::FromSeconds($totalSeconds - $elapsed + 1)
        Write-Progress -Activity "Break until $stopTime ($([datetime]::Now.ToString('HH:mm:ss')))" -Status ("Remaining: {0:d2}:{1:d2}" -f $remaining.Minutes, $remaining.Seconds) -PercentComplete $percent
        Start-Sleep -Seconds 1
    }
}
