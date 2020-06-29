# Add-FormatTableView

## SYNOPSIS
Function to add a Format Table View for a type

## Script file
format output\Add-FormatTableView.ps1

## Related blog post
https://powershellone.wordpress.com/2015/03/09/powershell-format-table-views/

## SYNTAX

```
Add-FormatTableView -InputObject <Object> [[-Label] <String[]>] [-Property] <String[]> [[-Width] <Int32[]>]
 [[-Alignment] <Alignment[]>] [[-ViewName] <Object>]
```

## DESCRIPTION
Format views are living in the *format.ps1xml files those define named sets of properties which can be used with the Format-* cmdlets

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$fileName = Get-Process | Add-FormatTableView -Label ProcName, PagedMem, PeakWS -Property 'Name', 'PagedMemorySize', 'PeakWorkingSet' -Width 40 -Alignment Center -ViewName RAM


Get-Process | select -First 3 | Format-Table -View RAM
      #add this to the profile to have the format view available in all sessions
      #Update-FormatData -PrependPath $fileName
```
### -------------------------- EXAMPLE 2 --------------------------
```
dir | Add-FormatTableView -Property 'Name', 'LastWriteTime', 'CreationTime' -ViewName Testing


dir | Format-Table -View Testing
```
### -------------------------- EXAMPLE 3 --------------------------
```
#using the default table view name ('TableView') to modify custom object default output


#create a custom object array
$arr = @()
$obj = \[PSCustomObject\]@{FirstName='Jon';LastName='Doe'}
#add a custom type name to the object
$typeName = 'YouAreMyType'
$obj.PSObject.TypeNames.Insert(0,$typeName)
$arr += $obj
$obj = \[PSCustomObject\]@{FirstName='Pete';LastName='Smith'}
$obj.PSObject.TypeNames.Insert(0,$typeName)
$arr += $obj
$obj.PSObject.TypeNames.Insert(0,$typeName)
#add a default table format view
$arr | Add-FormatTableView -Label 'First Name', 'Last Name' -Property FirstName, LastName -Width 30 -Alignment Center
$arr 
#when using the object further down in the pipeline the property name must be used
$arr  | where "LastName" -eq 'Doe'
```
## PARAMETERS

### -InputObject
Objects that determine the type(s) the view is added to

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Label
Optionally for every property a label can be speciffied.
For every property that does not have a respective label the property name is used as the label for the column

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: 

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Property
{{Fill Property Description}}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: 

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Width
Optionally for every property the width can be speciffied.
The default value for Width is 20.
For every property that does not have a respective width specified, the first value is used.

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases: 

Required: False
Position: 3
Default value: 20
Accept pipeline input: False
Accept wildcard characters: False
```

### -Alignment
Optionally for every property the alignment can be speciffied.
The default value for Alignment is undefined.
For every property that does not have a respective alignment specified, the first value is used.

```yaml
Type: Alignment[]
Parameter Sets: (All)
Aliases: 
Accepted values: Undefined, Left, Center, Right

Required: False
Position: 4
Default value: Undefined
Accept pipeline input: False
Accept wildcard characters: False
```

### -ViewName
The name for the View, that is being created.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: False
Position: 5
Default value: TableView
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

### The function returns the path of the *format.ps1xml for the type, that the format table view is being created for.

## NOTES

## RELATED LINKS

[https://powershellone.wordpress.com/2015/03/09/powershell-format-table-views/](https://powershellone.wordpress.com/2015/03/09/powershell-format-table-views/)

[Get-FormatView]()







