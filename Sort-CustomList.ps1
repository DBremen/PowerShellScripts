function Sort-CustomList{
     <#    
    .SYNOPSIS
        Sort data using a custom list in PowerShell.
    .DESCRIPTION
        Sort data based on a custom list similar to the functionality provided in Excel.
	.PARAMETER InputObject
		The object or collection of objects to be sorted.
	.PARAMETER CustomList
		The custom list that determines the sort order.
    .PARAMETER PropertyName
		The name of the property that should be sorted.
    .PARAMETER AdditionalProperty
		One or more property names to be sorted against. 
	.EXAMPLE
		$CustomList = 'iexplore', 'excel', 'notepad' 
        Get-Process | Sort-CustomList $CustomList Name
    .LINK
        https://powershellone.wordpress.com/2015/07/30/sort-data-using-a-custom-list-in-powershell/
    #>
    param(
    [Parameter(ValueFromPipeline=$true)]$InputObject,
    [Parameter(Position=0)]$CustomList,
    [Parameter(Position=1)]$PropertyName,
    [Parameter(Position=2)]$AdditionalProperty
    )
    $properties=,{
        $rank=$CustomList.IndexOf($($_."$PropertyName".ToLower()))
        if($rank -ne -1){$rank}
        else{[System.Double]::PositiveInfinity}
    } 
    #Ensure values of $PropertyName that are not part of the custom list are sorted alphabetically after the custom list.
    $properties += $PropertyName
    if ($AdditionalProperty){
        foreach ($prop in $AdditionalProperty){
            $properties += $AdditionalProperty
        }
    }
    $Input | Sort-Object $properties
}
