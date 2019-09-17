# Get-ESSearchResult

## SYNOPSIS
PowerShell wrapper around Everything search command line (es.exe).

## Script file
Binary wrapper\Get-ESSearchResult.ps1

## Related blog post
https://powershellone.wordpress.com/2015/02/28/using-everything-search-command-line-es-exe-via-powershell/

## SYNTAX

```
Get-ESSearchResult [-SearchTerm] <Object> [-OpenItem] [-CopyFullPath] [-OpenFolder] [-AsObject]
```

## DESCRIPTION
Get-ESSearchResult function (alias search) searches for all items containing the search term (SearchTerm parameter is the only mandatory parameter). 
The search results (if multiple) are piped to Out-GridView with the -PassThru option enabled so that the result can be seen in GUI and one or multiple items 
from within the search results can be selected.
By default (no switches turned on) the selected item(s) 
are converted to FileSystemInfo objects and their Name, DirectoryName, FileSize and LastModifiedDate are output. 
The resulting objects can be used for further processing (copying, deleting….)

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
search 'mySearchTerm'
```
## PARAMETERS

### -SearchTerm
The search term to search for see es.exe syntax for options.

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

### -OpenItem
Switch enabled = Invoke the selected item(s) (only applies to files not folders).

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

### -CopyFullPath
Switch enabled = Copy the full Path of the selected item to the clipboard.

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

### -OpenFolder
Switch enabled = Opens the folder(s) that contain(s) the selected item(s) in windows explorer

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

### -AsObject
Switch enabled = Similar to default output but the full FileSystemInfo objects related to the selected item(s) are output

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

[https://powershellone.wordpress.com/2015/02/28/using-everything-search-command-line-es-exe-via-powershell/](https://powershellone.wordpress.com/2015/02/28/using-everything-search-command-line-es-exe-via-powershell/)

[https://www.voidtools.com/support/everything/command_line_interface/](https://www.voidtools.com/support/everything/command_line_interface/)



