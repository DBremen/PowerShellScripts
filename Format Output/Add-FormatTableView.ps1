function Add-FormatTableView {
    <#    
    .SYNOPSIS
        Function to add a Format Table View for a type
    .DESCRIPTION
        Format views are living in the *format.ps1xml files those define named sets of properties which can be used with the Format-* cmdlets
	.PARAMETER InputObject
		Objects that determine the type(s) the view is added to
	.PARAMETER Label
		Optionally for every property a label can be speciffied. For every property that does not have a respective label the property name is used as the label for the column
    .PARAMETER Width
        Optionally for every property the width can be speciffied. The default value for Width is 20. For every property that does not have a respective width specified, the first value is used.
	.PARAMETER Alignment
        Optionally for every property the alignment can be speciffied. The default value for Alignment is undefined. For every property that does not have a respective alignment specified, the first value is used.
	.PARAMETER ViewName
        The name for the View, that is being created.
    .OUTPUTS
        The function returns the path of the *format.ps1xml for the type, that the format table view is being created for.
    .EXAMPLE
		$fileName = Get-Process | Add-FormatTableView -Label ProcName, PagedMem, PeakWS -Property 'Name', 'PagedMemorySize', 'PeakWorkingSet' -Width 40 -Alignment Center -ViewName RAM
        Get-Process | select -First 3 | Format-Table -View RAM
        #add this to the profile to have the format view available in all sessions
        #Update-FormatData -PrependPath $fileName
    .EXAMPLE
        dir | Add-FormatTableView -Property 'Name', 'LastWriteTime', 'CreationTime' -ViewName Testing
        dir | Format-Table -View Testing
    .EXAMPLE
        #using the default table view name ('TableView') to modify custom object default output
        #create a custom object array
        $arr = @()
        $obj = [PSCustomObject]@{FirstName='Jon';LastName='Doe'}
        #add a custom type name to the object
        $typeName = 'YouAreMyType'
        $obj.PSObject.TypeNames.Insert(0,$typeName)
        $arr += $obj
        $obj = [PSCustomObject]@{FirstName='Pete';LastName='Smith'}
        $obj.PSObject.TypeNames.Insert(0,$typeName)
        $arr += $obj
        $obj.PSObject.TypeNames.Insert(0,$typeName)
        #add a default table format view
        $arr | Add-FormatTableView -Label 'First Name', 'Last Name' -Property FirstName, LastName -Width 30 -Alignment Center
        $arr 
        #when using the object further down in the pipeline the property name must be used
        $arr  | where "LastName" -eq 'Doe'
    .LINK
        https://powershellone.wordpress.com/2015/03/09/powershell-format-table-views/
    .LINK
        Get-FormatView
    #>
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline=$true,Mandatory=$true)]
        $InputObject,

        [Parameter(Position=0)]   
        [string[]]$Label,

        [Parameter(Mandatory=$true,Position=1)] 
        [string[]]$Property,

        [Parameter(Position=2)] 
        [int[]]$Width=20,

        [Parameter(Position=3)] 
        [Management.Automation.Alignment[]]$Alignment = 'Undefined',

        [Parameter(Position=4)] 
        $ViewName = 'TableView'
    )
    $typeNames = $input | Group-Object { $_.PSTypeNames[0] } -NoElement | Select-Object -ExpandProperty Name
    $table = New-Object Management.Automation.TableControl
    $row = New-Object Management.Automation.TableControlRow
    $index = 0
    foreach ($prop in $property){
        if ($Label.Count -lt $index+1){
            $currLabel = $prop
        }
        else{
            $currLabel = $Label[$index]
        }
        if ($Width.Count -lt $index+1){
            $currWidth = @($Width)[0]
        }
        else{
            $currWidth = $Width[$index]
        }
        if ($Alignment.Count -lt $index+1){
            $currAlignment = @($Alignment)[0]
        }
        else{
            $currAlignment = $Alignment[$index]
        }
        $col = New-Object Management.Automation.TableControlColumn $currAlignment, (New-Object Management.Automation.DisplayEntry $prop, 'Property')
        $row.Columns.Add($col)
        $header = New-Object Management.Automation.TableControlColumnHeader $currLabel, $currWidth, $currAlignment
        $table.Headers.Add($header)
        $index++
    }
    $table.Rows.Add($row)
    $view = New-Object System.Management.Automation.FormatViewDefinition $ViewName, $table
    foreach ($typeName in $typeNames){
        $typeDef = New-Object System.Management.Automation.ExtendedTypeDefinition $TypeName
        $typeDef.FormatViewDefinition.Add($view)
        [Runspace]::DefaultRunspace.InitialSessionState.Formats.Add($typeDef)
    }
    $xmlPath = Join-Path (Split-Path $profile)  ($ViewName + '.format.ps1xml')
    Get-FormatData -TypeName $TypeNames | Export-FormatData -Path $xmlPath
    Update-FormatData -PrependPath $xmlPath
    $xmlPath
}



