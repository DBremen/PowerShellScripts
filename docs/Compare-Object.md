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

The \`Compare-Object\` cmdlet compares two sets of objects.
One set of objects is the reference , and the other set of objects is the difference .

\`Compare-Object\` checks for available methods of comparing a whole object.
If it can't find a suitable method, it calls the ToString() methods of the input objects and compares the string results.
You can provide one or more properties to be used for comparison.
When properties are provided, the cmdlet compares the values of those properties only.

The result of the comparison indicates whether a property value appeared only in the reference object (\`\<=\`) or only in the difference object (\`=\>\`).
If the IncludeEqual parameter is used, (\`==\`) indicates the value is in both objects.

If the reference or the difference objects are null (\`$null\`), \`Compare-Object\` generates a terminating error.

Some examples use splatting to reduce the line length of the code samples.
For more information, see about_Splatting (../Microsoft.PowerShell.Core/About/about_Splatting.md).

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
class Person {


\[String\]$Name
	\[String\]$LastName
	\[String\[\]\]$Age
	\[Person\[\]\]$Parents

	Person($Name, $LastName, $Age) {
		$this.Name = $Name
		$this.LastName = $LastName
		$this.Age = $Age
	}
}

$psmith = \[Person\]::new('Paul', 'Smith', (46, 66, 77))
$msmith = \[Person\]::new('Mary', 'Smith', 35)
$nsmith = \[Person\]::new('Nigel', 'Smith', 11)
$nsmith.Parents = $psmith, $msmith

$pdoe = \[Person\]::new('Jon', 'Doe', 46)
$ldoe = \[Person\]::new('Mary', 'Doe', 51)
$adoe = \[Person\]::new('Aidan', 'Doe', 23)
$adoe.Parents = $pdoe, $ldoe

Compare-Object $nsmith $adoe -IncludeEqual
```
### -------------------------- EXAMPLE 2 --------------------------
```
#create two custom objects


$one = \[PSCustomObject\]@{Name='Peter';Age=23;Colors='blue','black','green'}
$two = \[PSCustomObject\]@{Name='Paul';Age=23;Colors='blue','yellow','green'}
#compare them with compact output including equal property values
Compare-Object $one $two -Compact -IncludeEqual
```
### ------ Example 1 -
```
Compare the content of two text files ------

Compare-Object -ReferenceObject (Get-Content -Path C:\Test\Testfile1.txt) -DifferenceObject (Get-Content -Path C:\Test\Testfile2.txt)

InputObject SideIndicator
----------- -------------
cat         =>
racoon      =>
dog         <=
squirrel    <=
```
### Example 2 -
```
Compare each line of content and exclude the differences

$objects = @{
  ReferenceObject = (Get-Content -Path C:\Test\Testfile1.txt)
  DifferenceObject = (Get-Content -Path C:\Test\Testfile2.txt)
}
Compare-Object @objects -IncludeEqual -ExcludeDifferent

InputObject SideIndicator
----------- -------------
bird        ==


\<a id="ex3" /\>
```
### Example 3 -
```
Show the difference when using the PassThru parameter

$a = $True
Compare-Object -IncludeEqual $a $a
(Compare-Object -IncludeEqual $a $a) | Get-Member

InputObject SideIndicator
----------- -------------
       True ==

   TypeName: System.Management.Automation.PSCustomObject
Name          MemberType   Definition
----          ----------   ----------
Equals        Method       bool Equals(System.Object obj)
GetHashCode   Method       int GetHashCode()
GetType       Method       type GetType()
ToString      Method       string ToString()
InputObject   NoteProperty System.Boolean InputObject=True
SideIndicator NoteProperty string SideIndicator===

Compare-Object -IncludeEqual $a $a -PassThru
(Compare-Object -IncludeEqual $a $a -PassThru) | Get-Member

True

   TypeName: System.Boolean
Name          MemberType   Definition
----          ----------   ----------
CompareTo     Method       int CompareTo(System.Object obj), int CompareTo(bool value), int IComparable.CompareTo(Syst
Equals        Method       bool Equals(System.Object obj), bool Equals(bool obj), bool IEquatable[bool].Equals(bool ot
GetHashCode   Method       int GetHashCode()
GetType       Method       type GetType()
GetTypeCode   Method       System.TypeCode GetTypeCode(), System.TypeCode IConvertible.GetTypeCode()
ToBoolean     Method       bool IConvertible.ToBoolean(System.IFormatProvider provider)
ToByte        Method       byte IConvertible.ToByte(System.IFormatProvider provider)
ToChar        Method       char IConvertible.ToChar(System.IFormatProvider provider)
ToDateTime    Method       datetime IConvertible.ToDateTime(System.IFormatProvider provider)
ToDecimal     Method       decimal IConvertible.ToDecimal(System.IFormatProvider provider)
ToDouble      Method       double IConvertible.ToDouble(System.IFormatProvider provider)
ToInt16       Method       short IConvertible.ToInt16(System.IFormatProvider provider)
ToInt32       Method       int IConvertible.ToInt32(System.IFormatProvider provider)
ToInt64       Method       long IConvertible.ToInt64(System.IFormatProvider provider)
ToSByte       Method       sbyte IConvertible.ToSByte(System.IFormatProvider provider)
ToSingle      Method       float IConvertible.ToSingle(System.IFormatProvider provider)
ToString      Method       string ToString(), string ToString(System.IFormatProvider provider), string IConvertible.To
ToType        Method       System.Object IConvertible.ToType(type conversionType, System.IFormatProvider provider)
ToUInt16      Method       ushort IConvertible.ToUInt16(System.IFormatProvider provider)
ToUInt32      Method       uint IConvertible.ToUInt32(System.IFormatProvider provider)
ToUInt64      Method       ulong IConvertible.ToUInt64(System.IFormatProvider provider)
TryFormat     Method       bool TryFormat(System.Span[char] destination, [ref] int charsWritten)
SideIndicator NoteProperty string SideIndicator===


When using PassThru , the original object type ( System.Boolean ) is returned.
Note how the output displayed by the default format for System.Boolean objects didn't display the SideIndicator property.
However, the returned System.Boolean object has the added NoteProperty .
```
### --- Example 4 -
```
Compare two simple objects using properties ---

Compare-Object -ReferenceObject 'abc' -DifferenceObject 'xyz' -Property Length -IncludeEqual

Length SideIndicator
------ -------------
     3 ==
```
### ---- Example 5 -
```
Comparing complex objects using properties ----

PS> Get-Process pwsh

 NPM(K)    PM(M)      WS(M)     CPU(s)      Id  SI ProcessName
 ------    -----      -----     ------      --  -- -----------
    101   123.32     139.10      35.81   11168   1 pwsh
     89   107.55      66.97      11.44   17600   1 pwsh

PS> $a = Get-Process -Id 11168
PS> $b = Get-Process -Id 17600
PS> $a.ToString()
System.Diagnostics.Process (pwsh)
PS> $b.ToString()
System.Diagnostics.Process (pwsh)
PS> Compare-Object $a $b -IncludeEqual

InputObject                       SideIndicator
-----------                       -------------
System.Diagnostics.Process (pwsh) ==

PS> Compare-Object $a $b -Property ProcessName, Id, CPU

ProcessName    Id       CPU SideIndicator
-----------    --       --- -------------
pwsh        17600   11.4375 =>
pwsh        11168 36.203125 <=


When you specify properties to be compared, the cmdlet shows the differences.
```
### Example 6 -
```
Comparing complex objects that implement IComparable

Compare-Object ([TimeSpan]"0:0:1") "0:0:1" -IncludeEqual

InputObject SideIndicator
----------- -------------
00:00:01    ==

Compare-Object "0:0:1" ([TimeSpan]"0:0:1")

InputObject SideIndicator
----------- -------------
00:00:01    =>
0:0:1       <=


In the second case, the TimeSpan is converted to a string so the object are different.
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

Specifies the number of adjacent objects that \`Compare-Object\` inspects while looking for a match in a collection of objects.
\`Compare-Object\` examines adjacent objects when it doesn't find the object in the same position in a collection.
The default value is \`\[Int32\]::MaxValue\`, which means that \`Compare-Object\` examines the entire object collection.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: [Int32]::MaxValue
Accept pipeline input: False
Accept wildcard characters: False
```

