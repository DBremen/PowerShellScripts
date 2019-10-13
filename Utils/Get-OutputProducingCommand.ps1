function Get-OutputProducingCommand {
    <#    
      .SYNOPSIS
        Get the line(s) of code that produce an output from a function or script.
      .DESCRIPTION
        This is a slight modified version of the filter created by Dave Wyatt (see link)
      .PARAMETER Input
        The code to be checked for output producing line(s)
      .EXAMPLE
        #create a function for testing and save it to a file
@'
function mytest{
    $arrayList = New-Object System.Collections.ArrayList
    $null = $arrayList.Add('One')
    [void] $arrayList.Add('Two')
    $arrayList.Add('Three') | Out-Null
    $arrayList.Add('Four')
    return $true
}
'@ -split "\r?\n" | Set-Content "$env:TEMP\test.ps1"
        #dot source the function into the current scope
        . "$env:TEMP\test.ps1"
        #just call/invoke the function and pipe it to the function
        mytest | Get-OutputProducingCommand
        #output exceprt
        # Script   Command Line Code
        # ------   ------- ---- ----
        # test.ps1 mytest     6 $arrayList.Add('Four')
        # test.ps1 mytest     7 $true
      .LINK
        https://davewyatt.wordpress.com/2014/06/05/tracking-down-commands-that-are-polluting-your-pipeline/
    #>
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline, Mandatory,
            Position = 0)] 
        $Code
    )
    PROCESS {
        $stack = @(Get-PSCallStack)
        # Ignoring the top level or two of the call stack, where we've invoked the script.
        # This behavior is slightly different depending on whether the script was run at
        # a prompt, or executed by the ISE with F5.  We also ignore the stack entry at index
        # 0, which will always be the Get-OutputProducingCommand filter itself.

        $startIndex = $stack.Count - 1
        if (('<No file>', 'prompt') -contains $stack[$startIndex].Location) { $startIndex-- }
        [PSCustomObject][ordered]@{
            Script  = (Split-Path -Path $stack[$startIndex].ScriptName -Leaf)
            Command = $stack[$startIndex].Command
            Line    = $stack[$startIndex].ScriptLineNumber
            Code    = $stack[$startIndex].Position.Text
        }
    }
}
