function Get-HelpSyntax {
    <#    
    .SYNOPSIS
        Get the syntax for a cmdlet pretty printed + explanation
    .DESCRIPTION
        Splits Get-Command CMD -Syntax output based on Regex (seen at PowerShell Conf EU I believe from Stefan Gustavson).
        Adds explanatory text on the syntax of the syntax
	.PARAMETER Command
		Name of the command to get the syntax for.
	.EXAMPLE
		Get-HelpSyntax Get-Command
    .LINK
        https://powershellone.wordpress.com/2018/07/25/powershell-get-command-syntax-output-explained/
    #>
    [CmdletBinding()]
    Param(
        # Param1 help description
        [Parameter(Mandatory, 
            ValueFromPipeline = $false,
            Position = 0
        )]
        $Command)

    
    'Parameters are listed in order of their positional index (e.g. position=0 first)'
    $htDescription = @'
[[-PARAMNAME] <PARAMVALUE>] = An optional parameter that can be used by position or name:
[-PARAMNAME <PARAMVALUE>] = An optional parameter that can only be used by name:
[-PARAMNAME] <PARAMVALUE> = A required parameter that can be used by position or name:
-PARAMNAME <PARAMVALUE> = A required parameter that can be used only by name:
[PARAMNAME] = A switch parameter (switches are always optional and can only be used by name)
'@ | ConvertFrom-StringData
    '-' * 120
    $htDescription.GetEnumerator() | foreach {
        [PSCustomObject]@{Syntax = $_.Key; Description = $_.Value}
    }
    '-' * 120

    if ((Get-Command $Command).CommandType -eq 'Alias') {
        $syntax = (Get-Command -syntax (Get-Command $Command).ResolvedCommandName)
    }
    else {
        $syntax = (Get-Command -syntax $Command) 
    }
	$parameterSets = @((Get-Command $Command).parametersets.Name)
	$syntax = ($syntax -split ' (?=(\[{1,2}[-<]|-))' -replace '^[\[-]', '   $0').where{$_ -match '.*\w'}
	if ($parameterSets[0] -eq '__AllParameterSets'){
		$syntax
	}
	else{
		$syntax = (($syntax -join "`r`n").Trim() -split "($command)").where{$_.Trim() -ne ''}
		$i = 0
		$syntax | foreach {
			if ($_.Trim() -eq $command){
				"`nParameterSet:$($parameterSets[$i])"
				$_
				$i++
			}
			else{ $_.TrimEnd() } 
		}
	}
}
