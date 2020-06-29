# Get-CSVDelimiter

## SYNOPSIS
Autodetects delimiter used in CSV files and number of rows

## Script file
Data Wrangling\Get-CSVDelimiter.ps1

## SYNTAX

```
Get-CSVDelimiter [[-Path] <String>]
```

## DESCRIPTION
Uses heuristics to determine the delimiter character used in a CSV file

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-CSVDelimiter -Path c:\somefile.csv


Returns delimiter used in file c:\somefile.csv
```
### -------------------------- EXAMPLE 2 --------------------------
```
Get-ChildItem $home -Filter *.csv -recurse -ErrorAction SilentlyContinue | Get-CSVDelimiter


Returns delimiter used in any CSV-file found in the user's home folder or one of its subfolders
```
## PARAMETERS

### -Path
Path name to CSV file
can be submitted as string or as File object

```yaml
Type: String
Parameter Sets: (All)
Aliases: FullName

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[http://www.powertheshell.com/autodetecting-csv-delimiter/#](http://www.powertheshell.com/autodetecting-csv-delimiter/#)





