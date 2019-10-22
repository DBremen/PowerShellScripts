function Query-Csv {
    <#    
        .SYNOPSIS
          Function to retrieve data from a .csv file based on sql query.
          Based on a PowerShellMagazine article from Chrissy LeMaire (see link).
        .DESCRIPTION
          The query is done via ACE.OLEDB driver hence the function requires to Install/download ACE.OLEDB 2010 driver or higher version via the link.
          The ACE.OLEDB works best when no header is present therefore the script dynamically creates a schema file to map the headings in case a header is present.
        .PARAMETER Path
          The path to the csv file to get the data from.
        .PARAMETER SQL
          The SQL query used to retrieve the data from the csv file.
          The tablename in the query should be just the word "table" which is automatically substituted by the csv filename.
          As in 'Select * from table'. See example for details.
        .PARAMETER Delimiter
          The Delimiter of the file. Defaults to ",".
        .PARAMETER Types
          Array to provide the datatype for each column of the csv file.
          Defaults to text width = 20. See https://docs.microsoft.com/en-us/sql/odbc/microsoft/schema-ini-file-text-file-driver?view=sql-server-ver15.
        .PARAMETER NoHeaders
          Switch parameter. Used to indicate that the csv files do not contain headers in the first row. (column names will be supplemented as f1,f2...)
        .EXAMPLE
          $path = "$env:USERPROFILE\Desktop\users.csv"
          #build an csv for testing
@'
UserID,UserName,Salary,Manager
1,Adams,25000,Tom
2,Miller,12000,Bill
3,Nalty,23000,Tom
4,Bob,29000,Joe
5,Mary,35000,Bill
'@ | Set-Content $path
          # Get users that earn more than 24k
          Query-Csv $path 'Select * from table where CLng(Salary)>24000'  
          # UserID UserName Salary Manager
          # ------ -------- ------ -------
          # 1      Adams    25000  Tom
          # 4      Bob      29000  Joe
          # 5      Mary     35000  Bill  
        .EXAMPLE
          $path = "$env:USERPROFILE\Desktop\users.csv"
          #build an csv for testing
@'
UserID,UserName,Salary,Manager
1,Adams,25000,Tom
2,Miller,12000,Bill
3,Nalty,23000,Tom
4,Bob,29000,Joe
5,Mary,35000,Bill
'@ | Set-Content $path
          # Get salaries grouped by managers
          Query-Csv $path 'Select sum(salary) as SumEmpSalary,Manager from table group by manager'
          # SumEmpSalary Manager
          # ------------ -------
          #        47000 Bill
          #        29000 Joe
          #        48000 Tom
        .LINK
          https://www.microsoft.com/en-us/download/details.aspx?id=54920
        .LINK
           https://www.powershellmagazine.com/2015/05/12/natively-query-csv-files-using-sql-syntax-in-powershell/
      #>
    [CmdletBinding()]
    param( 
        [Parameter(ValueFromPipeline,
            Position = 0, Mandatory)]  
        [Alias('FullName')]  
        $Path,
        [Parameter(Position = 2, Mandatory)]   
        $SQL,
        [Parameter(Position = 3)]  
        $Delimiter = ',',
        [string[]]$Types,
        [switch]$NoHeaders
    )
    $folder = Split-Path $Path
    $schemaPath = "$folder\schema.ini"
    $file = Get-Item $Path
    Add-Content -Path $schemaPath -Value "[$($file.Name)]"
    Add-Content -Path $schemaPath -Value "Format=Delimited($Delimiter)"
    Add-Content -Path $schemaPath -Value "ColNameHeader=$(!$NoHeaders.IsPresent)"
    if (!$NoHeaders) {
        $headers = ($file | Get-Content -TotalCount 1).Split($Delimiter)
        $i = 1
        $headers | foreach {
            try {
                $type = $Types[$i - 1]
            }
            catch {
                $type = 'TEXT Width 20'
            }
            Add-Content -Path $schemaPath -Value "Col$($i)=`"$($_.Replace('"',''))`" $type"
            $i++
        }
    }
    $firstRowColumnNames = "No"
    $provider = (New-Object System.Data.OleDb.OleDbEnumerator).GetElements() | Where-Object { $_.SOURCES_NAME -like "Microsoft.ACE.OLEDB.*" }
    if ($provider -is [system.array]) { $provider = $provider[0].SOURCES_NAME } else { $provider = $provider.SOURCES_NAME }
    $connstring = "Provider=$provider;Data Source=$($folder);Extended Properties='text;HDR=$firstRowColumnNames;';"
    $tableName = $file.Name.Replace(".", "#")
    $actSql = $SQL.Replace('table', $tableName)
    # Setup connection and command
    $conn = New-Object System.Data.OleDb.OleDbconnection
    $conn.ConnectionString = $connstring
    $conn.Open()
    $cmd = New-Object System.Data.OleDB.OleDBCommand
    $cmd.Connection = $conn
    $cmd.CommandText = $actSql
    # Load into datatable
    $dt = New-Object System.Data.DataTable
    $dt.Load($cmd.ExecuteReader("CloseConnection"))
    # Clean up
    [void]$cmd.dispose 
    [void]$conn.dispose
    del "$folder\schema.ini"
    return $dt
}