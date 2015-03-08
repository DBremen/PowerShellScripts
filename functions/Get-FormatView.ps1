function Get-FormatView{
    [CmdletBinding()]
    param( 
    [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true,
                   Position=0)]   
    $TypeName
    )
        $formatFiles = dir $psHome -Filter *.format.ps1xml
        if ($TypeName -isnot [string]){
            $TypeName = $Input[0].PSObject.TypeNames[0]
        }
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
 
 gps | Get-FormatView



