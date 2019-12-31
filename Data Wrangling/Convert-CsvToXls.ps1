function Convert-CsvToXls {
    <#
        .SYNOPSIS
            Convert a .csv file to xlsx (despite the name)
        .DESCRIPTION
            The implementation is a combination of two functions I found on StackOverflow and GitHub/Gist (see Links).
	    .PARAMETER Path
            Path of the CSV file to be converted (accepts pipeline input via dir). If no path is provided an open file dialog is opened to select the path.
        .PARAMETER DeleteSource
            Switch to indicate wheter the source CSV file will be deleted.
        .PARAMETER Delimiter
            Delimiter used in the CSV. Defaults to system settings delimiter.
        .PARAMETER Name
            The name for the resulting excel worksheet. Defaults to the file base name.
        .PARAMETER Show
            Switch paramenter, if set the resulting Excel file will be opened.
        .EXAMPLE
            Convert-CsvToXls c:\test.csv
        .EXAMPLE
            $csvFile | Convert-CsvToXls
        .LINK
            https://gist.github.com/XPlantefeve/75bde89c6967569d218f
        .LINK
            https://stackoverflow.com/questions/17688468/how-to-export-a-csv-to-excel-using-powershell
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName, ParameterSetName = 'fromstring')]
        [Alias('FullName')]
        [string]$Path,
        [switch]$DeleteSource,
        [String][ValidateSet('Comma', 'Semicolon', 'Space', 'Tab')]$Delimiter,
        [string]$Name,
        [switch]$Show
    )
    BEGIN {
        Add-Type -AssemblyName 'Microsoft.Office.Interop.Excel'
    }
    PROCESS {
        if (!$Path){
            Add-Type -AssemblyName System.Windows.Forms
            $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
            $OpenFileDialog.Title = "Please Select File"
            $OpenFileDialog.InitialDirectory = "$env:USERPROFILe\Desktop"
            $OpenFileDialog.filter = "CSV files (*.csv)| *.csv"
            $result = $OpenFileDialog.ShowDialog()
            if ($result -eq 'OK'){
                $Path = $OpenFileDialog.FileName
            }
        }
        if ( $Path ) {
            $File = Get-Item -Path $Path
        }
        # We set $Path even if it exists, to translate it to a full path.
        $Path = $File.FullName
        $outPath = [IO.Path]::ChangeExtension($Path, 'xlsx')

        ### Create a new Excel Workbook with one empty sheet
        $excel = New-Object -ComObject excel.application
        $workbook = $excel.Workbooks.Add(1)
        $worksheet = $workbook.worksheets.Item(1)
        if ($Name) {
            $worksheet.Name = $Name
        }
        else {
            $worksheet.Name = $File.BaseName
        }
        ### Build the QueryTables.Add command
        ### QueryTables does the same as when clicking "Data » From Text" in Excel
        $TxtConnector = ("TEXT;" + $Path)
        $Connector = $worksheet.QueryTables.add($TxtConnector, $worksheet.Range("A1"))
        $query = $worksheet.QueryTables.item($Connector.name)
        if ($Delimiter) {
            $worksheet.QueryTables.Item($Connector.Name).TextFileOtherDelimiter = $DelimiterChar
        }
        else {
            ### Set the delimiter (, or ;) according to your regional settings
            $query.TextFileOtherDelimiter = $Excel.Application.International(5)
        }

        ### Set the format to delimited and text for every column
        ### A trick to create an array of 2s is used with the preceding comma
        <#
            xlDMYFormat	4	DMY date format.
            xlDYMFormat	7	DYM date format.
            xlEMDFormat	10	EMD date format.
            xlGeneralFormat	1	General.
            xlMDYFormat	3	MDY date format.
            xlMYDFormat	6	MYD date format.
            xlSkipColumn	9	Column is not parsed.
            xlTextFormat	2	Text.
            xlYDMFormat	8	YDM date format.
            xlYMDFormat	5	YMD date format.
        #>
        $query.TextFileParseType = 1
        $query.TextFileColumnDataTypes = , ([Microsoft.Office.Interop.Excel.XlColumnDataType]::xlTextFormat) * $worksheet.Cells.Columns.Count
        $query.AdjustColumnWidth = 1

        ### Execute & delete the import query
        $null = $query.Refresh()
        $Null = $query.Delete()
        [void] $worksheet.Rows.Item(1).AutoFilter()

        [void] $workSheet.Activate()
        $worksheet.Application.ActiveWindow.SplitRow = 1;
        $workSheet.Application.ActiveWindow.FreezePanes = $true;
        $excel.DisplayAlerts = $false
        $null = $Workbook.SaveAs($outPath, 51)
        $Null = $excel.Quit()
        [void] [System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel)
        if ($show) {
            Invoke-Item $outPath
        }
    }
}
