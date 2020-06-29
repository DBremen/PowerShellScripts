# ForeachFor2

## SYNOPSIS
Function to step through two series of values in two collections and run commands against them.

## Script file
Utils\ForeachFor2.ps1

## SYNTAX

```
ForeachFor2 [[-AliasName] <Object>] [[-In] <Object>] [[-AliasName2] <Object>] [[-In2] <Object>]
 [[-scriptBlock] <Object>]
```

## DESCRIPTION
This works similar to the built-in foreach (get-help about_foreach) loop but allows iterating through two collections at the same time.
Simulating the C# Linq zip functionality. 
The collections don't necessarily be of the same length since the loop stops when of the collections is exhausted.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$users=@"


Name,ID
Jones,1
Burnes,2
Hayes,3
"@ | ConvertFrom-Csv

$addresses=@"
ID,City
1,Berlin
2,NewYork
3,Lima
"@ | ConvertFrom-Csv
#note the subtle differences in the syntax compared to the built-in foreach loop 
#(no parenthesis, variables don't have dollar sign since they are arguments)

foreachfor2 user -In $users address -In2 $addresses {
if ($user.ID -eq 2){
$user.Name="Burnes-Dellinger"
$address.City="Washington"
}
}
```
### -------------------------- EXAMPLE 2 --------------------------
```
$users | Out-Host


$addresses | Out-Host

$names=echo Peter,Mary,Paul,John
$ages=35,44,23,41,44,56
#only ages up-to the length of $names or assigned
foreachfor2 name -In $names age -In2 $ages {
	New-Object PSObject -Property @{Name=$name;Age=$age}
}
```
## PARAMETERS

### -AliasName
variable name that referes to the first collection.
Prior the each iteration the loop, the variable is set to a value in the first collection

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

### -In
first collection to iterate through

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

### -AliasName2
variable name that referes to the second collection.
Prior the each iteration the loop, the variable is set to a value in the second collection

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

### -In2
second collection to iterate through

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

### -scriptBlock
scriptBlock to be run against both collections

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS





