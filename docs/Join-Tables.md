# Join-Tables

## SYNOPSIS
Function to join tables based on one or more common columns with an option to summarize (aggregate) joined columns.

## Script file
Extend Builtin\Join-Tables.ps1

## SYNTAX

```
Join-Tables [[-LookupColumns] <Object>] [[-ReferenceTable] <Object>] [[-LookupTable] <Object>]
 [[-Aggregates] <Object>]
```

## DESCRIPTION
Merge two separate tables (left outer join) into one joined table based on one or more common columns similar to a vlookup in MS Excel.
In addition the values of specified number based columns can be optionally summarized using 
an aggregate function (sum,max,min,count,average) similar to the functionality of a pivot table.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$FirstCollection = @"


FirstName,  LastName,   MailingAddress,    EmployeeID
  John,       Doe,        123 First Ave,     J8329029
  Susan Q.,   Public,     3025 South Street, K4367143
  Dirk,       Doe,        123 First Ave,     J8329030
  Carol,   Public,     3025 South Street, K4367144
  John,       Doe,        123 First Ave,     J8329031
  Susan Q.,   Public,     3025 South Street, K4367145
  Peter,   Public,     3025 South Street, K4367146
"@.Split("\`n") | foreach {$_.trim()} | ConvertFrom-Csv                          

 $SecondCollection = @"
  ID,    Week, HrsWorked,   PayRate,  EmployeeID
  12276, 12,   40,          55,       J8329029
  12277, 13,   40,          55,       J8329030
  12278, 14,   42,          55,       J8329031
  12279, 12,   35,          40,       K4367143
  12280, 13,   32,          40,       K4367144
  12281, 14,   48,          40,       K4367145
"@.Split("\`n") | foreach {$_.trim()} | ConvertFrom-Csv
#Join tables on EmployeeID column
Join-Tables employeeid $FirstCollection $SecondCollection | ft -AutoSize
```
### -------------------------- EXAMPLE 2 --------------------------
```
$table1=@"


firstname,lastname,city,country,sales
    john,doe,NYC,USA,11
    john,wayne,Hamburg,Germany,88
    peter,new,Washington,USA,44
    gary,henderson,LA,USA,55
"@ | ConvertFrom-Csv

$table2=@"
    firstname,lastname,city,zip,age,sales
    john,doe,NYC,2222,12,55
    nate,robbins,LA,3333,23,66
    john,wayne,Hamburg,8888,36,124
    peter,new,Washington,6666,45,99
"@ | ConvertFrom-Csv
#Join two tables based on two lookup columns summing up the sales column
Join-Tables ("firstname","lastname") $table1 $table2 @{sales="sum"} | ft
```
## PARAMETERS

### -LookupColumns
One or multiple column(s) the tables are joined on.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReferenceTable
The reference table for the join operation.
All records from this table will be part of the joined table

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LookupTable
The lookup table for the join operation.
Only matching records will be part of the joined table

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Aggregates
A hashtable where the keys represent number based columnnames and the values represent one of the following 
aggregate functions (sum,maximum,minimum,average,count)

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS





