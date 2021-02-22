# Confirm-Brackets

## SYNOPSIS
Function to check and display (through indentation) pairing of braces, brackets, and parentheses '{\[()\]}

## Script file
programming exercises\Confirm-Brackets.ps1

## SYNTAX

```
Confirm-Brackets [-Code] <Object> [[-Indent] <Object>]
```

## DESCRIPTION
Checks and displays (through indentation color and indicating the number of errors) 
pairing of different forms of brackets according to the following algorithm:
- last unclosed, first closed (LIFO)
- scan expression from left to right 
- add opening parentheses to stack
- if closing bracket
  - check if stack is empty

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Confirm-Brackets '4*(5+3/[8-2]{33])'
```
## PARAMETERS

### -Code
Code to check the pairing of brackets for (no checking of syntax can be any language)

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

### -Indent
Indent to use when displaying the code (defaults to tab ("\`t"))

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

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS



