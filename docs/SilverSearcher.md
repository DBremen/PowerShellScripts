# SilverSearcher

## SYNOPSIS
PowerShell wrapper around silver searcher (ag.exe)
Recursively search for PATTERN in PATH.
Like grep or ack, but faster.

## Script file
Binary wrapper\SilverSearcher.ps1

## SYNTAX

```
SilverSearcher [-Pattern] <Object> [[-Path] <Object>] [-Context <Object>] [-PathPattern <Object>]
 [-Depth <Object>] [-CountOnly] [-SimpleMatch] [-List] [-CaseSensitive] [-NoRecurse] [-FollowSymLinks]
 [-NotMatch] [-FullWord] [-SearchZip] [-Include <String[]>] [-Exclude <String[]>] [-FullLine]
```

## DESCRIPTION
PowerShell wrapper around silver searcher (ag.exe)
Recursively search for PATTERN in PATH.
Like grep or ack, but faster.
This function requires ag.exe (Silver Searcher).
Either change the path on line 82 to the location of ag.exe on your Computer
or install ag.exe via chocolatey "cinst ag"

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```

```
### -------------------------- EXAMPLE 2 --------------------------
```

```
## PARAMETERS

### -Pattern
A regular expression used for searching.

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

### -Path
A file or directory to search.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Context
Show NUM lines before and after each match.
Defaults to 0.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -PathPattern
Limit search to path matching the pattern

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Depth
Depth of recursion: descend at most NUM directories.Defaults to 25.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CountOnly
Only print the number of matches in each file.
(This often differs from the number of matching lines).

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

### -SimpleMatch
Treat the pattern as a literal string.

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

### -List
Only show the paths with at least one match.

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

### -CaseSensitive
Search case sensitively.Default is smart match case insensitively unless PATTERN contains uppercase characters.

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

### -NoRecurse
Do not search within sub-directories.
Overwrites Depth parameter.

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

### -FollowSymLinks
Follow symbolic links

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

### -NotMatch
Invert matching.

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

### -FullWord
Only show matches surrounded by word boundaries.(Same as \b$Pattern\b).

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

### -SearchZip
Search through content of compressed files

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

### -Include
Only search files matching extension(s).

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Exclude
Only search files not matching extension(s).Default @('lnk','exe','bpm','1','log','jar','tis','tii','prx')

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: @('lnk','exe','bpm','1','log','jar','tis','tii','prx')
Accept pipeline input: False
Accept wildcard characters: False
```

### -FullLine
Switch parameter, if specified the entire line of the match is returned.

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

[https://github.com/ggreer/the_silver_searcher/blob/master/doc/ag.1.md](https://github.com/ggreer/the_silver_searcher/blob/master/doc/ag.1.md)





