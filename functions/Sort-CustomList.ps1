function Sort-CustomList{
    param(
    [Parameter(ValueFromPipeline=$true)]$collection,
    [Parameter(Position=0)]$customList,
    [Parameter(Position=1)]$propertyName,
    [Parameter(Position=2)]$additionalProperty
    )
    $properties=,{
        $rank=$customList.IndexOf($($_."$propertyName".ToLower()))
        if($rank -ne -1){$rank}
        else{[System.Double]::PositiveInfinity}
    } 
    if ($additionalProperty){
        $properties+=$additionalProperty
    }
    $Input | sort $properties
    
  
}
$customList = 'iexplore', 'excel', 'notepad' 
Get-Process | Sort-CustomList $customList Name Name
