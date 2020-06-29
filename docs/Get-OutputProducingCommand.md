# Get-OutputProducingCommand

## SYNOPSIS
Get the line(s) of code that produce an output from a function or script.

## Script file
Utils\Get-OutputProducingCommand.ps1

## SYNTAX

```
Get-OutputProducingCommand [-Code] <Object>
```

## DESCRIPTION
This is a slight modified version of the filter created by Dave Wyatt (see link)

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
#create a function for testing and save it to a file


@'
function mytest{
$arrayList = New-Object System.Collections.ArrayList
$null = $arrayList.Add('One')
\[void\] $arrayList.Add('Two')
$arrayList.Add('Three') | Out-Null
$arrayList.Add('Four')
return $true
}
'@ -split "\r?\n" | Set-Content "$env:TEMP\test.ps1"
#dot source the function into the current scope
.
"$env:TEMP\test.ps1"
#just call/invoke the function and pipe it to the function
mytest | Get-OutputProducingCommand
#output exceprt
# Script   Command Line Code
# ------   ------- ---- ----
# test.ps1 mytest     6 $arrayList.Add('Four')
# test.ps1 mytest     7 $true
```
## PARAMETERS

### -Code
{{Fill Code Description}}

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

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://davewyatt.wordpress.com/2014/06/05/tracking-down-commands-that-are-polluting-your-pipeline/](https://davewyatt.wordpress.com/2014/06/05/tracking-down-commands-that-are-polluting-your-pipeline/)



