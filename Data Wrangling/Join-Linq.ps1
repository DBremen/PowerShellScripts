function Join-Linq {
    <#    
      .SYNOPSIS
        Performs an inner join of two object arrays based on a common column.
      .DESCRIPTION
        This is based of a solution I found on Technet. See Link. 
      .PARAMETER FirstArray
        The first array to join.
      .PARAMETER SecondArray
        The second array to join.
      .PARAMETER FirstKey
        The property from the first array to join based upon.
      .PARAMETER SecondKey
        The property from the second array to join based upon. 
        Defaults to the value provided for FirstJoinProperty.
      .Link
        https://social.technet.microsoft.com/Forums/en-US/5fb26b70-ed2d-462f-a38e-43b61adba2b1/merge-two-csvs-with-a-common-column?forum=winserverpowershell
      .LINK
        https://docs.microsoft.com/en-us/dotnet/api/system.linq.enumerable.join?view=netframework-4.8
      .EXAMPLE
        #build two object arrays for testing
        $Accounts = @'
AccountID,AccountName
1,Contoso
2,Fabrikam
3,LitWare
'@ | ConvertFrom-Csv

        $Users = @'
UserID,UserName
1,Adams
1,Miller
2,Nalty
3,Bob
4,Mary
'@ | ConvertFrom-Csv
        #perform an inner join based on the id columns
        Join-Linq $Accounts $Users 'AccountId' 'UserId'
        #output
        # AccountID AccountName UserID UserName
        # --------- ----------- ------ --------
        # 1         Contoso     1      Adams   
        # 1         Contoso     1      Miller
        # 2         Fabrikam    2      Nalty   
        # 3         LitWare     3      Bob
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)] 
        $FirstArray,
        [Parameter(Mandatory, Position = 1)] 
        $SecondArray,
        [Parameter(Mandatory, Position = 2)] 
        $FirstKey,
        [Parameter(Position = 3)] 
        $SecondKey
    )
    #functions to get the key columns to make the join based upon.
    [System.Func[System.Object, string]]$firstKeyFunc = { param($first) $first."$($FirstKey)" }
    [System.Func[System.Object, string]]$secondKeyFunc = { param($second) $second."$($SecondKey)" }
    #function to build the joined object
    [System.Func[System.Object, System.Object, System.Object]]$query = {
        param($first, $second) 
        $props = ($second | gm -MemberType NoteProperty).Name 
        $ht = [ordered]@{ }
        $first.psobject.properties | Foreach { $ht[$_.Name] = $_.Value }
        foreach ($prop in $props) {
            $ht.Add($prop, $second."$($prop)")
        }
        [PSCustomObject]$ht
    }
    #carry out the join
    [System.Linq.Enumerable]::ToArray([System.Linq.Enumerable]::Join($FirstArray, $SecondArray, $firstKeyFunc, $secondKeyFunc, $query))
}