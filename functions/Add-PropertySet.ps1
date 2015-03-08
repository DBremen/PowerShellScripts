function Add-PropertySet{
     <#    
    .SYNOPSIS
        Function to create property sets
    .DESCRIPTION
        Property sets are named groups of properties for certain types that can be used through Select-Object.
        The function adds a new property set to a type via a types.ps1xml file.
	.PARAM inputObject
		The object or collection of objects where the property set is added
	.PARAM propertySetName
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
    #>
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline=$true,Mandatory=$true)]
        $inputObject,
    
        [Parameter(Mandatory=$true,Position=0)]
        $propertySetName,

        [Parameter(Mandatory=$true,Position=1)]
        $properties
    )
    $propertySetXML = "<Types>`n"
    $groupTypes = $input | group { $_.PSTypeNames[0] } -AsHashTable
    foreach ($entry in $groupTypes.GetEnumerator()) {
        $typeName = $entry.Key
        $fileNamePrefix += $typeName
        $propertySetXML += @"
    <Type>
        <Name>$typeName</Name>
        <Members>
            <PropertySet>
                <Name>$propertySetName</Name>
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
    $xmlPath = Join-Path (Split-Path $profile.CurrentUserCurrentHost)  ($fileNamePrefix + '.types.ps1xml')
    ([xml]$propertySetXML).Save($xmlPath)    
    Update-TypeData -PrependPath $xmlPath
    $xmlPath
}

