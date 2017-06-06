#Requires -Version 3
filter Out-ConditionalColorProperties{
     <#    
        .SYNOPSIS
            Filter to conditionally format property values within PowerShell output on the console.
        .DESCRIPTION
            Filter to conditionally format property values within PowerShell output on the console.
        .PARAMETER ConditionColor
		    HashTable:
                - Key(s) = Predicate representing the condition as string
                - Value(s) array of strings
                    - The foreground color to be applied to the items matching the condition ([ConsoleColor])
                    - The property value to highlight
	    .EXAMPLE
		    #build the hashtable with condition/color/"property value to highlight" pairs
            $ht=@{}
            $upperLimit=1000
            $ht.Add("`$_.handles -gt $upperLimit",("red","handles"))
            $ht.Add('$_.handles -lt 50',("green","handles"))
            $ht.Add('$_.Name -eq "svchost"',("blue","name"))
            Get-Process | Out-ConditionalColorProperties -conditionColorProp $ht 
        .EXAMPLE
            $ht=@{}
            $ht.Add('$_.Name.StartsWith("A")',("red","name"))
            dir | Out-ConditionalColorProperties -conditionColorProp $ht 
    #>
    param(
		$ConditionColorProp
    )
	$color=$null
    foreach($key in $ConditionColorProp.Keys){
		$sb=[scriptblock]::Create($key)
		if(&$sb){
			$color=$ConditionColorProp.$key[0]
			$highlightProp=$ConditionColorProp.$key[1]
		}
	}
    if (!$firstPassed){$objString=($_ | Out-String).TrimEnd() }
    else{$objString=((($_ | Out-String) -split "`n") | where {$_.Trim() -ne ""})[-1]}
	if ($color){
		$highlightText=$_.$highlightProp
		$split = $objString -split $highlightText,2
		$found = [regex]::Match( $objString, $highlightText )
		for( $i = 0; $i -lt $split.Count; ++$i ) {
			Write-Host $split[$i] -NoNewline
		    if ($i -lt $found.Count){
				Write-Host $found[$i] -NoNewline -ForegroundColor $color
			}
		}
		Write-Host
	}
	else{
        $objString
	}
    $firstPassed=$true
}

