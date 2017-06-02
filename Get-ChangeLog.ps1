function Get-ChangeLog{
    <#
        .SYNOPSIS
            Comparing two objects or .csv files column by column.
        
        .DESCRIPTION
		    Compare objects showing which property has changed along with the old and new values
		
        .PARAMETER ReferenceObject
            Object that represents the reference object for the comparison

        .PARAMETER DifferenceObject
            Object that represents the difference object for the comparison
	
	    .PARAMETER Identifier
		    A property (can be also multiple properties) that acts as a unique identifier for the object.
            This is in order to be able to know what to compare to across both objects.
		
        .EXAMPLE  
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
            Get-ChangeLog $referenceObject $differenceObject ('ID') | Format-Table -AutoSize
		.LINK
            https://powershellone.wordpress.com/2015/06/30/comparing-two-objects-or-csv-files-column-by-column/
    #>
    [CmdletBinding()] 
	param(
        $ReferenceObject,
        $DifferenceObject,
        $Identifier

    )
    $props = $ReferenceObject | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name
    $diff = Compare-Object $ReferenceObject $DifferenceObject -Property $props -PassThru | 
        Group-Object $Identifier
    #capture modifications
    $today = (Get-Date).ToShortDateString()
    $modifications = ($diff | Where-Object Count -eq 2).Group | Group-Object $Identifier
    foreach ($modification in $modifications){
        #compare properties of each group
        foreach ($prop in $props){
            if ($modification.Group[0].$prop -ne $modification.Group[1].$prop){
                $output = $modification.Group | Where-Object {$_.SideIndicator -eq '<='} |
                    Select-Object (Write-Output Date $Identifier ChangeType ChangedProperty From To)
                $output.Date = $today
                $output.ChangeType = "Modified"
                $output.ChangedProperty = $prop
                $output.From = ($modification.Group | Where-Object {$_.SideIndicator -eq '<='}).$prop
                $output.To = ($modification.Group | Where-Object {$_.SideIndicator -eq '=>'}).$prop
                $output
            }
        }
    }
    #capture removals and additions
    $removalAdditions=$groupedDiff = ($diff | Where-Object Count -eq 1).Group | Group-Object $Identifier
    foreach ($removalAddition in $removalAdditions){
        $ht = [ordered]@{}
        $ht.Add('Date',$today)
        $i = 0
        foreach ($id in $Identifier){
            $ht.Add($id,$removalAddition.Name.Split(',')[$i])
            $i++
        }
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




