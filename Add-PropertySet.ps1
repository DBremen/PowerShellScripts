function Add-PropertySet{
     <#    
    .SYNOPSIS
        Function to create property sets
    .DESCRIPTION
        Property sets are named groups of properties for certain types that can be used through Select-Object.
        The function adds a new property set to a type via a types.ps1xml file.
	.PARAMETER InputObject
		The object or collection of objects where the property set is added
	.PARAMETER PropertySetName
		The name of the porperty set
	.EXAMPLE
		$fileName = dir | Add-PropertySet Testing ('Name', 'LastWriteTime', 'CreationTime')
        dir | Get-Member -MemberType PropertySet
        dir | select Testing
        #add this to the profile to have the property set available in all sessions
        Update-TypeData -PrependPath $fileName
	.EXAMPLE
		Get-Process | Add-PropertySet RAM ('Name', 'PagedMemorySize', 'PeakWorkingSet')
        Get-Process | select RAM
    .LINK
        https://powershellone.wordpress.com/2015/03/06/powershell-propertysets-and-format-views/
    #>
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline=$true,Mandatory=$true)]
        $InputObject,
    
        [Parameter(Mandatory=$true,Position=0)]
        $PropertySetName,

        [Parameter(Mandatory=$true,Position=1)]
        $properties
    )
    $propertySetXML = "<Types>`n"
    $groupTypes = $input | Group-Object { $_.PSTypeNames[0] } -AsHashTable
    foreach ($entry in $groupTypes.GetEnumerator()) {
        $typeName = $entry.Key
        $propertySetXML += @"
    <Type>
        <Name>$typeName</Name>
        <Members>
            <PropertySet>
                <Name>$PropertySetName</Name>
                <ReferencedProperties>
                    $($properties | foreach { 
                        "<Name>$_</Name>"    
                    })
                </ReferencedProperties>
            </PropertySet>
        </Members>
    </Type>
"@
    } 
    $propertySetXML += "`n</Types>"
    $xmlPath = Join-Path (Split-Path $profile.CurrentUserCurrentHost)  ($PropertySetName + '.types.ps1xml')
    ([xml]$propertySetXML).Save($xmlPath)    
    Update-TypeData -PrependPath $xmlPath
    $xmlPath
}

