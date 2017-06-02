function Get-DateRange {
	Add-Type -AssemblyName System.Windows.Forms
	$form = new-object Windows.Forms.Form 
	$form.text = "Calendar" 
	$form.Size = new-object Drawing.Size @(656,639) 

	# Make "Hidden" SelectButton to handle Enter Key
	$btnSelect = new-object System.Windows.Forms.Button
	$btnSelect.Size = "1,1"
	$btnSelect.add_Click({ 
		$form.close() 
	}) 
	$form.Controls.Add($btnSelect ) 
	$form.AcceptButton =  $btnSelect
	$cal = new-object System.Windows.Forms.MonthCalendar 
	$cal.ShowWeekNumbers = $true 
	$cal.MaxSelectionCount = 356
	$cal.Dock = 'Fill' 
	$form.Controls.Add($cal) 
	$Form.Add_Shown({$form.Activate()})  
	[void]$form.showdialog() 
	return $cal.SelectionRange
}



function Set-CalendarAppointment($startDate,$endDate,$subject,$location){
    $appointment = New-Object Microsoft.Exchange.WebServices.Data.Appointment($service)
    $appointment.Subject = $subject
    $appointment.Start = $startDate
    $appointment.End = $endDate
    $appointment.Location = $location
    $appointment.Save([Microsoft.Exchange.WebServices.Data.SendInvitationsMode]::SendToNone)
}

function Set-OOTO($Email='emai@domain.com', [Microsoft.Exchange.WebServices.Data.ExchangeVersion]$ExchangeVersion=[Microsoft.Exchange.WebServices.Data.ExchangeVersion]::Exchange2007_SP1, [switch]$ProvideCredentials,[switch]$Off){
        #EWS managed API 2.1
        #reference: https://msdn.microsoft.com/en-us/library/jj220535%28v=exchg.80%29.aspx
        #https://www.microsoft.com/en-us/download/details.aspx?id=42022
        $apiPath = 'C:\Program Files (x86)\Microsoft\Exchange\Web Services\2.1\Microsoft.Exchange.WebServices.dll'
        if (-not (Test-Path $apiPath)){
            $a = new-object -comobject wscript.shell
	        $answer = $a.popup("The function requires the EWS Mangaged API to be installed on your machine do you want to do download and install it now?", `
	        0,"Download",4)
	        If ($answer -eq 6) {
		         $webclient = New-Object Net.WebClient
		         $url = 'https://download.microsoft.com/download/3/E/4/3E4AF215-E418-47B8-BB89-D5555E858728/EwsManagedApi.MSI'
                 $path = "$env:TEMP\EwsManagedApi.MSI"
		         $webclient.DownloadFile($url, $path)
                 $argument = '/quiet'
                 Start-Process $path $argument -Wait
	        } else {
		        Write-Warning "Please visit https://www.microsoft.com/en-us/download/details.aspx?id=44011 to download the EWS managed API manually"
                exit
	        }
        }
        Add-Type -Path $apiPath
        $script:service = New-Object Microsoft.Exchange.WebServices.Data.ExchangeService($ExchangeVersion)
        if ($provideCredentials){
            $credentials = Get-Credential
            $service.Credentials = $credentials.GetNetworkCredential()
        }

        $service.AutodiscoverUrl($email)
        $oofSetting = $service.GetUserOofSettings($email)
        if (!$off){
	        $dateRange = Get-DateRange
	        $startDt = [DateTime]::Parse(($dateRange.Start.ToLongDateString() + " 12:00 AM"))
            #get next business day
            $returnDt = $dateRange.End.AddDays(1)
            while ($returnDt.DayOfWeek -eq "Saturday" -or $returnDt.DayOfWeek -eq "Sunday") { $returnDt = $returnDt.AddDays(1) }
	        $endDt = [DateTime]::Parse(($dateRange.End.AddDays(1).ToLongDateString() + " 12:00 AM"))
	        $msg="<span style='font-size:10.0pt;font-family:" + '"Arial","sans-serif"' + "'>"
	        $text=@"
Hello,
<br><br>Thank you for your email.
<br>
<br>Please note I will be out of the office  from $($startDt.ToLongDateString()), returning $($returnDt.ToLongDateString()). During this time I will have no access to emails.
<br><br><br><br>
"@
	    $msg += $text + "</span>"
        #if on company pc get the signature otherwise go with the local copy
        $remoteSigPath ="$env:APPDATA\Microsoft\Signatures\mySignature.htm"
        $localSigPath = ".\Signature.htm"
        if (Test-Path $remoteSigPath){
            copy $remoteSigPath $localSigPath
        }
	    $msg +=  Get-Content $localSigPath | Out-String
	    $msg = $msg.ToString()
        $msg =  New-Object Microsoft.Exchange.WebServices.Data.OofReply($msg)
        $oofSetting.InternalReply = $msg
        $oofSetting.ExternalReply = $msg
        $duration = New-Object Microsoft.Exchange.WebServices.Data.TimeWindow($startDt,$endDt)
        $oofSetting.Duration = $duration
        $oofSetting.State = [Microsoft.Exchange.WebServices.Data.OofState]::Enabled
        $service.SetUserOofSettings($email, $oofSetting)
        Set-CalendarAppointment $startDt $endDt "Out of Office" "Away"
	    Write-Host "Set OOTO from $($startDt.ToShortDateString()) to $($endDt.AddDays(-1).ToShortDateString())" 
    }
    else{
         $oofSetting.State = [Microsoft.Exchange.WebServices.Data.OofState]::Disabled
         $service.SetUserOofSettings($email, $oofSetting)
    }
}

Export-ModuleMember -Function @('Set-OOTO')



