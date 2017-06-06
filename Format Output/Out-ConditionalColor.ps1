filter Out-ConditionalColor{
     <#    
        .SYNOPSIS
            Filter to conditionally format PowerShell output within the PowerShell console. 
        .DESCRIPTION
            Filter to conditionally format PowerShell output. Does not turn the output into string.
        .PARAMETER ConditionColor
		    HashTable:
                - Key(s) = Predicate representing the condition as string
                - Value(s) = The foreground color to be applied to the items matching the condition ([ConsoleColor])
	    .EXAMPLE
		    #build the hashtable with condition/color pairs
            $ht=@{}
            $upperLimit=1000
            $ht.Add("`$_.handles -gt $upperLimit",[ConsoleColor]::Red)
            $ht.Add('$_.handles -lt 50',[ConsoleColor]::Green)
            $ht.Add('$_.Name -eq "svchost"',[ConsoleColor]::Blue)
            Get-Process | Out-ConditionalColor -conditionColor $ht
            #proof that we are still working with objects 
            Get-Process | Out-ConditionalColor -conditionColor $ht | where {$_.Name -eq 'svchost'}
        .LINK
            Out-ConditionalColorProperties
    #>
    param(
		[System.Collections.Hashtable]$ConditionColor
    )
    if ($host.Name -ne 'ConsoleHost'){
        Write-Warning 'Colored output only works with the ConsoleHost'
    }
	$color=$null
	$fgc = [console]::ForegroundColor
    foreach($key in $ConditionColor.Keys){
		$sb=[scriptblock]::Create($key)
		if(&$sb){
            $color = $ConditionColor.$key
        }
	}
	if ($color){
        [console]::ForegroundColor = $color
    }
	$_
    [console]::ForegroundColor = $fgc
}