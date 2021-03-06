function 8Queens{
     <#    
    .SYNOPSIS
        PowerShell solution for a classical programming exercise.
    .DESCRIPTION
        Place 8 queens on a standard chess board (8x8) in a way that none can threaten any other.
        Solved using recursive backtracking algorithm.
	.EXAMPLE
		8Queens
    #>    
	$8Queens = New-8Queens 
	$8Queens.Solve()
	$8Queens.Print()
}
function New-8Queens($dim=8){ 
    New-Module -ArgumentList $dim  -AsCustomObject { 
		param ($dim)
		$Board = new-object 'bool[,]' $dim,$dim
		$Size = $dim
		
		function IsSafe($currRow,$currCol){
			#check lower diag
			for ($row,$col = ($currRow+1),($currCol-1); $col -ge 0 -and $row -lt $Size;$row++, $col--) {
				if ($board[$row, $col]) {
					return $false
				}
			}
			
			#check upper diag
			for ($row,$col = ($currRow-1),($currCol-1); $row -ge 0 -and $col -ge 0;$row--, $col--) {
				if ($board[$row, $col]) {
					return $false
				}
			}
			
			
			#check row
			for ($col = 0; $col -lt $currCol; $col++) {
				if ($board[$currRow, $col]){
					return $false
				}
			}
			return $true
		}


		function Solve($col=0){
			if ($col -ge $board.GetLength(0)){
				return $true
			}
			for ($row = 0; $row -lt $board.GetLength(0); $row++)  {
				if ((IsSafe $row $col)) {
					#place queen
					$Board[$row,$col] = $true
					#Print #uncomment to follow steps
					#recur to place other queens
					if ((Solve ($col + 1))) {
						return $true
					}
					#failed remove queen
					$Board[$row,$col] = $false
				}
			}
			return $false
		}

		function Print{
			$n=$Size
			Write-Host
		    for ($row = 0; $row -lt $n; $row++){
		        for ($col = 0; $col -lt $n; $col++){
					if (($row+$col)%2) { $fgcolor="black";$bgcolor="white" }
					else { $fgcolor="white";$bgcolor="black" }
		            if ($board[$row, $col]) { 
						Write-Host -NoNewline -BackgroundColor $bgcolor -ForegroundColor $fgcolor "Q " 
					}
					else{
						Write-Host -NoNewline -BackgroundColor $bgcolor "  " 
					}
		        }
		        Write-Host
		    }
		}
		Export-ModuleMember -Function Solve,Print
	}
}