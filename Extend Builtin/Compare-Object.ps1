function Compare-Object{
    <#
    .SYNOPSIS
        Proxy function for the built-in Compare-Object cmdlet. This version also works with arrays,
        arrays of PSCustomObjects and custom classes it iterates over nested objects and properties to compare their values
        and also support compact output. See description and paramenter help for more.

    .DESCRIPTION
        The Compare-Object cmdlet compares two sets
        of objects. One set of objects is the
        "reference set," and the other set is the
        "difference set."

        The result of the comparison indicates
        whether a property value appeared only in the
        object from the reference set (indicated by
        the <= symbol), only in the object from the
        difference set (indicated by the => symbol)
        or, if the IncludeEqual parameter is
        specified, in both objects (indicated by the
        == symbol).
        Or compact output (through Compact switch) with 
        'Property', 'ReferenceValue', 'DifferenceValue' in one row.

    .PARAMETER ReferenceObject
        Specifies an array of objects used as a reference for comparison.

    .PARAMETER DifferenceObject
        Specifies an array of objects used as a difference for comparison.

    .PARAMETER SyncWindow
        Specifies the number of adjacent objects that
        this cmdlet inspects while looking for a
        match in a collection of objects. This cmdlet
        examines adjacent objects when it does not
        find the object in the same position in a
        collection. The default value is
        [Int32]::MaxValue, which means that this
        cmdlet examines the entire object collection.

    .PARAMETER Property
        Specifies an array of properties of the reference and difference objects to compare.

    .PARAMETER MaxDepth
        Specifies the maximum recursion depth. Defaults to -1 for recursion over all input objects.

    .PARAMETER __Depth
        Internal parameter used to carry forward depth information across recursive calls.

    .PARAMETER __Property
        Internal parameter used to carry property name information across recursive calls.

    .PARAMETER ExludeDifferent
        Indicates that this cmdlet displays only the
        characteristics of compared objects that are
        equal.

    .PARAMETER IncludeEqual
        Indicates that this cmdlet displays
        characteristics of compared objects that are
        equal. By default, only characteristics that
        differ between the reference and difference
        objects are displayed.

    .PARAMETER PassThru
        Returns an object representing the item with
        which you are working. By default, this
        cmdlet does not generate any output.

    .PARAMETER Culture
        Specifies the culture to use for comparisons.

    .PARAMETER CaseSensitive
        Indicates that comparisons should be case-sensitive.

    .PARAMETER Compact
        Switch parameter, if specified puts output into 'Property', 'ReferenceValue', 'DifferenceValue' form instead of long form.
	.EXAMPLE
		class Person {
			[String]$Name
			[String]$LastName
			[String[]]$Age
			[Person[]]$Parents

			Person($Name, $LastName, $Age) {
				$this.Name = $Name
				$this.LastName = $LastName
				$this.Age = $Age
			}
		}

		$psmith = [Person]::new('Paul', 'Smith', (46, 66, 77))
		$msmith = [Person]::new('Mary', 'Smith', 35)
		$nsmith = [Person]::new('Nigel', 'Smith', 11)
		$nsmith.Parents = $psmith, $msmith

		$pdoe = [Person]::new('Jon', 'Doe', 46)
		$ldoe = [Person]::new('Mary', 'Doe', 51)
		$adoe = [Person]::new('Aidan', 'Doe', 23)
		$adoe.Parents = $pdoe, $ldoe

		Compare-Object $nsmith $adoe -IncludeEqual
    .EXAMPLE
        #create two custom objects
        $one = [PSCustomObject]@{Name='Peter';Age=23;Colors='blue','black','green'}
        $two = [PSCustomObject]@{Name='Paul';Age=23;Colors='blue','yellow','green'}
        #compare them with compact output including equal property values
        Compare-Object $one $two -Compact -IncludeEqual

    .LINK
        https://powershellone.wordpress.com/2021/03/16/extending-powershells-compare-object-to-handle-custom-classes-and-arrays/
    #>
    [CmdletBinding(DefaultParameterSetName='Compact')]
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [AllowEmptyCollection()]
        ${ReferenceObject},

        [Parameter(Mandatory=$true, Position=1, ValueFromPipeline=$true)]
        [AllowEmptyCollection()]
        ${DifferenceObject},

        [ValidateRange(0, 2147483647)]
        [int]
        ${SyncWindow},

        [System.Object[]]
        ${Property},

        [ValidateRange(-1, 20)]
        [int]
        ${MaxDepth} = -1,

        [int]
        $__Depth = 0,

        [string]
        $__Property,

        [switch]
        ${ExcludeDifferent},

        [switch]
        ${IncludeEqual},

        [Parameter(ParameterSetName='PassThru')]
        [switch]
        ${PassThru},

        [string]
        ${Culture},

        [switch]
        ${CaseSensitive},

        [Parameter(ParameterSetName='Compact')]
        [switch]
        $Compact
        )


    begin
    {
        try {
            $outBuffer = $null
            if ($PSBoundParameters.TryGetValue('OutBuffer', [ref]$outBuffer))
            {
                $PSBoundParameters['OutBuffer'] = 1
            }
            $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('Microsoft.PowerShell.Utility\Compare-Object', [System.Management.Automation.CommandTypes]::Cmdlet)
            ###########################################################
            if ($MaxDepth -eq -1 -or $__Depth -le $MaxDepth) {
                #check for array of objects or custom class
                if (($ReferenceObject -is [array]) -and ($ReferenceObject[0] -is [PSCustomObject] -or $null -eq $ReferenceObject[0].GetType().Namespace)) {
                    $__Depth++
                    for ($i = 0; $i -lt $ReferenceObject.Count; $i++) {
                        if ($PassThru){
                             Compare-Object $ReferenceObject[$i] $DifferenceObject[$i] -__Property ($__Property + "[$i]") -__Depth $__Depth -IncludeEqual:$IncludeEqual -ExcludeDifferent:$ExcludeDifferent -PassThru:$PassThru
                        }
                        else{
                             Compare-Object $ReferenceObject[$i] $DifferenceObject[$i] -__Property ($__Property + "[$i]") -__Depth $__Depth -IncludeEqual:$IncludeEqual -ExcludeDifferent:$ExcludeDifferent -Compact:$Compact
                        }
                    }
                }
                elseif ($ReferenceObject -is [PSCustomObject] -or $null -eq $ReferenceObject.GetType().Namespace) {
                    $__Depth++
                    foreach ($prop in $ReferenceObject.PSObject.properties.name) {
                        $newProp = $prop
                        if ($__Property) {
                            $newProp = $__Property + '.' + $prop
                        }
                        #recurse
                        # handle ref. or diff. objects equal null
                        $refValue = $ReferenceObject.$prop
                        $diffValue = $DifferenceObject.$prop
                        if ($Null -eq $refValue) {
                            $refValue = ''
                        }
                        if ($null -eq $diffValue) {
                            $diffValue = ''
                        }
                        if ($PassThru){
                            Compare-Object $refValue $diffValue  -__Property $newProp -__Depth $__Depth -IncludeEqual:$IncludeEqual -ExcludeDifferent:$ExcludeDifferent -PassThru:$PassThru                      
                        }
                        elseif ($Compact){
                            Compare-Object $refValue $diffValue  -__Property $newProp -__Depth $__Depth -IncludeEqual:$IncludeEqual -ExcludeDifferent:$ExcludeDifferent -Compact:$Compact
                        }
                        else{
                            Compare-Object $refValue $diffValue  -__Property $newProp -__Depth $__Depth -IncludeEqual:$IncludeEqual -ExcludeDifferent:$ExcludeDifferent                  
                        }
                    }
                }
                else {
                    if($PSBoundParameters['__Depth']){ 
                        $null = $PSBoundParameters.Remove('__Depth')
                    }
                    if($PSBoundParameters['MaxDepth']){ 
                        $null = $PSBoundParameters.Remove('MaxDepth')
                    }
                    if($PSBoundParameters['__Property']){ 
                        $prop = $PSBoundParameters['__Property']
                        $null = $PSBoundParameters.Remove('__Property')
                    }
                    if($PSBoundParameters['Compact']){ 
                        $compact = $PSBoundParameters['Compact']
                        $null = $PSBoundParameters.Remove('Compact')
                    }
                    $scriptCmd = { & $wrappedCmd @PSBoundParameters }
                    if ($prop) {
                        $scriptCmd = {
                            & $wrappedCmd @PSBoundParameters  |
                            Select-Object @{n = 'Property'; e = { $prop } }, @{n = 'Value'; e = { $_.InputObject } }, SideIndicator 
                        }
                        if ($compact) {
                            $scriptCmd = {
                                & $wrappedCmd @PSBoundParameters  |
                                Select-Object @{n = 'Property'; e = { $prop } }, @{n = 'Value'; e = { $_.InputObject } }, SideIndicator |
                                Group-Object Property,{$_.SideIndicator -eq '=='} | ForEach-Object {
                                    if ($_.Group[0].SideIndicator -eq '==') {
                                        [PSCustomObject][Ordered]@{
                                            Property        = $_.Group.Property
                                            ReferenceValue  = $_.Group.Value
                                            DifferenceValue = $_.Group.Value
                                        }
                                    }
                                    else {
                                        [PSCustomObject][Ordered]@{
                                            Property        = $_.Group[0].Property
                                            ReferenceValue  = ($_.Group.where{ $_.SideIndicator -eq '<=' }).Value
                                            DifferenceValue = ($_.Group.where{ $_.SideIndicator -eq '=>' }).Value
                                        }
                                    }
                                }
                            }
                        }
                    }
                    $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
                    $steppablePipeline.Begin($PSCmdlet)
                }
            }
            #############################################################
            
        } catch {
            throw
        }
    }

    process
    {
        try {
            $steppablePipeline.Process($_)
        } catch {
            
        }
    }

    end
    {
        try {
            $steppablePipeline.End()
        } catch {
            
        }
    }
}