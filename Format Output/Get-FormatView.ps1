function Get-FormatView {
    <#    
        .SYNOPSIS
            Function to get the format views for a particular type.
        .DESCRIPTION
            Format views are defined inside the *format.ps1xml files and represent named sets of properties per type which can be used with any of the Format-* cmdlets. 
            Retrieving the format views for a particular type can be accomplished by pulling out the information from the respective XML files using this function.
	    .PARAMETER Type
		    Type to get the format views for.
	    .EXAMPLE
		    Get-Process | Get-FormatView | Format-Table -Auto
        .LINK
            https://powershellone.wordpress.com/2015/03/09/powershell-format-table-views/
        .LINK
            Add-FormatTableView
    #>
    [CmdletBinding()]
    param( 
        [Parameter(Mandatory = $true, 
            ValueFromPipeline = $true,
            Position = 0)]   
        $TypeName
    )
    $formatFiles = dir $psHome -Filter *.format.ps1xml
    if ($TypeName -isnot [string]) {
        $TypeName = $Input[0].PSObject.TypeNames[0]
    }
    $formatTypes = $formatFiles | 
    Select-Xml //ViewSelectedBy/TypeName | 
    where { $_.Node.'#text' -eq $TypeName } 
       
    foreach ($ft in $formatTypes) {
        $formatType = $ft.Node.SelectSingleNode('../..')
        $props = $formatType.Name, ($formatType | Get-Member -MemberType Property | where Name -like '*Control').Name
        $formatType | select @{n = 'Name'; e = { $props[0] } }, 
        @{n = 'Type'; e = { 'Format View' } },
        @{n = 'Cmdlet'; e = { 'Format-' + $props[1].Replace('Control', '') } }


    }
}



