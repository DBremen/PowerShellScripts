# Get-Field

## SYNOPSIS
Gets the public and private fields of objects.

## Script file
Utils\Get-Field.ps1

## SYNTAX

```
Get-Field -InputObject <Object> [[-Name] <String[]>] [-ValueOnly]
```

## DESCRIPTION
DB: Author of this version is Rohn Edwards: https://rohnspowershellblog.wordpress.com/
First, I must give credit to two sources:
1.
I first saw the Get-Field function here: http://powershell.cz/2013/02/25/get-strictmode/
2.
They referenced the source of the function, authored by Andrew Savinykh, which was here: http://poshcode.org/2057
Rohn's function does the same thing as the original, but he simplified the use of the \[BindingFlags\]
(enumerations allow you to cast arrays of strings) and changed the output to PSObjects instead
of a hash table.
I also added pipeline input, the ability to filter on field names, and the 
ability to get a field's value directly.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$ExecutionContext | Get-Field


#This will show all of the public and private fields for the $ExecutionContext object
```
### -------------------------- EXAMPLE 2 --------------------------
```
$ExecutionContext | Get-Field _context


#This will show a public or private field named '_context' for the $ExecutionContext object
```
### -------------------------- EXAMPLE 3 --------------------------
```
$ExecutionContext | Get-Field _context -ValueOnly


#This will expand the value for a field named '_context' for the $ExecutionContext object
```
### -------------------------- EXAMPLE 4 --------------------------
```
$ExecutionContext | Get-Field _context -ValueOnly | Get-Field *engine*


#This will get the fields from the $ExecutionContext._context object that have the word 'engine' in their name.
```
## PARAMETERS

### -InputObject
Specifies the object whose fields are retrieved

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

### -Name
Specifies the names of one or more field names.
The * wildcard is allowed.
Get-Field gets only the fields that satisfy the requirements of at least one of the Name strings.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: 

Required: False
Position: 1
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### -ValueOnly
Gets only the value of the field(s)

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
You could easily modify the function with some switch parameters to control whether or not Public and/or Private
fields are being displayed.
You could also display static fields by modifying the $BindingFlags array.
Also, the properties on the return object aren't ordered.
If you're using PSv3 or higher, you can change the
hash table where the properties are defined to be an \[ordered\] hash table, or you could create the return object
by using the \[PSCustomObject\] accelerator.

## RELATED LINKS

[https://gallery.technet.microsoft.com/scriptcenter/Get-Field-Get-Public-and-7140945e](https://gallery.technet.microsoft.com/scriptcenter/Get-Field-Get-Public-and-7140945e)









