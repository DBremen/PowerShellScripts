function Invoke-LegacyCommand{
     <#    
      .SYNOPSIS
        Helper to invoke legacy command with switches from PowerShell in a convenient way. 
        Also supports pipeline input to invoke the command with arguments multiple times.
      .DESCRIPTION
        Supports convenient way to invoke legacy command through PowerShell without quotes and escaping needed.
        See Example
      .PARAMETER CommandAndArgs
        The command to invoke and its options/switches as string. See Example.
      .PARAMETER PipelineInput
        Optional input via pipeline to invoke the command and its switches multiple times against.
      .EXAMPLE
        1,2,3 | legacy cmd /c echo
        #runs cmd /c echo with 1, 2, and, 3
    #>
    [CmdletBinding()]
    [Alias('legacy')]
    Param(
        # Param1 help description
        [Parameter(Mandatory, 
                   ValueFromRemainingArguments, 
                   Position=0)]
        [string[]]$CommandAndArgs,
        [Parameter(ValueFromPipeline)]
        [string]$PipelineInput
    )
    PROCESS{
       $command, $options = $CommandAndArgs
       & $command  + ($options + $PipelineInput)
    }

}