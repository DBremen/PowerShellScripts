function Select-Obje{
[CmdletBinding(DefaultParameterSetName='DefaultParameter', HelpUri='http://go.microsoft.com/fwlink/?LinkID=113387', RemotingCapability='None')]
param(
    [Parameter(ValueFromPipeline=$true)]
    [psobject]
    ${InputObject},

    [Parameter(ParameterSetName='SkipLastParameter', Position=0)]
    [Parameter(ParameterSetName='DefaultParameter', Position=0)]
    [System.Object[]]
    ${Property},

    [Parameter(ParameterSetName='SkipLastParameter')]
    [Parameter(ParameterSetName='DefaultParameter')]
    [string[]]
    ${ExcludeProperty},

    [Parameter(ParameterSetName='DefaultParameter')]
    [Parameter(ParameterSetName='SkipLastParameter')]
    [string]
    ${ExpandProperty},

    [switch]
    ${Unique},

    [Parameter(ParameterSetName='DefaultParameter')]
    [ValidateRange(0, 2147483647)]
    [int]
    ${Last},

    [Parameter(ParameterSetName='DefaultParameter')]
    [ValidateRange(0, 2147483647)]
    [int]
    ${First},

    [Parameter(ParameterSetName='DefaultParameter')]
    [ValidateRange(0, 2147483647)]
    [int]
    ${Skip},

    [Parameter(ParameterSetName='SkipLastParameter')]
    [ValidateRange(0, 2147483647)]
    [int]
    ${SkipLast},

    [Parameter(ParameterSetName='IndexParameter')]
    [Parameter(ParameterSetName='DefaultParameter')]
    [switch]
    ${Wait},

    [Parameter(ParameterSetName='IndexParameter')]
    [ValidateRange(0, 2147483647)]
    [int[]]
    ${Index})

begin
{
    try {
        $outBuffer = $null
        if ($PSBoundParameters.TryGetValue('OutBuffer', [ref]$outBuffer))
        {
            $PSBoundParameters['OutBuffer'] = 1
        }
        #only if the property array contains a hashtable property
        if ( ($Property | where { $_ -is [System.Collections.Hashtable] }) ) {
            $newProperty = @()
            foreach ($prop in $Property){
                <#
                if ($prop -is [System.Management.Automation.ScriptBlock]){
                    $name, $expression = $prop.ToString().split('=',2)
                    $newProperty += @{n=$name;e=[ScriptBlock]::Create($expression.Replace('$','$_.'))}
                }
                #>
                if ($prop -is [System.Collections.Hashtable]){
                    foreach ($htEntry in $prop.GetEnumerator()){
                       $newProperty += @{n=$htEntry.Key;e=$htEntry.Value}
                    }
                }
                else{
                    $newProperty += $prop
                }
            }
            $PSBoundParameters.Property = $newProperty
        }
        $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('Microsoft.PowerShell.Utility\Select-Object', [System.Management.Automation.CommandTypes]::Cmdlet)
        $scriptCmd = {& $wrappedCmd @PSBoundParameters }
        $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
        $steppablePipeline.Begin($PSCmdlet)
    } catch {
        throw
    }
}

process
{
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
}

end
{
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
}
<#

.ForwardHelpTargetName Microsoft.PowerShell.Utility\Select-Object
.ForwardHelpCategory Cmdlet

#>

}