### -Property
Specifies an array of properties of the reference and difference objects to compare.

Specifies an array of properties of the reference and difference objects to compare.

The value of the Property parameter can be a new calculated property.
The calculated property can be a script block or a hash table.
Valid key-value pairs are:

- Expression - \`\<string\>\` or \`\<script block\>\`

For more information, see about_Calculated_Properties (../Microsoft.PowerShell.Core/About/about_Calculated_Properties.md).

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
The differences between the objects are discarded.

Use ExcludeDifferent with IncludeEqual to display only the lines that match between the reference and difference objects.

If ExcludeDifferent is specified without IncludeEqual , there's no output.

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

IncludeEqual displays the matches between the reference and difference objects.

By default, the output also includes the differences between the reference and difference objects.

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

When you use the PassThru parameter, \`Compare-Object\` omits the PSCustomObject wrapper around the compared objects and returns the differing objects, unchanged.

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
You can send an object down the pipeline to the DifferenceObject parameter.

## OUTPUTS

### None
If the reference object and the difference object are the same, there's no output, unless you use the IncludeEqual parameter.

### System.Management.Automation.PSCustomObject
If the objects are different, \`Compare-Object\` wraps the differing objects in a \`PSCustomObject\` wrapper with a SideIndicator property to reference the differences.

When you use the PassThru parameter, the Type of the object is not changed but the instance of the object returned has an added NoteProperty named SideIndicator .
SideIndicator shows which input object the output belongs to.

## NOTES
When using the PassThru parameter, the output displayed in the console may not include the SideIndicator property.
The default format view of the for the object type output by \`Compare-Object\` does not include the SideIndicator property.
For more information see Example 3 (#ex3)in this article.

## RELATED LINKS

[https://powershellone.wordpress.com/2021/03/16/extending-powershells-compare-object-to-handle-custom-classes-and-arrays/](https://powershellone.wordpress.com/2021/03/16/extending-powershells-compare-object-to-handle-custom-classes-and-arrays/)

[Online Version:](https://docs.microsoft.com/powershell/module/microsoft.powershell.utility/compare-object?view=powershell-5.1&WT.mc_id=ps-gethelp)

[about_Calculated_Properties]()

[ForEach-Object]()

[Group-Object]()

[Measure-Object]()

[New-Object]()

[Select-Object]()

[Sort-Object]()

[Tee-Object]()

[Where-Object]()

[Get-Process]()

















