# Import-Excel

## SYNOPSIS
Import data from Excel using Excel's COM interface.

## Script file
Data Wrangling\Import-Excel.ps1

## SYNTAX

### ByName
```
Import-Excel [-FullName] <Object> -SheetName <String>
```

### ByNumber
```
Import-Excel [-FullName] <Object> -SheetNumber <Int32>
```

## DESCRIPTION
Converts the Excel file to a temporary .csv file and imports the same using Import-Csv.
Works only with default delimiter since no paramenter is implemented so far.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$excelFile | Import-Excel
```
## PARAMETERS

### -FullName
The Path to the Excel file to be imported.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -SheetName
The name of the sheet to be imported from the Excel file.

```yaml
Type: String
Parameter Sets: ByName
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SheetNumber
The number of the sheet to be imported from the Excel file.

```yaml
Type: Int32
Parameter Sets: ByNumber
Aliases: 

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS



