function Format-Error {
    <#    
      .SYNOPSIS
        Format $error[x] output.
      .DESCRIPTION
        Unknown source.
      .PARAMETER ErrorRecord
        The error entry to format.
      .EXAMPLE
        #resolve the latest error record ($error[0])
        Resolve-Error
    #>
    [CmdletBinding()]
    param( 
        [Parameter(ValueFromPipeline,
            Position = 0)]   
        $ErrorRecord = $Error[0]
    )
    PROCESS {
        $error_message = "`nErrorRecord:{0}ErrorRecord.InvocationInfo:{1}Exception:{2}"
        $formatted_errorRecord = $ErrorRecord | Format-List * -force | Out-String 
        $formatted_invocationInfo = $ErrorRecord.InvocationInfo | Format-List * -force | Out-String 
        $formatted_exception = ""
        $Exception = $ErrorRecord.Exception
        for ($i = 0; $Exception; $i++, ($Exception = $Exception.InnerException)) {
            $formatted_exception += $Exception | Format-List * -force | Out-String
            $formatted_exception += "`n"
        }
        
        return $error_message -f $formatted_errorRecord, $formatted_invocationInfo, $formatted_exception
    }
}
