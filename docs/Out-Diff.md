# Out-Diff

## SYNOPSIS
Generate html diff from git diff output using diff2html.

## Script file
format output\Out-Diff.ps1

## SYNTAX

### Text (Default)
```
Out-Diff [-ReferenceText] <Object> [-DifferenceText] <Object> [-OutputStyle <Object>]
```

### File
```
Out-Diff -ReferenceFile <Object> -DifferenceFile <Object> [-OutputStyle <Object>]
```

## DESCRIPTION
Pretty HTML diff output for text and file input using git diff and diff2html.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
#compare two strings using default outputstyle (sideByside) and diffstyle (word)


Out-Diff 'this is a test' 'this is a new test'
```
### -------------------------- EXAMPLE 2 --------------------------
```
#compare two text files using default outputstyle (sideByside) and diffstyle (word)


Out-Diff -ReferenceFile c:\test.txt -DiffernceFile c:\test2.text
```
### -------------------------- EXAMPLE 3 --------------------------
```
#compare two strings using LineByLine outputstlye and character diffstyle


Out-Diff 'this is a test' 'this is a new test' -OutputStyle LineByLine -DiffStyle char
```
## PARAMETERS

### -ReferenceText
{{Fill ReferenceText Description}}

```yaml
Type: Object
Parameter Sets: Text
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DifferenceText
{{Fill DifferenceText Description}}

```yaml
Type: Object
Parameter Sets: Text
Aliases: 

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReferenceFile
{{Fill ReferenceFile Description}}

```yaml
Type: Object
Parameter Sets: File
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DifferenceFile
{{Fill DifferenceFile Description}}

```yaml
Type: Object
Parameter Sets: File
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutputStyle
{{Fill OutputStyle Description}}

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: SideBySide
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://diff2html.xyz](https://diff2html.xyz)







