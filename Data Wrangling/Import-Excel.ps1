function Import-Excel {
    <#    
        .SYNOPSIS
            Import data from Excel using Excel's COM interface.
        .DESCRIPTION
            Converts the Excel file to a temporary .csv file and imports the same using Import-Csv.
            Works only with default delimiter since no paramenter is implemented so far.
	    .PARAMETER FullName
            The Path to the Excel file to be imported.
        .PARAMETER SheetName
            The name of the sheet to be imported from the Excel file.
        .PARAMETER SheetNumber
            The number of the sheet to be imported from the Excel file.
        .EXAMPLE
            $excelFile | Import-Excel 
    #>
    [CmdletBinding()]
    param( 
        [Parameter(Mandatory, 
            ValueFromPipeline, ValueFromPipelineByPropertyName,
            Position = 0)]   
        $FullName,
        [Parameter(Mandatory, ParameterSetName = 'ByName')] 
        [String]$SheetName,
        [Parameter(Mandatory, ParameterSetName = 'ByNumber')] 
        [int]$SheetNumber
    )
    $csvFile = Join-Path $env:temp ("{0}.csv" -f (Get-Item -path $FullName).BaseName)
    if (Test-Path -path $csvFile) { Remove-Item -path $csvFile }

    $xlCSVType = 6 # http://msdn.microsoft.com/en-us/library/bb241279.aspx
    $excel = New-Object -ComObject Excel.Application  
    $excel.Visible = $false 
    $workbook = $excel.Workbooks.Open($FullName)
    if ($SheetName) {
        $Null = ($workbook.WorkSheets | Where-Object Name -eq $SheetName).Activate() 
    }
    elseif ($SheetNumber) {
        $Null = ($workbook.WorkSheets.Item($SheetNumber)).Activate()
    }
    $workbook.SaveAs($csvFile, $xlCSVType) 
    $workbook.Saved = $true
    $workbook.Close()

    # cleanup 
    $null = [System.Runtime.Interopservices.Marshal]::ReleaseComObject($workbook)
    $excel.Quit()
    $Null = [System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel)
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
    Import-Csv -path $csvFile
    Remove-Item $csvFile
}