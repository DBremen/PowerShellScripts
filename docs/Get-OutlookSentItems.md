# Get-OutlookSentItems

## SYNOPSIS
Get emails in "Sent Items"

## Script file
Utils\Get-OutlookSentItems.ps1

## SYNTAX

```
Get-OutlookSentItems [[-LastXDays] <Int32>] [-Group]
```

## DESCRIPTION
The function retrieves emails or the count of emails in the Outlook "Sent Items" folder via COM object.
   To workaround a problem when Outlook and PowerShell are running as Admin it uses another custom function 
   Start-ProcessUnelvated (can be found in this Module) to open another unelevated PowerShell prompt if Outlook 
   is currently running and the current PowerShell session is elevated.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
#Get all sent emails for the last 5 days


Get-OutlookSentItems
```
### -------------------------- EXAMPLE 2 --------------------------
```
#Get the count of emails per day for the last 7 days


Get-OutlookSentItems -LastXDays 7 -Group
```
## PARAMETERS

### -LastXDays
The last x days (betwenn 1-30) the Sent Emails should be retrieved for.
By default the last five days are retrieved.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: 

Required: False
Position: 1
Default value: 5
Accept pipeline input: False
Accept wildcard characters: False
```

### -Group
Switch parameter.
If used only the count of emails per day is returned instead of the individual items.

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





