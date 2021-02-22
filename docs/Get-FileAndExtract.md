# Get-FileAndExtract

## SYNOPSIS
Function to download and extract files.

## Script file
Utils\Get-FileAndExtract.ps1

## SYNTAX

```
Get-FileAndExtract [[-Url] <Object>] [[-Destination] <Object>] [-NoOverwrite]
```

## DESCRIPTION
Downloads files to the provided destination folder. 
      If the destination folder does not exist it will be created. 
      In case the provided Url ends with .zip the content gets automatically extracted.
      If the .zip contains already a folder with the same name as the .zip file the content is extracted within
      the provided destination, otherwise the content is extracted within a subfolder (with the same name as the
      zip file) of the provided destination. 
      This way the extracted content always ends up within a subfolder of the destination folder.
      Existing files will be overwritten automatically when extracted unless the $NoOverwrite switch is specified.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
#Download SubInACL.msi to Desktop and start installer


Get-FileAndExtract 'http://download.microsoft.com/download/1/7/d/17d82b72-bc6a-4dc8-bfaa-98b37b22b367/subinacl.msi' "$(\[Environment\]::GetFolderPath("Desktop"))"
```
### -------------------------- EXAMPLE 2 --------------------------
```
#Download and extract the contents of SysinternalSuite.zip to Desktop\SysInternalSuite (folder SysInternalSuite is created)


Get-FileAndExtract 'http://download.sysinternals.com/files/SysinternalsSuite.zip' "$(\[Environment\]::GetFolderPath("Desktop"))"
```
### -------------------------- EXAMPLE 3 --------------------------
```
#Download and extract the contents of WorkSmartGuides.zip to Desktop\WorkSmartGuides (no folder is created since .zip already contains folder)


Get-FileAndExtract 'http://download.microsoft.com/download/1/C/2/1C2D966E-F713-4A4F-9D5C-F7FB6E93E4B9/WorkSmartGuides.zip' "$(\[Environment\]::GetFolderPath("Desktop"))\NewFolder"
```
## PARAMETERS

### -Url
Source Url of the file to download.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Destination
Destination folder.

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

### -NoOverwrite
Switch parameter.
If specified dialog is displayed for files being overwritten while extracting.

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







