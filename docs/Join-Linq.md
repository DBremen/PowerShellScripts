# Join-Linq

## SYNOPSIS
Performs an inner join of two object arrays based on a common column.

## Script file
Data Wrangling\Join-Linq.ps1

## SYNTAX

```
Join-Linq [-FirstArray] <Object> [-SecondArray] <Object> [-FirstKey] <Object> [[-SecondKey] <Object>]
```

## DESCRIPTION
This is based of a solution I found on Technet.
See Link.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
#build two object arrays for testing


$Accounts = @'
AccountID,AccountName
1,Contoso
2,Fabrikam
3,LitWare
'@ | ConvertFrom-Csv

$Users = @'
UserID,UserName
1,Adams
1,Miller
2,Nalty
3,Bob
4,Mary
'@ | ConvertFrom-Csv
#perform an inner join based on the id columns
Join-Linq $Accounts $Users 'AccountId' 'UserId'
#output
# AccountID AccountName UserID UserName
# --------- ----------- ------ --------
# 1         Contoso     1      Adams   
# 1         Contoso     1      Miller
# 2         Fabrikam    2      Nalty   
# 3         LitWare     3      Bob
```
## PARAMETERS

### -FirstArray
The first array to join.

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

### -SecondArray
The second array to join.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FirstKey
The property from the first array to join based upon.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SecondKey
The property from the second array to join based upon. 
Defaults to the value provided for FirstJoinProperty.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://social.technet.microsoft.com/Forums/en-US/5fb26b70-ed2d-462f-a38e-43b61adba2b1/merge-two-csvs-with-a-common-column?forum=winserverpowershell](https://social.technet.microsoft.com/Forums/en-US/5fb26b70-ed2d-462f-a38e-43b61adba2b1/merge-two-csvs-with-a-common-column?forum=winserverpowershell)

[https://docs.microsoft.com/en-us/dotnet/api/system.linq.enumerable.join?view=netframework-4.8](https://docs.microsoft.com/en-us/dotnet/api/system.linq.enumerable.join?view=netframework-4.8)



