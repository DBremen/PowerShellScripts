# Add-ScriptHelpISEAddOn

## SYNOPSIS
Function to create an ISE Add-On that will generate comment based help for functions.
The functions requires the Show-UI module.

## Script file
Utils\Add-ScriptHelpISEAddOn.ps1

## Related blog post
https://powershellone.wordpress.com/2015/09/28/create-an-integrated-wpf-based-ise-add-on-with-powershell/

## SYNTAX

```
Add-ScriptHelpISEAddOn [-DllPath] <Object> [-GenerateDll]
```

## DESCRIPTION
Creates an ISE Add-On that integrates itself graphically in a similar way as the built-in Show-Command Add-On (using the VerticalAddOnTools pane) 
without having to use Visual Studio and writing the code in C#.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
#Generate the dll (needed only once)


Add-ScriptHelpISEAddOn -Dll-GenerateDll
      #optionally add the following to your profile in order to load the script automaticaly on ISE startup and add an entry in the Add-ons menu
      if ($host.Name -eq 'Windows PowerShell ISE Host'){
           Add-ScriptHelpISEAddOn -DllPath \<PATH TO GENERATED DLL\>
       }
```
## PARAMETERS

### -DllPath
Path of the dll file that the function either generates (using -GenerateDll switch) or loads (see example). 
      Defaults to "$env:USERPROFILE\Desktop\AddScriptHelp.dll".

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: "$env:USERPROFILE\Desktop\AddScriptHelp.dll"
Accept pipeline input: False
Accept wildcard characters: False
```

### -GenerateDll
Switch to indicate whether the function should Generate the dll and run the ISE Add-On or just run the ISE Add-On.(see example)

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://powershellone.wordpress.com/2015/09/28/create-an-integrated-wpf-based-ise-add-on-with-powershell/](https://powershellone.wordpress.com/2015/09/28/create-an-integrated-wpf-based-ise-add-on-with-powershell/)



