# Select-ObjectX

## SYNOPSIS
Proxy function for Select-Object providing easier syntax for calculated properties.

## Script file
Extend Builtin\Simplified-Select.ps1

## Related blog post
https://powershellone.wordpress.com/2015/11/23/simplified-syntax-for-calculated-properties-with-select-object/

## SYNTAX

### DefaultParameter (Default)
```
Select-ObjectX [-InputObject <PSObject>] [[-Property] <Object[]>] [-ExcludeProperty <String[]>]
 [-ExpandProperty <String>] [-Unique] [-Last <Int32>] [-First <Int32>] [-Skip <Int32>] [-Wait]
```

### SkipLastParameter
```
Select-ObjectX [-InputObject <PSObject>] [[-Property] <Object[]>] [-ExcludeProperty <String[]>]
 [-ExpandProperty <String>] [-Unique] [-SkipLast <Int32>]
```

### IndexParameter
```
Select-ObjectX [-InputObject <PSObject>] [-Unique] [-Wait] [-Index <Int32[]>]
```

## DESCRIPTION
What I find confusing about the syntax for calculated properties for the built-in Select-Object,
is the fact that we need two key/value pairs in order to actually provide a name and a value. 
In my humble opinion it would make more sense if the Property parameter syntax for calculated properties would only require
Name=Expression instead of Name='Name' and Expression = {$_.Expression}. 
With this proxy function one can do just that.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-ChildItem | Select-ObjectX Name, CreationTime,  @{Kbytes={$_.Length / 1Kb}}
```
### -------------------------- EXAMPLE 2 --------------------------
```
Get-ChildItem | Select-ObjectX Name, @{Age={ (((Get-Date) - $_.CreationTime).Days) }}
```
## PARAMETERS

### -InputObject
{{Fill InputObject Description}}

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Property
Specifies the properties to select.
Wildcards are permitted.
The value of the Property parameter can be a new calculated property.
To create a calculated, property, use a hash table. 
The entries of the table should consists of Name=Expression entries

```yaml
Type: Object[]
Parameter Sets: DefaultParameter, SkipLastParameter
Aliases: 

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExcludeProperty
Removes the specifies properties from the selection.
Wildcards are permitted.
This parameter is effective only when the command also includes the 
Property parameter.
The value of the property parameter can be a calculated property, which is a hash table that specifies a name and calculates a value for the 
property display.
Valid keys are:

-- Name or Label \<string\>
-- Expression \<string\> or \<scriptblock\>

```yaml
Type: String[]
Parameter Sets: DefaultParameter, SkipLastParameter
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExpandProperty
Specifies a property to select, and indicates that an attempt should be made to expand that property. 
Wildcards are permitted in the property 
name.

```yaml
Type: String
Parameter Sets: DefaultParameter, SkipLastParameter
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Unique
Specifies that if a subset of the input objects has identical properties and values, only a single member of the subset will be selected.
This parameter is case-sensitive.
As a result, strings that differ only in character casing are considered to be unique.

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

### -Last
Specifies the number of objects to select from the end of an array of input objects.

```yaml
Type: Int32
Parameter Sets: DefaultParameter
Aliases: 

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -First
{{Fill First Description}}

```yaml
Type: Int32
Parameter Sets: DefaultParameter
Aliases: 

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Skip
{{Fill Skip Description}}

```yaml
Type: Int32
Parameter Sets: DefaultParameter
Aliases: 

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -SkipLast
The value of the property parameter can be a calculated property, which is a hash table that specifies a name and calculates a value for the 
property display.
Valid keys are:

-- Name or Label \<string\>

-- Expression \<string\> or \<scriptblock\>

```yaml
Type: Int32
Parameter Sets: SkipLastParameter
Aliases: 

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Wait
Turns off optimization.
Windows PowerShell runs commands in the order that they appear in the command pipeline and lets them generate all 
objects.
By default, if you include a Select-Object command with the First or Index parameters in a command pipeline, Windows PowerShell stops 
the command that generates the objects as soon as the selected number of objects is generated.

This parameter is introduced in Windows PowerShell 3.0.

```yaml
Type: SwitchParameter
Parameter Sets: DefaultParameter, IndexParameter
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Index
{{Fill Index Description}}

```yaml
Type: Int32[]
Parameter Sets: IndexParameter
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://powershellone.wordpress.com/2015/11/23/simplified-syntax-for-calculated-properties-with-select-object/](https://powershellone.wordpress.com/2015/11/23/simplified-syntax-for-calculated-properties-with-select-object/)





