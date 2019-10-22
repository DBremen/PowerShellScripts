function Join-CSV {
  <#    
      .SYNOPSIS
        Function to join two .csv files based on a common column.
        Based on a PowerShellMagazine article from Chrissy LeMaire (see link).
      .DESCRIPTION
        The join is done via the ACE.OLEDB driver hence the function requires to Install/download ACE.OLEDB 2010 driver or higher version via the link.
        The ACE.OLEDB works best when no header is present therefore the script dynamically creates a schema file to map the headings in case a header is present.
      .PARAMETER Path
        The path to the folder the .csv filesto join reside in.
      .PARAMETER FirstFileName
        The filename of the first (left) file to join.
      .PARAMETER SecondFileName
        The filename of the second (right) file to join.
      .PARAMETER FirstKey
        The name of the column in the first (left) file to make the join based on.
      .PARAMETER SecondKey
        The name of the column in the second (right) file to make the join based on.
        If no value provided, the same key as for the first file is assumed.
      .PARAMETER JoinType
        The type of join to perform with two .csv files. One of INNER, LEFT, RIGHT. Defaults to INNER.
      .PARAMETER Delimiter
        The Delimiter of the file. Defaults to ",".
      .PARAMETER FirstTypes
        Array to provide the datatype for each column of the first file.
        Defaults to text width = 20. See https://docs.microsoft.com/en-us/sql/odbc/microsoft/schema-ini-file-text-file-driver?view=sql-server-ver15.
      .PARAMETER SecondTypes
        Array to provide the datatype for each column of the first file.
        Defaults to text width = 20. See https://docs.microsoft.com/en-us/sql/odbc/microsoft/schema-ini-file-text-file-driver?view=sql-server-ver15.
      .PARAMETER NoHeaders
        Switch parameter. Used to indicate that the csv files do not contain headers in the first row. (column names will be supplemented as f1,f2...)
      .EXAMPLE
        #folder to store the .csv in
        $folder = mkdir "$env:TEMP\joincsv"
        #build two object arrays for testing
         @'
AccountID,AccountName
1,Contoso
2,Fabrikam
3,LitWare
'@ | Set-Content "$folder\accounts.csv"

        @'
UserID,UserName
1,Adams
1,Miller
2,Nalty
3,Bob
4,Mary
'@ | Set-Content "$folder\users.csv"
        #Do a right join using default type
        Join-Csv $folder accounts.csv users.csv AccountId UserId -JoinType Right
        # AccountID AccountName UserID UserName
        # --------- ----------- ------ --------
        # 1         Contoso     1      Adams
        # 1         Contoso     1      Miller
        # 2         Fabrikam    2      Nalty
        # 3         LitWare     3      Bob     
        #                       4      Mary
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
    [Parameter(Position = 1, Mandatory)]  
    [ValidateScript( {
        if ($_.EndsWith('.csv')) {
          $true
        }
        else {
          throw "$_ filename must be ending in .csv"
        }
      })]  
    [Alias('LeftFileName')] 
    $FirstFileName,
    [Parameter(Position = 2, Mandatory)]  
    [ValidateScript( {
        if ($_.EndsWith('.csv')) {
          $true
        }
        else {
          throw "$_ filename must be ending in .csv"
        }
      })]  
    [Alias('RightFileName')] 
    $SecondFileName,
    [Parameter(Position = 3, Mandatory)]  
    [Alias('LeftKey')]  
    $FirstKey,
    [Parameter(Position = 4)]  
    [Alias('RightKey')]  
    $SecondKey,
    [Parameter(Position = 5)]  
    [ValidateSet('INNER', 'LEFT', 'RIGHT')]
    $JoinType = 'INNER',
    [Parameter(Position = 6)]  
    $Delimiter = ',',
    [string[]]$FirstTypes,
    [string[]]$SecondTypes,
    [switch]$NoHeaders
  )
  #create the schema.ini in the same folder
  $files = dir "$Path\*.csv"
  $schemaPath = "$Path\schema.ini"
  foreach ($file in $files) {
    Add-Content -Path $schemaPath -Value "[$($file.Name)]"
    Add-Content -Path $schemaPath -Value "Format=Delimited($Delimiter)"
    Add-Content -Path $schemaPath -Value "ColNameHeader=$(!$NoHeaders.IsPresent)"
    if (!$NoHeaders) {
      $headers = ($file | Get-Content -TotalCount 1).Split($Delimiter)
      $i = 1
      $colTypes = $FirstTypes
      if ($file.Name -eq $SecondFileName) {
        $colTypes = $SecondTypes
      }
      $headers | foreach {
        try {
          $type = $colTypes[$i - 1]
        }
        catch {
          $type = 'TEXT Width 20'
        }
        Add-Content -Path $schemaPath -Value "Col$($i)=`"$($_.Replace('"',''))`" $type"
        $i++
      }
    }
  }
  $firstRowColumnNames = "No"
  $provider = (New-Object System.Data.OleDb.OleDbEnumerator).GetElements() | Where-Object { $_.SOURCES_NAME -like "Microsoft.ACE.OLEDB.*" }
  if ($provider -is [system.array]) { $provider = $provider[0].SOURCES_NAME } else { $provider = $provider.SOURCES_NAME }
  $connstring = "Provider=$provider;Data Source=$($Path);Extended Properties='text;HDR=$firstRowColumnNames;';"
  #$tablename = (Split-Path $csv -leaf).Replace(".","#")
  $sql = "Select * FROM [$($FirstFileName.Replace('.','#'))] a $JoinType JOIN [$($SecondFileName.Replace('.','#'))] b ON a.[$($FirstKey)] = b.[$($SecondKey)]"
  # Setup connection and command
  $conn = New-Object System.Data.OleDb.OleDbconnection
  $conn.ConnectionString = $connstring
  $conn.Open()
  $cmd = New-Object System.Data.OleDB.OleDBCommand
  $cmd.Connection = $conn
  $cmd.CommandText = $sql
  # Load into datatable
  $dt = New-Object System.Data.DataTable
  $dt.Load($cmd.ExecuteReader("CloseConnection"))
  # Clean up
  [void]$cmd.dispose 
  [void]$conn.dispose
  del "$Path\schema.ini"
  return $dt
}
