# Compare-Object

## SYNOPSIS
Proxy function for the built-in Compare-Object cmdlet.
This version also works with arrays,
arrays of PSCustomObjects and custom classes it iterates over nested objects and properties to compare their values
and also support compact output.
See description and paramenter help for more.
Compares two sets of objects.

## Script file
Extend Builtin\Compare-Object.ps1

## Related blog post
https://powershellone.wordpress.com/2021/03/16/extending-powershells-compare-object-to-handle-custom-classes-and-arrays/

## SYNTAX

### Compact (Default)
```
Compare-Object [-ReferenceObject] <Object> [-DifferenceObject] <Object> [-SyncWindow <Int32>]
 [-Property <Object[]>] [-MaxDepth <Int32>] [-__Depth <Int32>] [-__Property <String>] [-ExcludeDifferent]
 [-IncludeEqual] [-Culture <String>] [-CaseSensitive] [-Compact]
```

### PassThru
```
Compare-Object [-ReferenceObject] <Object> [-DifferenceObject] <Object> [-SyncWindow <Int32>]
 [-Property <Object[]>] [-MaxDepth <Int32>] [-__Depth <Int32>] [-__Property <String>] [-ExcludeDifferent]
 [-IncludeEqual] [-PassThru] [-Culture <String>] [-CaseSensitive]
```

## DESCRIPTION
The Compare-Object cmdlet compares two sets
of objects.
One set of objects is the
"reference set," and the other set is the
"difference set."

The result of the comparison indicates
whether a property value appeared only in the
object from the reference set (indicated by
the \<= symbol), only in the object from the
difference set (indicated by the =\> symbol)
or, if the IncludeEqual parameter is
specified, in both objects (indicated by the
== symbol).
Or compact output (through Compact switch) with 
'Property', 'ReferenceValue', 'DifferenceValue' in one row.

The Compare-Object cmdlet compares two sets of objects.
One set of objects is the "reference set," and the other set is the "difference set."

The result of the comparison indicates whether a property value appeared only in the object from the reference set (indicated by the \<= symbol), only in the object from the difference set (indicated by the =\> symbol) or, if the IncludeEqual parameter is specified, in both objects (indicated by the == symbol).

If the reference set or the difference set is null ($null), this cmdlet generates a terminating error.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
#create two custom objects


$one = \[PSCustomObject\]@{Name='Peter';Age=23;Colors='blue','black','green'}
$two = \[PSCustomObject\]@{Name='Paul';Age=23;Colors='blue','yellow','green'}
#compare them with compact output including equal property values
Compare-Object $one $two -Compact -IncludeEqual
```
### Example 1

```
: Compare the content of two text files

PS C:\>Compare-Object -ReferenceObject $(Get-Content C:\test\testfile1.txt) -DifferenceObject $(Get-Content C:\test\testfile2.txt)


This command compares the contents of two text files.
It displays only the lines that appear in one file or in the other file, not lines that appear in both files.
```
### Example 2

```
: Compare each line of content in two text files

PS C:\>Compare-Object -ReferenceObject $(Get-Content C:\Test\testfile1.txt) -DifferenceObject $(Get-Content C:\Test\testfile2.txt) -IncludeEqual


This command compares each line of content in two text files.
It displays all lines of content from both files, indicating whether each line appears in only Textfile1.txt or Textfile2.txt or whether each line appears in both files.
```
### Example 3

```
: Compare two sets of process objects

PS C:\>$Processes_Before = Get-Process
PS C:\> notepad
PS C:\> $Processes_After = Get-Process
PS C:\> Compare-Object -ReferenceObject $Processes_Before -DifferenceObject $Processes_After


These commands compare two sets of process objects.

The first command uses the Get-Process cmdlet to get the processes on the computer.
It stores them in the $processes_before variable.

The second command starts Notepad.

The third command uses the Get-Process cmdlet again and stores the resulting processes in the $processes_after variable.

The fourth command uses the Compare-Object cmdlet to compare the two sets of process objects.
It displaysthe differences between them, which include the new instance of Notepad.
```
## PARAMETERS

### -ReferenceObject
Specifies an array of objects used as a reference for comparison.

Specifies an array of objects used as a reference for comparison.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DifferenceObject
Specifies an array of objects used as a difference for comparison.

Specifies the objects that are compared to the reference objects.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -SyncWindow
Specifies the number of adjacent objects that
this cmdlet inspects while looking for a
match in a collection of objects.
This cmdlet
examines adjacent objects when it does not
find the object in the same position in a
collection.
The default value is
\[Int32\]::MaxValue, which means that this
cmdlet examines the entire object collection.

Specifies the number of adjacent objects that this cmdlet inspects while looking for a match in a collection of objects.
This cmdlet examines adjacent objects when it does not find the object in the same position in a collection.
The default value is \[Int32\]::MaxValue, which means that this cmdlet examines the entire object collection.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Property
Specifies an array of properties of the reference and difference objects to compare.

Specifies an array of properties of the reference and difference objects to compare.

```yaml
Type: Object[]
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaxDepth
Specifies the maximum recursion depth.
Defaults to -1 for recursion over all input objects.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: -1
Accept pipeline input: False
Accept wildcard characters: False
```

### -__Depth
Internal parameter used to carry forward depth information across recursive calls.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -__Property
Internal parameter used to carry property name information across recursive calls.

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

### -ExcludeDifferent
Indicates that this cmdlet displays only the characteristics of compared objects that are equal.

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

### -IncludeEqual
Indicates that this cmdlet displays
characteristics of compared objects that are
equal.
By default, only characteristics that
differ between the reference and difference
objects are displayed.

Indicates that this cmdlet displays characteristics of compared objects that are equal.
By default, only characteristics that differ between the reference and difference objects are displayed.

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

### -PassThru
Returns an object representing the item with
which you are working.
By default, this
cmdlet does not generate any output.

Returns an object representing the item with which you are working.
By default, this cmdlet does not generate any output.

```yaml
Type: SwitchParameter
Parameter Sets: PassThru
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Culture
Specifies the culture to use for comparisons.

Specifies the culture to use for comparisons.

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

### -CaseSensitive
Indicates that comparisons should be case-sensitive.

Indicates that comparisons should be case-sensitive.

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

### -Compact
Switch parameter, if specified puts output into 'Property', 'ReferenceValue', 'DifferenceValue' form instead of long form.

```yaml
Type: SwitchParameter
Parameter Sets: Compact
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### System.Management.Automation.PSObject
You can pipe a DifferenceObject object to this cmdlet.

## OUTPUTS

### None, or the objects that are different
When you use the PassThru parameter, Compare-Object returns the objects that differed.
Otherwise, this cmdlet does not generate any output.

## NOTES

## RELATED LINKS

[https://powershellone.wordpress.com/2021/03/16/extending-powershells-compare-object-to-handle-custom-classes-and-arrays/](https://powershellone.wordpress.com/2021/03/16/extending-powershells-compare-object-to-handle-custom-classes-and-arrays/)

[Online Version:](http://go.microsoft.com/fwlink/?LinkId=821751)

[Group-Object]()

[Measure-Object]()

[New-Object]()

[Select-Object]()

[Sort-Object]()

[Tee-Object]()









