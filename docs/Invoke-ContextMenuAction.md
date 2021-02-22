# Invoke-ContextMenuAction

## SYNOPSIS
List or permforms verb actions on file system objects that show up in the context menu.

## Script file
Utils\Invoke-ContextMenuAction.ps1

## SYNTAX

```
Invoke-ContextMenuAction [[-Path] <Object>] [[-Verb] <String>] [-List]
```

## DESCRIPTION
Invokes verbs that are in the context menu for the target file system item.
The list of verbs is dynamic depending on what is installed on 
your current system.
Many of the verbs require user interaction but give you the ability to execute them via script.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Invoke-ContextMenuAction


This will list the verbs that are available on the current object (.
or current folder).
```
### -------------------------- EXAMPLE 2 --------------------------
```
Invoke-ContextMenuAction -Path "\\server\share\directory" -Verb Properties


This will open the properties window for the \\\\server\share\directory.
```
### -------------------------- EXAMPLE 3 --------------------------
```
Invoke-ContextMenuAction -Path "C:\TestDir" -Verb Cut; Invoke-ContextMenuAction -Path "\\server\share" -Verb Paste


The copy, cut, and paste actions allow you to move items as you would using keystrokes or the mouse.
```
## PARAMETERS

### -Path
Path to invoke the context menu action for.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: FullName

Required: False
Position: 1
Default value: .
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Verb
Action to invoke from the context menu of the selected item.
If no argument is provided the command will list the available actions for the selected item.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -List
Switch parameter if provided lists the available actions for the selected item.

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
Created by: Allan Miller at CHLA
Version: 1.0
Date: 12/20/2010
I created this function to handle advanced file permission changes to files or folders when my fellow administrators transition to handling 
them via the command line.
Since we use dual account administration, it is not easy to manage the permission 
on a series of folders that are in a drive mapping of your standard user.

## RELATED LINKS







