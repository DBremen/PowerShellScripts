# Compare-File

## SYNOPSIS
A wrapper and extension for the built-in Compare-Object cmdlet to compare two txt based files and receive a side-by-side comparison (including Line numbes).

## Script file
Extend Builtin\Compare-File.ps1

## SYNTAX

```
Compare-File [-ReferenceObject] <Object> [-DifferenceObject] <Object> [-IncludeEqual] [-ExcludeDifferent]
```

## DESCRIPTION
This is based on an idea from Lee Holmes http://www.leeholmes.com/blog/2013/11/29/using-powershell-to-compare-diff-files/.
Generates a line by line comparison of two 
txt based files.
Lines that are present in one file but not in the other are indicated by N/A

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$txt1=@"


will stay
this is some text
more
will be deleted
"@ | Set-Content txt1.txt
$txt2=@"
will stay
added is some text
changed
"@ | Set-Content txt2.txt

Compare-File txt1.txt txt2.txt -IncludeEqual
```
## PARAMETERS

### -ReferenceObject
Path to the file that will be the reference object for the comparison

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

### -DifferenceObject
Path to the file that will be the difference object for the comparison

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

### -IncludeEqual
If specified lines that are equal will be included in the output.

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

### -ExcludeDifferent
If specified lines that are not equal will be excluded from the output.

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



