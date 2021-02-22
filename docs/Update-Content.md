# Update-Content

## SYNOPSIS
Insert text on a new line after the line matching the StartPattern or replace text between start- and end Pattern within a file

## Script file
Data Wrangling\Update-Content.ps1

## SYNTAX

```
Update-Content [[-Path] <Object>] [[-StartPattern] <Object>] [[-EndPattern] <Object>] [[-Content] <Object>]
```

## DESCRIPTION
This is a function to insert new text within the body of a text file using regular expression replace substitution. 
The insertion points are identified by the provided StartPattern and the optional EndPattern which can be normal strings or regular expressions.
In case no EndPattern is provided the new text is appended on a new line after the line matching the StartPattern. 
In case both patterns are provided the new text is inserted between the line matching the StartPattern and the EndPattern 
replacing any existing text between the lines matching the patterns.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
#replace text between the lines starting with "//start" and "//end"


##text before:
#some text
#//start
#text
#text
#//end

Update-Content $Path "^//start" "^//end" "this is new stuff"

##text afterwards:
#some text
#//start
#this is new stuff
#//end
```
### -------------------------- EXAMPLE 2 --------------------------
```
#append text on a new line after the line starting with "//start"


##text before:
#some text
#//start
#text
#text

Update-Content $Path "^//start" "new text"

##text before:
#some text
#//start
#new text
#text
#text
```
## PARAMETERS

### -Path
Path to the file to be updated

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

### -StartPattern
pattern of the start line where the new Content is appended

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

### -EndPattern
pattern of the end line where the new Content is inserted

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

### -Content
text to be inserted

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





