# Convert-CsvToXls

## SYNOPSIS
Convert a .csv file to xlsx (despite the name)

## Script file
Data Wrangling\Convert-CsvToXls.ps1

## SYNTAX

### fromstring (Default)
```
Convert-CsvToXls [-Path] <String> [-DeleteSource] [-Delimiter <String>] [-Name <String>] [-Show]
```

### fromfile
```
Convert-CsvToXls [-File] <FileInfo> [-DeleteSource] [-Delimiter <String>] [-Name <String>] [-Show]
```

## DESCRIPTION
The implementation is a combination of two functions I found on StackOverflow and GitHub/Gist (see Links).

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Convert-CsvToXls c:\test.csv
```
### -------------------------- EXAMPLE 2 --------------------------
```
$csvFile | Convert-CsvToXls
```
## PARAMETERS

### -Path
Path of the CSV file to be converted.

```yaml
Type: String
Parameter Sets: fromstring
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -File
The .csv file to be converted.
Accepts pipeline.

```yaml
Type: FileInfo
Parameter Sets: fromfile
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -DeleteSource
Switch to indicate wheter the source CSV file will be deleted.

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

### -Delimiter
Delimiter used in the CSV.
Defaults to system settings delimiter.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name for the resulting excel worksheet.
Defaults to the file base name.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Show
Switch paramenter, if set the resulting Excel file will be opened.

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

[https://gist.github.com/XPlantefeve/75bde89c6967569d218f](https://gist.github.com/XPlantefeve/75bde89c6967569d218f)

[https://stackoverflow.com/questions/17688468/how-to-export-a-csv-to-excel-using-powershell](https://stackoverflow.com/questions/17688468/how-to-export-a-csv-to-excel-using-powershell)





