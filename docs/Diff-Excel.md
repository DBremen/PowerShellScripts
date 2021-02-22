# Diff-Excel

## SYNOPSIS
PowerShell wrapper for ExcelConmpare a tool to diff excel files

## Script file
Binary wrapper\Diff-Excel.ps1

## SYNTAX

```
Diff-Excel [-XLSX1] <Object> [-XLSX2] <Object> [[-Ignore1] <Object>] [[-Ignore2] <Object>]
```

## DESCRIPTION
PowerShell wrapper for ExcelCompare.
Generates row/column wise diffs conmparing two .xlsx files
This function requires excel_cmp.bat
https://github.com/na-ka-na/ExcelCompare
Instructions:
- Download Excel Compare from https://github.com/na-ka-na/ExcelCompare/releases
- extract and update location to exePath in line 57

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
#Diff all cells


Diff-Excel 1.xlsx 2.xlsx
```
### -------------------------- EXAMPLE 2 --------------------------
```
#Ignore Sheet1 in 1.xlsx


Diff-Excel 1.xlsx 2.xlsx -Ignore1 Sheet1
```
### -------------------------- EXAMPLE 3 --------------------------
```
#Ignore Sheet1 in both


Diff-Excel 1.xlsx 2.xlsx -Ignore1 Sheet1 -Ignore2 Sheet1
```
### -------------------------- EXAMPLE 4 --------------------------
```
#Ignore column A in both


Diff-Excel 1.xlsx 2.xlsx -Ignore1 'Sheet1::A' -Ignore2 'Sheet1::A'
```
### -------------------------- EXAMPLE 5 --------------------------
```
#Ignore column A across all sheets in both


Diff-Excel 1.xlsx 2.xlsx -Ignore1 '::A' -Ignore2 '::A'
```
### -------------------------- EXAMPLE 6 --------------------------
```
#Ignore columns A,D and rows 1-5, 20-25


Diff-Excel 1.xlsx 2.xlsx -Ignore1 'Sheet1:1-5,20-25:A,D' -Ignore2 'Sheet1:1-5,20-25:A,D'
```
### -------------------------- EXAMPLE 7 --------------------------
```
#Ignore columns A,D and rows 1-5, 20-25 and cells F6,H8


Diff-Excel 1.xlsx 2.xlsx -Ignore1 'Sheet1:1-5,20-25:A,D:F6,H8'
```
## PARAMETERS

### -XLSX1
Path to the first xlsx file to compare.

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

### -XLSX2
Path to the second xlsx file to compare

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

### -Ignore1
See examples.
Ignore pattern for first file \<sheet-name\>:\<row-ignore-spec\>:\<column-ignore-spec\>:\<cell-ignore-spec\> cell satisfying any ignore spec in the sheet (row, col, or cell) will be ignored in diff.

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

### -Ignore2
See examples.
Ignore pattern for second file \<sheet-name\>:\<row-ignore-spec\>:\<column-ignore-spec\>:\<cell-ignore-spec\> cell satisfying any ignore spec in the sheet (row, col, or cell) will be ignored in diff

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

[https://github.com/na-ka-na/ExcelCompare](https://github.com/na-ka-na/ExcelCompare)















