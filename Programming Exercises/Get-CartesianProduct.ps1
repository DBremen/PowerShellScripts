function Get-CartesianProduct {
    <#    
      .SYNOPSIS
        Get the cartesian product for an object that contains array properties. See example.
      .DESCRIPTION
        Given an object that contains properties that contain arrays. The function will build a cartesian product returning each possible combination
        given the array entries (see Example)
	  .PARAMETER InputObject
        The object(s) that is used to build the cartesian product
      .PARAMETER CurrPropIndex
        Just used internally for recursive calls of the function when iterating through the properties
      .EXAMPLE
        # Build an array of order objects with array entries
        function New-Order ($Name,$Product,$Preference){
            [PSCustomObject][Ordered]@{Name=$Name;Product=$Product;Preference=$Preference}
        }
        $orders = @()
        $orders += New-Order Peter Product1 'Fast Delivery'
        $orders += New-Order Nigel ('Product1', 'Product2') ('Fast Delivery', 'Product Quality')
        $orders += New-Order Carmen ('Product3', 'Product5') Support
        $orders += New-Order Rene Product2 ('Price', 'Fast Delivery')
        # Get the cartesian product of the order objects array, splitting each of the possible combinations from the array properties
        # into a separate object
        $orders | Get-CartesianProduct
    #>
    [CmdletBinding()]
    param( 
        [Parameter(Mandatory, 
            ValueFromPipeline,
            Position = 0)]   
        $InputObject, 
         [Parameter(Position = 1)] $CurrPropIndex = 0
    )
    PROCESS{
        $props = $InputObject.PSObject.Properties.Name
        if ( $CurrPropIndex -eq 0) {
            $propIndices = New-Object int[] $props.Length
        }
        $valIndex = 0
        #walk through the items in the current property
        foreach ($prop in @($InputObject."$($props[$CurrPropIndex])")){
            #add the index to the indices for the current property
            $propIndices[$CurrPropIndex] = $valIndex
            $valIndex++
            #if we reach the end of the row
            if ( $CurrPropIndex -eq ($props.Length - 1)) {
                $cartesianSet = [ordered]@{}
                $propIndex = 0
                foreach ($prop in $props) {
                    #add the items to the result set based on the collected indices
                    $cartesianSet.Add($prop,@($InputObject."$prop")[$propIndices[$propIndex]])
                    $propIndex++
                }
                [PSCustomObject]$cartesianSet 
            } 
            #do this for every property
            else {
                Get-CartesianProduct $InputObject ( $CurrPropIndex + 1)
            }
        }
    }
}
 