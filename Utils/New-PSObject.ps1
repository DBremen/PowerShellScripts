function new-pscustomobject ([string[]] $names , [object[]] $values ){
	$obj = 1| select-object $names
	0..($names.length-1) | % { 
		$obj.$($names[$_]) = $values[$_] 
	}
	$obj
}

function New-PSObject{
     <#    
      .SYNOPSIS
        Helper function to create PSCustomObjects based on array of names and array of properties.
      .DESCRIPTION
        Enables rapid creation of PSCustomObjects
      .PARAMETER PropertyNames
        An array of property names
      .PARAMETER Values
        The values to be assigned to the properties in the same order as the property names
      .EXAMPLE
        $props= echo City Country CurrencySymbol
        $result = & {
            new-psobject $props Berlin Germany EUR
            new-psobject $props Zurich Switzerland CHF
        }
        $result
    #>
    [CmdletBinding()]
    param( 
        [Parameter(Mandatory,
            Position = 0)]   
            [array]$PropertyNames,
            [Parameter(Mandatory,ValueFromRemainingArguments,
            Position = 1)]$Values
    )
    $ht = [ordered]@{}
    $i = 0
    foreach ($prop in $PropertyNames){
        $ht.Add($prop,$Values[($i++)])
    }
    [PSCustomObject]$ht
}


