function Get-View{
    [CmdletBinding()]
    param( 
    [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true,
                   Position=0)]   
    $TypeName
    )
        $typeFiles = Get-ChildItem $psHome -Filter *types.ps1xml
        $formatFiles = dir $psHome -Filter *.format.ps1xml
        if ($TypeName -isnot [string]){
            $TypeName = $Input[0].PSObject.TypeNames[0]
        }
        #get the propertySets
        $typefiles | 
            Select-Xml //PropertySet | 
            where {
                $_.Node.ParentNode.ParentNode.Name -ne 'PSStandardMembers' -and (
                (-not $typeName) -or ($typename -contains $_.Node.ParentNode.ParentNode.Name)
                )
            }  | 
            select @{n='Name'; e= {$_.Node.Name }},
               @{ n='Type'; e={'PropertySet'}},
               @{ n='Cmdlet'; e={'Select-Object'}}

        #get the format views
        $formatTypes = $formatFiles | 
            Select-Xml //ViewSelectedBy/TypeName | 
            where { $_.Node.'#text' -eq $TypeName } 
       
            foreach ($ft in $formatTypes) {
                $formatType = $ft.Node.SelectSingleNode('../..')
                $props = $formatType.Name, ($formatType | Get-Member -MemberType Property | where Name -like '*Control').Name
                $formatType | select @{n='Name';e={$props[0]}}, 
                                     @{n='Type';e={'Format View'}},
                                     @{n='Cmdlet';e={'Format-' + $props[1].Replace('Control','')}}


        }
}
 


