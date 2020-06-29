# Start-ProcessUnelevated

## SYNOPSIS
Function to start a process unelevated from an elevated command prompt

## Script file
Utils\Start-ProcessUnelevated.ps1

## SYNTAX

```
Start-ProcessUnelevated [-FilePath] <String> [-ArgumentList] <String> [-WorkingDirectory <String>]
```

## DESCRIPTION
Function to start a process unelevated from an elevated command prompt. 
Use case for me is starting an unelevated to execute outlook com scripts against an unelevated outlook from an elevated powershell prompt.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
#start powershell to run a function


'powershell.exe','-noexit -command Get-Process | select name,id -First 10'
```
## PARAMETERS

### -FilePath
Specifies the path and file name of the program to run.
Enter the name of an executable file or of a document, such as a .txt or .doc file, that is
associated with a program on the computer.
This parameter is required.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ArgumentList
Specifies parameters or parameter values to use when this cmdlet starts the process.
The argumentlist is to be provided as a string.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WorkingDirectory
Specifies the location of the executable file or document that runs in the process.
The default is the current folder.

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

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://stackoverflow.com/questions/17765568/how-to-start-a-process-unelevated](https://stackoverflow.com/questions/17765568/how-to-start-a-process-unelevated)



