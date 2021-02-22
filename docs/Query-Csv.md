# Query-Csv

## SYNOPSIS
Function to retrieve data from a .csv file based on sql query.
Based on a PowerShellMagazine article from Chrissy LeMaire (see link).

## Script file
Data Wrangling\Query-Csv.ps1

## SYNTAX

```
Query-Csv [-Path] <Object> [-SQL] <Object> [[-Delimiter] <Object>] [-Types <String[]>] [-NoHeaders]
```

## DESCRIPTION
The query is done via ACE.OLEDB driver hence the function requires to Install/download ACE.OLEDB 2010 driver or higher version via the link.
The ACE.OLEDB works best when no header is present therefore the script dynamically creates a schema file to map the headings in case a header is present.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
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
Query-Csv $path 'Select * from table where CLng(Salary)\>24000'  
# UserID UserName Salary Manager
# ------ -------- ------ -------
# 1      Adams    25000  Tom
# 4      Bob      29000  Joe
# 5      Mary     35000  Bill
```
### -------------------------- EXAMPLE 2 --------------------------
```
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
```
## PARAMETERS

### -Path
The path to the csv file to get the data from.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: FullName

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -SQL
The SQL query used to retrieve the data from the csv file.
The tablename in the query should be just the word "table" which is automatically substituted by the csv filename.
As in 'Select * from table'.
See example for details.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Delimiter
The Delimiter of the file.
Defaults to ",".

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: False
Position: 4
Default value: ,
Accept pipeline input: False
Accept wildcard characters: False
```

### -Types
Array to provide the datatype for each column of the csv file.
Defaults to text width = 20.
See https://docs.microsoft.com/en-us/sql/odbc/microsoft/schema-ini-file-text-file-driver?view=sql-server-ver15.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoHeaders
Switch parameter.
Used to indicate that the csv files do not contain headers in the first row.
(column names will be supplemented as f1,f2...)

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://www.microsoft.com/en-us/download/details.aspx?id=54920](https://www.microsoft.com/en-us/download/details.aspx?id=54920)

[https://www.powershellmagazine.com/2015/05/12/natively-query-csv-files-using-sql-syntax-in-powershell/](https://www.powershellmagazine.com/2015/05/12/natively-query-csv-files-using-sql-syntax-in-powershell/)





