function Confirm-Brackets {
    <#    
        .SYNOPSIS
            Function to check and display (through indentation) pairing of braces, brackets, and parentheses '{[()]}
        .DESCRIPTION
            Checks and displays (through indentation color and indicating the number of errors) 
            pairing of different forms of brackets according to the following algorithm:
            - last unclosed, first closed (LIFO)
            - scan expression from left to right 
            - add opening parentheses to stack
            - if closing bracket
              - check if stack is empty
	    .PARAMETER Code
            Code to check the pairing of brackets for (no checking of syntax can be any language)
        .PARAMETER Indent
            Indent to use when displaying the code (defaults to tab ("`t"))
	    .EXAMPLE
		    Confirm-Brackets '4*(5+3/[8-2]{33])'
    #>
    [CmdletBinding()]
    param( 
        [Parameter(Mandatory,
            Position = 0)]   
        $Code,
        [Parameter(Position = 1)]
        $Indent = "`t"
    )
    $stack = New-Object System.Collections.Stack
    $openers = '{', '(', '['
    $closers = '}', ')', ']'
    $charArray = $Code.ToCharArray()
    $pos = 0
    $errors = @()
    foreach ($char in $charArray) {
        if ($char -in $openers) {
            $stack.Push(@($char, $pos))
        }
        elseif ($char -in $closers) {
            if ($stack.Count -eq 0) {
                #closing but no more opening
                $errors += $pos
            }
            else {
                if ($char -ne $closers[$openers.IndexOf($stack.Peek()[0].ToString())]) {
                    #closing but no corresponding opening
                    $errors += $pos
                    #get position of corresponding opening
                    $errors += $stack.Peek()[1]
                    $null = $stack.Pop()
                }
                elseif ($stack.Count -gt 0) {
                    $null = $stack.Pop()
                }
            }
        }
        $pos++
    }
    #check for any openings w/o closers
    while ($stack.count -gt 0) {
        $errors += $Code.IndexOf($stack.Pop()[0].ToString())
    }
    $level = 0
    #remove whitespace from the beginning of each line to avoid double indentation
    $Code = $Code -replace '(?m)^\s*(.*)$', '$1'
    #remove crlf after parentheses to avoid doubling new lines
    $Code = $Code -replace '([{}()\[\]])\r\n', '$1'
    for ($i = 0; $i -lt $Code.Length; $i++) {
        $color = "White"
        if ($i -in $errors) {
            $color = "Red"
        }
        if ($Code[$i] -in $openers) {
            Write-Host "`n$($Indent*$level)" -NoNewline
            $level++
        }
        elseif ($Code[$i] -in $closers) {
            if ($level -gt 0) {
                $level--
            }
            Write-Host "`n$($Indent*$level)" -NoNewline
        }
        #indent after new lines/crlf that are part of the string
        if ($Code[$i] -eq "`n" -or $Code[$i] -eq "`r`n") {
            Write-Host "$($Code[$i] + $Indent*$level)" -NoNewline
        }
        else {
            Write-Host $Code[$i] -ForegroundColor $color -NoNewline
        }
        if (($Code[$i] -in $closers) -or ($Code[$i] -in $openers)) {
            Write-Host "`n$($Indent*$level)" -NoNewline
        }
    }
    Write-Host "$($errors.Count) errors found" -ForegroundColor Yellow
}
