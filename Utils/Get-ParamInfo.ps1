
function Get-ParamInfo {
    <#    
      .SYNOPSIS
        Retrieve extensive parameter information about a cmdlet
	  .DESCRIPTION
	  	I don't remember the original source of this script anymore.
        Format the Get-Command information in a way to show info for each parameter for each parameter set of a given cmdlet.
      .PARAMETER Command
        The name of the command to get the parameter info for.
      .PARAMETER VerboseOutput
        Switch to indicate whether parameter info is also shown for commonparameters.
      .EXAMPLE
		Get-ParamInfo Get-Command
    #>
    [CmdletBinding()]
    param ( [string]$Command, [switch]$VerboseOutputOutput)

    # Use the special formatting built to output the results in a palatable way
    # Formatting directives
    $type = @{ label = "Type"; e = { $_.Parametertype.name } }
    $man = @{ label = "Mandatory"; e = { $_.IsMandatory } }
    $pos = @{ label = "Pos"; e = { $_.Positional }; Align = "right" }
    $vp = @{ label = "PipeValue"; e = { $_.ValueFromPipeline } ; width = 10 }
    $vppn = @{ label = "PipeName"; e = { $_.ValueFromPipelineByPropertyName } ; 
        width = 10 
    }
	
    if ((Get-Command $Command).CommandType -eq 'Alias') {
        $Command = (Get-Command $Command).ResolvedCommand.Name
    }
    # show the name of the command
    $Command
    # and the DLL
    $commandInfo = Get-Command $Command
    $commandInfo | Format-List dll, helpfile | Out-Host

    # here are the ubiquitous parameters
    $ub = "ErrorVariable", "ErrorAction", "OutBuffer", "Verbose", "OutBuffer", "Debug"
    # Get the parameter sets and display the interesting info
    foreach ( $pset in $commandInfo.parametersets ) {
        "Parameter Set: " + $pset.name 
        # create a custom "object" so we can print it nicely
        $pset.parameters | foreach-object { 
            # optionally toss the ubiquitous parameters
            if ( $_.Position -lt 0 ) { $p = "named" } else { $p = $_.Position } 
            if ( !($ub -contains $_.name) -or $VerboseOutput ) {
                $_ | Add-Member NoteProperty Positional $p -pass -Force |
                Add-Member NoteProperty ParameterSetName $pset.name -pass  -Force
            }
        } | sort-object Positional | Format-Table "name", $type, $man, $pos, $vp, $vppn -auto
    }
}