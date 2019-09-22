function Diff-Excel {
	 <#
    .SYNOPSIS
        PowerShell wrapper for ExcelConmpare a tool to diff excel files
    .DESCRIPTION
        PowerShell wrapper for ExcelCompare.
	    Generates row/column wise diffs conmparing two .xlsx files
        This function requires excel_cmp.bat
        https://github.com/na-ka-na/ExcelCompare
        Instructions:
        - Download Excel Compare from https://github.com/na-ka-na/ExcelCompare/releases
        - extract and update location to exePath in line 57
    .PARAMETER XLSX1
		Path to the first xlsx file to compare.
	.PARAMETER XLSX2
	    Path to the second xlsx file to compare
    .PARAMETER Ignore1
	    See examples. Ignore pattern for first file <sheet-name>:<row-ignore-spec>:<column-ignore-spec>:<cell-ignore-spec> cell satisfying any ignore spec in the sheet (row, col, or cell) will be ignored in diff.
    .PARAMETER Ignore2
        See examples. Ignore pattern for second file <sheet-name>:<row-ignore-spec>:<column-ignore-spec>:<cell-ignore-spec> cell satisfying any ignore spec in the sheet (row, col, or cell) will be ignored in diff
    .EXAMPLE
        #Diff all cells
    	Diff-Excel 1.xlsx 2.xlsx
    .EXAMPLE
        #Ignore Sheet1 in 1.xlsx
    	Diff-Excel 1.xlsx 2.xlsx -Ignore1 Sheet1
    .EXAMPLE
        #Ignore Sheet1 in both
        Diff-Excel 1.xlsx 2.xlsx -Ignore1 Sheet1 -Ignore2 Sheet1
    .EXAMPLE
        #Ignore column A in both
        Diff-Excel 1.xlsx 2.xlsx -Ignore1 'Sheet1::A' -Ignore2 'Sheet1::A'
    .EXAMPLE
        #Ignore column A across all sheets in both
        Diff-Excel 1.xlsx 2.xlsx -Ignore1 '::A' -Ignore2 '::A'
    .EXAMPLE
        #Ignore columns A,D and rows 1-5, 20-25
        Diff-Excel 1.xlsx 2.xlsx -Ignore1 'Sheet1:1-5,20-25:A,D' -Ignore2 'Sheet1:1-5,20-25:A,D'
    .EXAMPLE
        #Ignore columns A,D and rows 1-5, 20-25 and cells F6,H8
        Diff-Excel 1.xlsx 2.xlsx -Ignore1 'Sheet1:1-5,20-25:A,D:F6,H8'
    .LINK
        https://github.com/na-ka-na/ExcelCompare
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory,Position=0)]
        $XLSX1,
        [Parameter(Mandatory,Position=1)]
        $XLSX2,
        [Parameter(Position=2)]
        $Ignore1,
        [Parameter(Position=3)]
        $Ignore2

    )
    $exePath = 'C:\Scripts\tools\ExcelCompare\bin\excel_cmp.bat'
    

    if (!(Test-Path $exePath)){
        $message = @'     
This function requires excel_cmp.bat
https://github.com/na-ka-na/ExcelCompare
Instructions:
- Download Excel Compare from https://github.com/na-ka-na/ExcelCompare/releases
- extract and update location to exePath in line 57
'@
        Write-Warning $message
        exit
    }
    $parameters = New-Object System.Collections.ArrayList
    $null = $parameters.Add($(Resolve-Path $XLSX1).Path)
    $null = $parameters.Add($(Resolve-Path $XLSX2).Path)
    $null = $parameters.Add("--ignore1")
    $null = $parameters.Add("$Ignore1")
    $null = $parameters.Add("--ignore2")
    $null = $parameters.Add("$Ignore2")
    
    $out = & $exePath $XLSX1 $XLSX2 $parameters
    $htWB=@{
        WB1=$XLSX1
        WB2=$XLSX2
    }
    foreach ($line in $out){
        if ($line -clike "*-- DIFF --*"){
            break
        }
        if ($line.StartsWith('DIFF')){
            $result = $line -split '\s+'
            $address = $result[3] 
            [PSCustomObject]@{
                Type='Change'
                File=''
                Sheet=$address.Split('!')[0]
                Column=[regex]::Match( $address.Split('!')[1],'([A-Z])+').value
                Row=[regex]::Match( $address.Split('!')[1],'(\d)+').value
                Old=$result[-1]
                New=$result[-3]
            }
        }
        elseif ($line.StartsWith('EXTRA')){
            $result = $line -split '\s+'
            $address = $result[4] 
            [PSCustomObject]@{
                Type='Add'
                File=$htWB.$($result[3])
                Sheet=$address.Split('!')[0]
                Column=[regex]::Match( $address.Split('!')[1],'([A-Z])+').value
                Row=[regex]::Match( $address.Split('!')[1],'(\d)+').value
                Old=''
                New=$result[-1]
            }
        }
    
    }
 }
