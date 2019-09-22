function Add-LookupColumn {
     <#    
      .SYNOPSIS
        Funciton to use Excel's vlookup through PowerShell. Requires Excel to be installed.
      .DESCRIPTION
        Uses Excel's vlookup to return matching values for a column (property) in another table(object of arrays)
        based on a Lookup column (property). Property values that have no matching entry in the LookupTable will 
        get a value of -1.
      .PARAMETER Table
        The array of objects (Table), that contains the values to lookup and that the new column will be added to. 
        based on matching values in the LookupTable.
      .PARAMETER LookupTable
        The array of objects (Table), that contains the matching values.
      .PARAMETER LookupProperty
        The property to match both array of objects based upon.
      .PARAMETER ReturnProperty
        The property to add to the table based on the matches from the lookupTable
      .EXAMPLE
        $test = @'
Name,LastName
Dirk,Smith
Carol,Carlson
Gisela,Knight
Aidan, Gray
'@ | ConvertFrom-Csv

$test2 = @'
Name,City
Dirk,Dublin
Carol,London
Gisela,Cologne
'@ | ConvertFrom-Csv
        #Add a new column City to $test based on matching Names in $test2
        vLookup $test $test2 Name City
      .LINK
        https://support.office.com/en-us/article/vlookup-function-0bbc8083-26fe-4963-8ab8-93a18ad188a1
    #>
    [CmdletBinding()]
    [Alias('vLookup')]
    param( 
        [Parameter(Mandatory, Position = 0)]$Table,
        [Parameter(Mandatory,Position = 1)]$LookupTable,
        [Parameter(Mandatory,Position = 2)]$LookupProperty,
        [Parameter(,Position = 3)]$ReturnProperty 
    )
    $xl = New-Object -ComObject Excel.Application
    $wf   = $xl.WorksheetFunction
    $Table = $Table | Add-Member -MemberType NoteProperty -Name $ReturnProperty -Value -1 -PassThru
    $i = 0
    $wf.Match($Table.$LookupProperty,$LookupTable.$LookupProperty,0) | foreach{
        if ($_ -gt 0){
            $Table[$i].$ReturnProperty = $LookupTable[$_-1].$ReturnProperty
        }
        $i++
    }
    $Table
    $xl.Quit()
}
