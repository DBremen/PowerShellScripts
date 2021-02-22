# Get-ACEData

## SYNOPSIS
Checkout the whole modules as it exports several more functions.
Queries Excel and Access files.

## Script file
ACE\ACE.psm1

## SYNTAX

```
Get-ACEData [-FilePath] <String> [[-Table] <String[]>] [[-Query] <String>] [-TableListOnly]
```

## DESCRIPTION
Get-ACEData gets data from Microsoft Office Access (*.mdb and *.accdb) files and Microsoft Office Excel (*.xls, *.xlsx, and *.xlsb) files

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-ACEData -FilePath ./budget.xlsx -WorkSheet 'FY2010$','FY2011$'


This example gets data for the worksheets FY2010 and FY2011 from the Excel file
```
### -------------------------- EXAMPLE 2 --------------------------
```
Get-ACEData - -FilePath ./budget.xlsx -WorksheetListOnly


This example list the Worksheets for the Excel file
```
### -------------------------- EXAMPLE 3 --------------------------
```
Get-ACEData -FilePath ./projects.xls -Query 'Select * FROM [Sheet1$]'


This example gets data using a query from the Excel file
```
## PARAMETERS

### -FilePath
{{Fill FilePath Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Table
{{Fill Table Description}}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Worksheet

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Query
{{Fill Query Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TableListOnly
{{Fill TableListOnly Description}}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: WorksheetListOnly

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### None 
    You cannot pipe objects to Get-ACEData

## OUTPUTS

### System.Data.DataSet

## NOTES
Imporant!!!
 
Install ACE 12/26/2010 or higher version from LINK below 
If using an x64 host install x64 version and use x64 PowerShell 
Version History 
v1.0   - Chad Miller - 4/21/2011 - Initial release

## RELATED LINKS

[http://www.microsoft.com/downloads/en/details.aspx?FamilyID=c06b8369-60dd-4b64-a44b-84b371ede16d&displaylang=en](http://www.microsoft.com/downloads/en/details.aspx?FamilyID=c06b8369-60dd-4b64-a44b-84b371ede16d&displaylang=en)







