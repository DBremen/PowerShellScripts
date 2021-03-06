function ForeachFor2{
<#
    .SYNOPSIS
        Function to step through two series of values in two collections and run commands against them.
        
    .DESCRIPTION
		This works similar to the built-in foreach (get-help about_foreach) loop but allows iterating through two collections at the same time.
		Simulating the C# Linq zip functionality. 
		The collections don't necessarily be of the same length since the loop stops when of the collections is exhausted. 
		
    .PARAMETER Url
        Source Url of the file to download.
    
    .PARAMETER AliasName
        variable name that referes to the first collection. Prior the each iteration the loop, the variable is set to a value in the first collection
		
	.PARAMETER In
		first collection to iterate through
		
	.PARAMETER AliasName2
		variable name that referes to the second collection. Prior the each iteration the loop, the variable is set to a value in the second collection
	
	.PARAMETER In2
		second collection to iterate through
     
	.PARAMETER scriptBlock
		scriptBlock to be run against both collections
		
    .EXAMPLE  
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
          
    .EXAMPLE  
$users | Out-Host
$addresses | Out-Host

$names=echo Peter,Mary,Paul,John
$ages=35,44,23,41,44,56
#only ages up-to the length of $names or assigned
foreachfor2 name -In $names age -In2 $ages {
	New-Object PSObject -Property @{Name=$name;Age=$age}
}
		
#>
    [cmdletbinding()]
    param($AliasName,$In,$AliasName2,$In2,$scriptBlock)
	
	#add a param block to the $scriptBlock in order to be able to refer to the AliasNames within the scripblock
	$newSB=[scriptblock]::Create('param($' + $AliasName + ',$' + $AliasName2 + ')' + $scriptBlock )
	#use SZArrayEnumerator to loop through the collections
	for ($($enum1 = $In.GetEnumerator();$enum2 = $In2.GetEnumerator()); ($enum1.MoveNext() -and $enum2.MoveNext())){
		#invoke the scriptBlock passing the current values of the collections
		&  $newSB $enum1.Current $enum2.Current
	}
}
