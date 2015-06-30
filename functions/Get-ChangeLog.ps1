function Get-ChangeLog($referenceObject,$differenceObject,$identifier){
    $props = $referenceObject | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name
    $diff = Compare-Object $referenceObject $differenceObject -Property $props -PassThru | 
        group $identifier
    #capture modifications
    $today = (Get-Date).ToShortDateString()
    $modifications = ($diff | where Count -eq 2).Group | group $identifier
    foreach ($modification in $modifications){
        #compare properties of each group
        foreach ($prop in $props){
            if ($modification.Group[0].$prop -ne $modification.Group[1].$prop){
                $output = $modification.Group | where {$_.SideIndicator -eq '<='} |
                    select "Date", $identifier, "ChangeType", "ChangedProperty", "From","To"
                $output.Date = $today
                $output.ChangeType = "Modified"
                $output.ChangedProperty = $prop
                $output.From = ($modification.Group | where {$_.SideIndicator -eq '<='}).$prop
                $output.To = ($modification.Group | where {$_.SideIndicator -eq '=>'}).$prop
                $output
            }
        }
    }
    #capture removals and additions
    $removalAdditions=$groupedDiff = ($diff | where Count -eq 1).Group | group $identifier
    foreach ($removalAddition in $removalAdditions){
        $ht = [ordered]@{}
        $ht.Add('Date',$today)
        $ht.Add($identifier,$removalAddition.Name)
        $ht.Add('ChangeType','')
        $ht.Add('ChangedProperty','')
        $ht.Add('From','')
        $ht.Add('To','')
        #addition
        if ($removalAddition.Group.SideIndicator -eq "=>"){
            $ht.ChangeType = 'Added'
        }
        #removal
        else{
            $ht.ChangeType = 'Removed'
        }
        New-Object PSObject -Property $ht
    }
}
$referenceObject=@'
ID,Name,LastName,Town
1,Peter,Peterson,Paris
2,Mary,Poppins,London
3,Dave,Wayne,Texas
4,Sandra,Mulls,Berlin
'@ | ConvertFrom-CSV
$differenceObject=@'
ID,Name,LastName,Town
1,Peter,Peterson,Paris
2,Mary,Poppins,Cambridge
5,Bart,Simpson,Springfield
4,Sandra,Mulls,London
'@ | ConvertFrom-CSV

Get-ChangeLog $referenceObject $differenceObject ('ID') | ft -AutoSize

