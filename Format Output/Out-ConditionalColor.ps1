function Out-ConditionalColor{
     <#    
        .SYNOPSIS
            Filter to conditionally format PowerShell output. The approach seems to have stopped working since v3 and higher.
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
        .LINK
            Out-ConditionalColorProperties
    #>
    param(
		[System.Collections.Hashtable]$ConditionColor
    )
	$color=$null
	$fgc=$Host.UI.RawUI.ForegroundColor;
    foreach($key in $ConditionColor.Keys){
		$sb=[scriptblock]::Create($key)
		if(&$sb){$color=$ConditionColor.$key}
	}
	if ($color){
        $Host.UI.RawUI.ForegroundColor=$color
    }
	$_
    $Host.UI.RawUI.ForegroundColor=$fgc
}


