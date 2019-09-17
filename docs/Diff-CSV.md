# Diff-CSV

## SYNOPSIS
PowerShell wrapper for diff-table.exe a tool to diff csv files

## Script file
Binary wrapper\Diff-CSV.ps1

## SYNTAX

```
Diff-CSV [-CSV1] <Object> [-CSV2] <Object> [-Key] <Object>
```

## DESCRIPTION
PowerShell wrapper for diff-table.exe tool.
Generates row/column wise diffs conmparing two .csv files
This function requires diff-table.exe tool.
https://github.com/chop-dbhi/diff-table
Instructions:
- Download https://github.com/chop-dbhi/diff-table/releases/download/0.4.0/diff-table-windows-amd64.zip
- extract and update location to exePath in line 35

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Diff-CSV test1.csv test2.csv name


#Compares both files based on the "name" column as the primary key
```
## PARAMETERS

### -CSV1
Path to the first csv file to compare.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CSV2
Path to the second csv file to compare

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Key
Primary key (column name) that is common in both csv files (can be a combination of multiple columns provided as a comma separted list)

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

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://github.com/chop-dbhi/diff-table](https://github.com/chop-dbhi/diff-table)



