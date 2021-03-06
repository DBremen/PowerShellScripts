function Get-LineNumber {
     <#    
      .SYNOPSIS
        Retrieve specific Linenumber(s) from afile.
      .DESCRIPTION
        Retrieve specific Linenumber(s) from a file.
      .PARAMETER Path
        The path to the file to get the line(s) from. Should be provided by pipeline for ease of use.
      .PARAMETER LineNumber
        The line number(s) to retrieve from the file. Multiple numbers can be provided as an array of integers.
      .EXAMPLE
        dir .\test.txt | Get-LineNumber 1,3,4
    #>
    [CmdletBinding()]
    param( 
        [Parameter(Mandatory, 
            ValueFromPipeline,
            ValueFromPipelineByPropertyName)]  
        [Alias('FullName')] 
         $Path, 
        [Parameter(Mandatory,Position = 0)] $LineNumber
    )
	$arrList = New-Object System.Collections.ArrayList($null)
	$arrList.AddRange(( $LineNumber | sort))
    $reader = New-Object 'System.IO.StreamReader'( $Path, $true)
	$arrIndex=0
    try{
        while (($line = $reader.ReadLine()) -ne $null -and $arrList.Count){
            if ($currentIndex++ -eq $arrList[0]-1){
                $line
				$arrList.Remove($arrList[0])
				$arrIndex++
            }
        }
    }
    finally{
        $reader.Close();
    }
    return $null;
}