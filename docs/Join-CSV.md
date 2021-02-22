# Join-CSV

## SYNOPSIS
Function to join two .csv files based on a common column.
Based on a PowerShellMagazine article from Chrissy LeMaire (see link).

## Script file
Data Wrangling\Join-CSV.ps1

## SYNTAX

```
Join-CSV [-Path] <Object> [-FirstFileName] <Object> [-SecondFileName] <Object> [-FirstKey] <Object>
 [[-SecondKey] <Object>] [[-JoinType] <Object>] [[-Delimiter] <Object>] [-FirstTypes <String[]>]
 [-SecondTypes <String[]>] [-NoHeaders]
```

## DESCRIPTION
The join is done via the ACE.OLEDB driver hence the function requires to Install/download ACE.OLEDB 2010 driver or higher version via the link.
The ACE.OLEDB works best when no header is present therefore the script dynamically creates a schema file to map the headings in case a header is present.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
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
```
## PARAMETERS

### -Path
The path to the folder the .csv filesto join reside in.

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

### -FirstFileName
The filename of the first (left) file to join.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: LeftFileName

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SecondFileName
The filename of the second (right) file to join.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: RightFileName

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FirstKey
The name of the column in the first (left) file to make the join based on.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: LeftKey

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SecondKey
The name of the column in the second (right) file to make the join based on.
If no value provided, the same key as for the first file is assumed.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: RightKey

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -JoinType
The type of join to perform with two .csv files.
One of INNER, LEFT, RIGHT.
Defaults to INNER.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: False
Position: 6
Default value: INNER
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
Position: 7
Default value: ,
Accept pipeline input: False
Accept wildcard characters: False
```

### -FirstTypes
Array to provide the datatype for each column of the first file.
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

### -SecondTypes
Array to provide the datatype for each column of the first file.
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



