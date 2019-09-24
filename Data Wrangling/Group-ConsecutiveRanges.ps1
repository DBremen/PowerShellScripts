function Group-ConsecutiveRanges{
     <#    
      .SYNOPSIS
        Given an integer array with numbers, return groups of consecutive ranges.
      .DESCRIPTION
        Makes use of the fact that for consecutive numbers (IndexOf(element) - element) is the same.
      .PARAMETER IntArray
        An array of integers to group by consecutive ranges.
      .EXAMPLE
        7,2,8,5,17,3,4,20,15,9,18,1,16 | Group-ConsecutiveRanges
    #>
    [CmdletBinding()]
    param( 
        [Parameter(Mandatory, 
            ValueFromPipeline,
            Position = 0)]   
        [int[]]$IntArray
    )
    END{
        $temp = $Input| sort -Unique 
        $temp | group {$temp.IndexOf($_) - $_} |
            select Count, @{n='Name';e={
		        "$($_.Group[0])-$($_.Group[-1])"
	        }},Group
    }
}