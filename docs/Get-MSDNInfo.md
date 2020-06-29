# Get-MSDNInfo

## SYNOPSIS
Opens the MSDN web page of an object member: type, method or property.

## Script file
Utils\Get-MSDNInfo.ps1

## SYNTAX

### Type (Default)
```
Get-MSDNInfo [-InputObject] <Object> [-Name <String>] [-MemberType <String>] [-Culture <String>]
```

### List
```
Get-MSDNInfo [-InputObject] <Object> [-List]
```

## DESCRIPTION
The Get-MSDNInfo function enables you to quickly open a web browser to the MSDN web
page of any given instance of a .NET object.
You can also refer to Get-MSDNInfo by its alias: 'msdn'.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$ps = Get-Process -Id $pid


PS\> $ps | Get-MSDNInfo -List

Description
-----------	
The first command store the current session process object in a variable named $ps.
The variable is piped to Get-MSDNInfo which specifies the List parameter.
The result is a list of the process object members.
```
### -------------------------- EXAMPLE 2 --------------------------
```
$date = Get-Date


PS\> Get-MSDNInfo -InputObject $date -MemberType Property

  
Enter the Property item number ( Between 1 and 16.
Press CTRL+C to cancel):


Description
-----------
The command gets all the properties of the date object and prints a numbered menu. 
You are asked to supply the property item number.
Once you type the number and press the Enter key, the function 
invokes the given property web page in the default browser.
```
### -------------------------- EXAMPLE 3 --------------------------
```
$date = Get-Date


PS\> Get-MSDNInfo -InputObject $date

Description
-----------	
Opens the web page of the object type name.
```
### -------------------------- EXAMPLE 4 --------------------------
```
Get-Date | Get-MSDNInfo -Name DayOfWeek -MemberType Property


Description
-----------		
If you know the exact property name and you don't want the function to print the numbered menu then 
you can pass the property name as an argument to the MemberType parameter.
This will open the MSDN 
web page of the DayOfWeek property of the DateTime structure.
```
### -------------------------- EXAMPLE 5 --------------------------
```
$winrm = Get-Service -Name WinRM


PS\> $winrm | msdn -mt Method

  TypeName: System.ServiceProcess.ServiceController

Enter the Method item number ( Between 1 and 18.
Press CTRL+C to cancel):


Description
-----------
The command prints a numbered menu of the WinRM service object methods.
You are asked to supply the method item number.
Once you type the number and press the Enter
key, the function invokes the given method web page in the default browser.
The command also uses the 'msdn' alias of the function Get-MSDNInfo and the alias 'mt' of the MemberType parameter.
```
### -------------------------- EXAMPLE 6 --------------------------
```
$date | Get-MSDNInfo -Name AddDays -MemberType Method


Description
-----------		
Opens the page of the AddDays DateTime method.
```
## PARAMETERS

### -InputObject
Specifies an instance of a .NET object.

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

### -Name
Specifies one member name (type, property or method name).

```yaml
Type: String
Parameter Sets: Type
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MemberType
Specifies the type of the object member. 
Possible values are: 'Type','Property','Method' or their shortcuts: 'T','M','P'. 
The default value is 'Type'.

```yaml
Type: String
Parameter Sets: Type
Aliases: mt

Required: False
Position: Named
Default value: Type
Accept pipeline input: False
Accept wildcard characters: False
```

### -Culture
If MSDN has localized versions then you can use this parameter with a value of the localized 
version culture string.
The default value is 'en-US'.
The full list of cultures can be found by 
executing the following command:

PS \> \[System.Globalization.CultureInfo\]::GetCultures('AllCultures')

```yaml
Type: String
Parameter Sets: Type
Aliases: 

Required: False
Position: Named
Default value: En-US
Accept pipeline input: False
Accept wildcard characters: False
```

### -List
The List parameter orders the function to print a list of the incoming object's methods and properties.
You can use the List parameter to get a view of the object members that the function support.

```yaml
Type: SwitchParameter
Parameter Sets: List
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
AUTHOR: Shay Levy
Tags\<\>: msdn

## RELATED LINKS

[http://blogs.microsoft.co.il/blogs/ScriptFanatic/](http://blogs.microsoft.co.il/blogs/ScriptFanatic/)













