function Select-ObjectX{
     <#    
        .SYNOPSIS
            Proxy function for Select-Object providing easier syntax for calculated properties.
        .DESCRIPTION
            What I find confusing about the syntax for calculated properties for the built-in Select-Object,
            is the fact that we need two key/value pairs in order to actually provide a name and a value. 
            In my humble opinion it would make more sense if the Property parameter syntax for calculated properties would only require
            Name=Expression instead of Name='Name' and Expression = {$_.Expression}. 
            With this proxy function one can do just that.
	    .PARAMETER InputObject
		.PARAMETER ExcludeProperty
            Removes the specifies properties from the selection. Wildcards are permitted. This parameter is effective only when the command also includes the 
            Property parameter.
            The value of the property parameter can be a calculated property, which is a hash table that specifies a name and calculates a value for the 
            property display. Valid keys are:
        
            -- Name or Label <string>
            -- Expression <string> or <scriptblock>
        .PARAMETER ExpandProperty
            Specifies a property to select, and indicates that an attempt should be made to expand that property.  Wildcards are permitted in the property 
            name.
        .PARAMETER Index [<Int32[]>]
            Selects objects from an array based on their index values. Enter the indexes in a comma-separated list.
            Indexes in an array begin with 0, where 0 represents the first value and (n-1) represents the last value.
        .PARAMETER InformationAction [<System.Management.Automation.ActionPreference]>]
            The value of the property parameter can be a calculated property, which is a hash table that specifies a name and calculates a value for the 
            property display. Valid keys are:
        
            -- Name or Label <string>
        
            -- Expression <string> or <scriptblock>
            For more information, see the examples.
        .PARAMETER InformationVariable 
            The value of the property parameter can be a calculated property, which is a hash table that specifies a name and calculates a value for the 
            property display. Valid keys are:
        
            -- Name or Label <string>
        
            -- Expression <string> or <scriptblock>
            For more information, see the examples.
        .PARAMETER InputObject
            Specifies objects to send to the cmdlet through the pipeline. This parameter enables you to pipe objects to Select-Object.
        
            When you use the InputObject parameter with Select-Object, instead of piping command results to Select-Object, the InputObject value?even if the 
            value is a collection that is the result of a command, such as ?InputObject (Get-Process)?is treated as a single object. Because InputObject 
            cannot return individual properties from an array or collection of objects, it is recommended that if you use Select-Object to filter a 
            collection of objects for those objects that have specific values in defined properties, you use Select-Object in the pipeline, as shown in the 
            examples in this topic.       
        .PARAMETER Last
            Specifies the number of objects to select from the end of an array of input objects.
        .PARAMETER Property
            Specifies the properties to select. Wildcards are permitted.
            The value of the Property parameter can be a new calculated property. To create a calculated, property, use a hash table. 
            The entries of the table should consists of Name=Expression entries
        .PARAMETER SkipLast
            The value of the property parameter can be a calculated property, which is a hash table that specifies a name and calculates a value for the 
            property display. Valid keys are:
        
            -- Name or Label <string>
        
            -- Expression <string> or <scriptblock>
        .PARAMETER Unique
            Specifies that if a subset of the input objects has identical properties and values, only a single member of the subset will be selected.
            This parameter is case-sensitive. As a result, strings that differ only in character casing are considered to be unique.
        .PARAMETER Wait
            Turns off optimization. Windows PowerShell runs commands in the order that they appear in the command pipeline and lets them generate all 
            objects. By default, if you include a Select-Object command with the First or Index parameters in a command pipeline, Windows PowerShell stops 
            the command that generates the objects as soon as the selected number of objects is generated.
        
            This parameter is introduced in Windows PowerShell 3.0.
        .PARAMETER INPUTS
            System.Management.Automation.PSObject
            You can pipe any object to Select-Object.
        .PARAMETER OUTPUTS
            System.Management.Automation.PSObject
        .EXAMPLE
            Get-ChildItem | Select-ObjectX Name, CreationTime,  @{Kbytes={$_.Length / 1Kb}}
        .EXAMPLE
            Get-ChildItem | Select-ObjectX Name, @{Age={ (((Get-Date) - $_.CreationTime).Days) }}
        .LINK
            https://powershellone.wordpress.com/2015/11/23/simplified-syntax-for-calculated-properties-with-select-object/
    #>
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
                 $PSBoundParameters.Property = foreach ($prop in $Property){
                    <#
                    if ($prop -is [System.Management.Automation.ScriptBlock]){
                        $name, $expression = $prop.ToString().split('=',2)
                        $newProperty += @{n=$name;e=[ScriptBlock]::Create($expression.Replace('$','$_.'))}
                    }
                    #>
                    if ($prop -is [System.Collections.Hashtable]){
                        foreach ($htEntry in $prop.GetEnumerator()){
                           @{n=$htEntry.Key;e=$htEntry.Value}
                        }
                    }
                    else{
                        $prop
                    }
                }
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
}
