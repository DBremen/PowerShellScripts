
function Invoke-Parallel{	
	<#    
      .SYNOPSIS
        Execute a scriptblock in parallel using runspaces taking pipeline input.
      .DESCRIPTION
        This is based on Tobias Weltner's excellent Efficient PowerShell online presentation
      .PARAMETER Pipeline
        The input to execute the scriptblock against in parallel.
      .PARAMETER ScriptBlock
		The code to execute in paralllel.
	  .PARAMETER DictParamList
	  	Parameters passed and referenced by the scriptblock should be of type [system.collections.generic.dictionary[string,object]].
      .PARAMETER Module
        Module(s) to be imported so that they can be referenced by the code in the scriptblock.
      .PARAMETER ThrottleLimit
        Number of parallel runspaces to use.
      .EXAMPLE
        $params=New-Object 'system.collections.generic.dictionary[string,object]'
		$params.Add("multi",2)
		1..10 | Invoke-Parallel -scriptBlock {$_* $multi} -dictParamList $params
	  .EXAMPLE
		$sb={param($num) ("$num :this is a quite long text.`n" * ($num*500))  | set-content -Path "c:\$num.txt"}
		1..10 | Loop-Parallel -scriptblock $sb
    #>
	#pipeline element should be first function parameter for the function to execute in parallel
	param(
	[Parameter(Mandatory,Position=0,ValueFromPipeline)]
	$Pipeline,
	$ScriptBlock,
	[system.collections.generic.dictionary[string,object]]$DictParamList,
	$Module,
	$ThrottleLimit = 10
	)

	begin {
		$PipelineCount = 0
		$start= Get-Date
		$iss = [system.management.automation.runspaces.initialsessionstate]::CreateDefault()
		if ($Module){
			$iss.ImportPSModule(@($Module))
		}
		$runspace = [runspacefactory]::CreateRunspacePool(1, $ThrottleLimit, $iss, $Host)
		$runspace.ApartmentState='STA'
		$null=$runspace.Open()
		$jobs = New-Object System.Collections.ArrayList
		#add command= for cmdlets;addParameter=named parameter
		#build param list with parameter names
		$paramStatement="param(`$_"
		if ($DictParamList){
			foreach ($param in $DictParamList.GetEnumerator()){
				$paramStatement+=",`$" + $param.Key
			}
		}
		$paramStatement+=")`r`n"
		$ScriptBlock = $ExecutionContext.InvokeCommand.NewScriptBlock($paramStatement + $ScriptBlock.ToString())

		function Get-Results {
			param([switch]$wait)
			do {
				$hasdata = $false
				foreach($job in $jobs) {
					if ($job.Handle.isCompleted) {
						$job.Thread.EndInvoke($job.Handle)
						$job.Thread.dispose()
						$job.Handle = $null
						$job.Thread = $null
					} elseif ($job.Handle -ne $null) {
						$hasdata = $true
					}
				} 
				if ($hasdata -and $wait) {Start-Sleep -Milliseconds 100}
			} while ($hasdata -and $wait)
		}
	}

	process {
    	#create thread according to throttleLimit and for each pipeline element
		$Pipeline | ForEach-Object {
        	$PipelineCount++
			$thread = [powershell]::Create().AddScript($ScriptBlock).AddArgument($_)
			#add all arguments values to the thread
			if ($DictParamList){
				foreach ($param in $DictParamList.GetEnumerator()){
					$thread=$thread.AddArgument($param.Value)
				}
			}
			
			$thread.RunspacePool = $runspace
			[void]$jobs.Add((New-Object PSObject -Property @{"Thread"=$thread;"Handle"=$thread.BeginInvoke()} )) 
			Get-Results
		}
	}

	end {
		Get-Results -wait
		$time = ((Get-Date) - $start).TotalSeconds
		Write-Verbose ("Processed $PipelineCount elements in {0:0.0} seconds ({1:0.000} sec/element)" -f $time, ($time / $PipelineCount))
		$runspace.Close()
	}
}