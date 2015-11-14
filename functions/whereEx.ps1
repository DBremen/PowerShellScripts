function whereEx { 
    [CmdletBinding()]
     Param
    (
        [Parameter(ValueFromPipeline=$true)]
        $InputObject,
     
        [Parameter(Mandatory=$true,
                   Position=0)]
        $predicateString
    )
    Begin{
        try{
            $predicate = [ScriptBlock]::Create($predicateString)
        }
        catch{
            $errors = $null
            $oldTokens = [System.Management.Automation.PSParser]::Tokenize($predicateString, [ref]$errors)
            $errors = $tokens = $null
            $AST= [Management.Automation.Language.Parser]::ParseInput($predicateString, [ref]$tokens, [ref]$errors)
            #join the start from the old parser output with the AST parser output
            for ($i=0; $i -lt $tokens.Count-1;$i++){
                Add-Member -InputObject $tokens[$i] -type NoteProperty -name 'Start' -value $oldTokens[$i].Start
            }
            $openParens = $tokens | where Kind -eq 'LParen'
            foreach ($openParen in $openParens){
                $closeParen = ($tokens | where {$_.Kind -eq 'RParen' -and $_.Start -gt $openParen.Start} | sort -Descending)[0]
                $tokensInBlock = $tokens | where {$_.Start -gt $openParen.Start -and $_.Start -lt $closeParen.Start}
                $variableTxt = ($tokens[[Array]::IndexOf($tokens, $openParens) - 1]).Text
                #check if we are dealing with qualified membernames (e.g. $_.Name)
                if (!$variableTxt.StartsWith('$')){
                    #go back until variable is found and join the txt
                    $variable = ($tokens | where {$_.Start -lt $openParen.Start -and $_.Kind -eq 'Variable'} | sort Start -Descending)[0]
                    $name = ($tokens | where {$_.Start -lt $openParen.Start -and $_.Start -gt $variable.Start}).Text
                    $variableTxt = $variable.Text + ($name -join '')
                }

                #check for consecutive parameter tokens
                $operators = $tokensInBlock | where {$_.Kind -eq 'Parameter' -and $_.Text -ne '-not'} 
                foreach ($operator in $operators ){
                    $nextToken =  $tokens[[Array]::IndexOf($tokens, $operator) + 1]
                    if ($nextToken.Kind -eq 'Parameter'){
                        #insert variable into predicate string
                        $predicateString = $predicateString.Insert($nextToken.Start, "$($variableTxt) ")
                    }
                }
            }
            #remove the parentheses and rebuild the scriptBlock
            $predicateString = $predicateString.Replace('(','').Replace(')','')
            $predicate = [ScriptBlock]::Create($predicateString)
        }
    }
    Process{
        $_ | where $predicate
    }
}


1..10 | whereEx '$_ (-gt 5 -and -lt 8)'
Get-Process | whereEx '$_.Name (-like "power*" -and -notlike "*ise")'