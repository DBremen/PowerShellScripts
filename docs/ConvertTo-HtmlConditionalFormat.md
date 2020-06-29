# ConvertTo-HtmlConditionalFormat

## SYNOPSIS
Function to convert PowerShell objects into an HTML table with the option to format individual table cells based on property values using CSS selectors.

## Script file
format output\ConvertTo-HtmlConditionalFormat.ps1

## SYNTAX

```
ConvertTo-HtmlConditionalFormat [[-InputObject] <Object>] [[-ConditionalFormat] <Hashtable>] [[-Path] <Object>]
 [-Open]
```

## DESCRIPTION
Individual table cells can be formatted using a hashtable with one or multiple condition (of property to be met)/Property/css style to apply.
(see example)

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$Path="$env:TEMP\test.html"


#build the hashtable with Condition (of property to be met)/Property/css style to apply
      $ht=@{}
      $upperLimit=1000
      $ht.Add("\[int\]\`$_.Value -gt $upperLimit",("Handles","color:green;font-weight: bold"))
      $ht.Add('\[int\]$_.Value -lt 50',("Handles","background-color:red"))
      $ht.Add('$_.Value -eq "rundll32"',("Name","background-color:blue"))
      ConvertTo-HtmlConditionalFormat (Get-Process | select Name, Handles) $ht $Path -open
```
### -------------------------- EXAMPLE 2 --------------------------
```
$Path="$env:TEMP\test.html"


#build the hashtable with Condition (of property to be met)/Property/css style to apply
      $ht=@{}
      $ht.Add('$_.Value -eq ".txt"',("Extension","background-color:blue"))
      $ht.Add('$_.Value -eq ".bmp"',("Extension","background-color:red"))
      ConvertTo-HtmlConditionalFormat (dir | select FullName,Extension,Length,LastWriteTime) $ht $Path -open
```
### -------------------------- EXAMPLE 3 --------------------------
```
$Path="$env:TEMP\test.html"


#create some test object with a 'Compliant' property
$WindowsFeaturesCompliance = 
    foreach ($i in 1..10){
        $compliance = "***NON COMPLIANT***"
        if ($i % 2){
            $compliance = "Compliant"
        }
        New-Object PSObject -Property @{'ItemNumber'=$i;'Compliant'=$compliance}
    }
$ht=@{}
$NonCompliant = "***NON COMPLIANT***"
$ht.Add("\`$_.Value -like '$NonCompliant'",("Compliant","color:Red;font-weight: bold")) 
ConvertTo-HtmlConditionalFormat ($WindowsFeaturesCompliance) $ht $Path -open
```
## PARAMETERS

### -InputObject
The object(s) to convert into a HTML table (no pipeline input).

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

### -ConditionalFormat
A hashtable with entries following the following format (see example):
      - Key = Predicate representing the condition as string
      - Value = String array with two entries
        - Property to be formatted
        - Format as CSS selector

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases: 

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
{{Fill Path Description}}

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Open
{{Fill Open Description}}

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

[http://stackoverflow.com/questions/4559233/technique-for-selectively-formatting-data-in-a-powershell-pipeline-and-output-as](http://stackoverflow.com/questions/4559233/technique-for-selectively-formatting-data-in-a-powershell-pipeline-and-output-as)







