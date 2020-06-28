function WhereEx { 
    <#    
    .SYNOPSIS
        POC for a simplified Where-Object with multiple conditions on the same property for PowerShell. 
    .DESCRIPTION
        Allows for avoiding multiple mentions of the property name when using Where-Object with multiple conditions on the same property.
        Parentheses indicate that the preceding variable should be considered as the (left-hand) parameter for the operator. 
        (see Example)
	.PARAMETER InputObject
		The object or collection to filter.
	.PARAMETER PredicateString
		The predicate as a String that determines the filter logic.
        Parentheses indicate that the preceding variable should be considered as the (left-hand) parameter for the operator.  
        (See Example)
	.EXAMPLE
		1..10 | WhereEx {$_ (-gt 5 -and -lt 8)}
    .EXAMPLE
        Get-Process | WhereEx {$_.Name (-like 'power*' -and -notlike '*ise')}
    .LINK
        https://powershellone.wordpress.com/2015/11/02/simplified-where-object-for-multiple-conditions-on-the-same-property-for-powershell/
    #>
    [CmdletBinding()]
    Param
    (
        [Parameter(ValueFromPipeline = $true)]
        $InputObject,
     
        [Parameter(Mandatory = $true,
            Position = 0)]
        $PredicateString
    )
    Begin {
        try {
            $predicate = [ScriptBlock]::Create($PredicateString)
        }
        catch {
            $errors = $null
            $oldTokens = [System.Management.Automation.PSParser]::Tokenize($predicateString, [ref]$errors)
            $errors = $tokens = $null
            $AST = [Management.Automation.Language.Parser]::ParseInput($predicateString, [ref]$tokens, [ref]$errors)
            #join the start from the old parser output with the AST parser output
            for ($i = 0; $i -lt $tokens.Count - 1; $i++) {
                Add-Member -InputObject $tokens[$i] -type NoteProperty -name 'Start' -value $oldTokens[$i].Start
            }
            $openParens = $tokens | where Kind -eq 'LParen'
            foreach ($openParen in $openParens) {
                $closeParen = ($tokens | where { $_.Kind -eq 'RParen' -and $_.Start -gt $openParen.Start } | sort -Descending)[0]
                $tokensInBlock = $tokens | where { $_.Start -gt $openParen.Start -and $_.Start -lt $closeParen.Start }
                $variableTxt = ($tokens[[Array]::IndexOf($tokens, $openParens) - 1]).Text
                #check if we are dealing with qualified membernames (e.g. $_.Name)
                if (!$variableTxt.StartsWith('$')) {
                    #go back until variable is found and join the txt
                    $variable = ($tokens | where { $_.Start -lt $openParen.Start -and $_.Kind -eq 'Variable' } | sort Start -Descending)[0]
                    $name = ($tokens | where { $_.Start -lt $openParen.Start -and $_.Start -gt $variable.Start }).Text
                    $variableTxt = $variable.Text + ($name -join '')
                }

                #check for consecutive parameter tokens
                $operators = $tokensInBlock | where { $_.Kind -eq 'Parameter' -and $_.Text -ne '-not' } 
                foreach ($operator in $operators ) {
                    $nextToken = $tokens[[Array]::IndexOf($tokens, $operator) + 1]
                    if ($nextToken.Kind -eq 'Parameter') {
                        #insert variable into predicate string
                        $predicateString = $predicateString.Insert($nextToken.Start, "$($variableTxt) ")
                    }
                }
            }
            #remove the parentheses and rebuild the scriptBlock
            $predicateString = $predicateString.Replace('(', '').Replace(')', '')
            $predicate = [ScriptBlock]::Create($predicateString)
        }
    }
    Process {
        $_ | where $predicate
    }
}
