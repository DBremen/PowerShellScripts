# Invoke-Parallel

## SYNOPSIS
Execute a scriptblock in parallel using runspaces taking pipeline input.

## Script file
Utils\Invoke-Parallel.ps1

## SYNTAX

```
Invoke-Parallel [-Pipeline] <Object> [-ScriptBlock <Object>]
 [-DictParamList <System.Collections.Generic.Dictionary`2[System.String,System.Object]>] [-Module <Object>]
 [-ThrottleLimit <Object>]
```

## DESCRIPTION
This is based on Tobias Weltner's excellent Efficient PowerShell online presentation

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
$params=New-Object 'system.collections.generic.dictionary[string,object]'


$params.Add("multi",2)
1..10 | Invoke-Parallel -scriptBlock {$_* $multi} -dictParamList $params
```
### -------------------------- EXAMPLE 2 --------------------------
```
$sb={param($num) ("$num :this is a quite long text.`n" * ($num*500))  | set-content -Path "c:\$num.txt"}


1..10 | Loop-Parallel -scriptblock $sb
  
pipeline element should be first function parameter for the function to execute in parallel
```
## PARAMETERS

### -Pipeline
The input to execute the scriptblock against in parallel.

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

### -ScriptBlock
The code to execute in paralllel.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DictParamList
Parameters passed and referenced by the scriptblock should be of type \[system.collections.generic.dictionary\[string,object\]\].

```yaml
Type: System.Collections.Generic.Dictionary`2[System.String,System.Object]
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Module
Module(s) to be imported so that they can be referenced by the code in the scriptblock.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ThrottleLimit
Number of parallel runspaces to use.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: 10
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS





