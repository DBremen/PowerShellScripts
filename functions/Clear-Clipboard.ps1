function Restart-Process{
[CmdletBinding()] 
param([Parameter(ValueFromPipeline = $true)] $process)
	Begin{
		$selectedIndex=$multiInstanceName=$null
	}
	Process{
		if ($multiInstanceName -eq $_.Name){continue}
		$procToRestart=$_
		#handle if there are multiple instances of the same application
		if ((Get-Process $_.Name).Count -gt 1){
			$multiInstanceName=$_.Name
			$counter = 0
			$processInstances=Get-Process $_.Name
		    Write-Host "There are multiple instances of $($_.Name)."
			$prompt+=@("Provide the index of the instance to stop (-1 for all instances first instance will be restarted): ")
		    foreach($instance in $processInstances){
		        $counter++
		        $prompt+="{0} . {1}" -f $counter,$instance.MainWindowTitle
		    }
			Add-Type -AssemblyName 'Microsoft.VisualBasic'
		    $selectedIndex = [Microsoft.VisualBasic.Interaction]::InputBox(($prompt -join "`n"), "Select Process instance", "1") 
			$indices=(0..($processInstances.Length-1))
			switch ($selectedIndex){
				#clicked cancel
				$null 							{exit}
				#stop all instances but the first
				-1								{
														$indices=$indices -ne 0
														foreach ($index in $indices){ 
															$processInstances[$index].Kill()
															$processInstances[$index].WaitForExit()
														}
														$selectedIndex=1
														break
												}
				#mismatching arguments
				{$indices -notcontains ($_-1)} 	{			
													Write-Warning "Index is out of bounds.Exit"
													exit
												}
			}
			$procToRestart=$processInstances[$selectedIndex-1]
		}
		$cmdPath,$cmdArguments = (Get-WMIObject Win32_Process -Filter "Handle=$($_.Id)").CommandLine.Split()
		$procToRestart.Kill()
		$procToRestart.WaitForExit()
		if ($cmdArguments) { Start-Process -FilePath $cmdPath -ArgumentList $cmdArguments }
		else { Start-Process -FilePath $cmdPath }
	}
}



function GenerateForm($data) {  
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing
    $form= New-Object System.Windows.Forms.Form 
    $btnCancel = New-Object System.Windows.Forms.Button 
    $btnKill = New-Object System.Windows.Forms.Button 
    $btnRestart = New-Object System.Windows.Forms.Button 
    $flowPanel = New-Object System.Windows.Forms.FlowLayoutPanel
    $dataGrid = New-Object System.Windows.Forms.DataGridView 
    
    $form.Text = "Process blocking your Clipboard" 
    $form.DataBindings.DefaultDataSourceUpdateMode = 0 
    $form.AutoSize = $true
    $form.Width = 800
   
    $flowPanel.Dock = [System.Windows.Forms.DockStyle]::Top
    $flowPanel.FlowDirection = [System.Windows.Forms.FlowDirection]::RightToLeft

    $btnCancel.Text = "Cancel" 
    $btnCancel.AutoSize = $true
    $btnCancel.add_Click({$form.Close()}) 
    $flowPanel.Controls.Add($btnCancel) 
    $flowPanel.AutoSize = $true
 
    $btnKill.TabIndex = 2 
    $btnKill.AutoSize = $true
    $btnKill.Dock = [System.Windows.Forms.DockStyle]::Fill
    $btnKill.Text = "Stop Process" 
    $btnKill.add_Click({ 
        $selectedRow = $dataGrid.CurrentRow.Index 
        if (($procid=$Script:procInfo[$selectedRow].Id)) { 
            Stop-Process -Id $procid
        } 
        $form.Close()
    }) 
    $flowPanel.Controls.Add($btnKill) 
 
    $btnRestart.TabIndex = 1 
    $btnRestart.AutoSize = $true
    $btnRestart.Dock = [System.Windows.Forms.DockStyle]::Fill
    $btnRestart.Text = "Restart Process" 
    $btnRestart.add_Click({
        $selectedRow = $dataGrid.CurrentRow.Index 
        if (($procid=$Script:procInfo[$selectedRow].Id)) { 
                $Script:procInfo[$selectedRow] | Restart-Process
        } 
        $form.Close()
    }) 
    $flowPanel.Controls.Add($btnRestart) 

    $dataGrid.ColumnHeadersDefaultCellStyle.BackColor = [System.Drawing.Color]::LightGray
    $dataGrid.EnableHeadersVisualStyles = $false
    $dataGrid.AutoSizeColumnsMode = [System.Windows.Forms.DataGridViewAutoSizeColumnMode]::Fill
    $dataGrid.DataMember = "" 
    $dataGrid.TabIndex = 0 
    $dataGrid.Dock = [System.Windows.Forms.DockStyle]::Top
    $form.Controls.Add($flowPanel)
    $form.Controls.Add($dataGrid)
    $form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
    $form.add_Load({ 
        $dataGrid.DataSource = $array
        $dataGrid.AutoResizeColumns()
        $dataGrid.Height = 50
        $form.Height = 80
        $form.refresh()
    }) 
    $form.ShowDialog()| Out-Null 
} 

function Clear-Clipboard{
            if (("GetClipboardProcess" -as [type]) -eq $null){
        Add-Type  @"
        using System;
        using System.Runtime.InteropServices;
        using System.Collections.Generic;
        using System.Text;
        public class GetClipboardProcess{
            [DllImport("user32.dll", SetLastError = true)]
            public static extern IntPtr GetOpenClipboardWindow();

            [DllImport("user32.dll", SetLastError = true)]
            public static extern int GetWindowThreadProcessId(IntPtr hWnd, out int lpdwProcessId);
        }    
"@
    }
    [int]$processID = 0
    $null = [GetClipboardProcess]::GetWindowThreadProcessId([GetClipboardProcess]::GetOpenClipboardWindow(), [ref]$processId)
    if ($processID -ne 0){
        $script:procInfo = @(Get-Process -Id $processID)
        $array = New-Object System.Collections.ArrayList 
        $array.AddRange(@($procInfo | select Id, Name, Path, Description)) 
        GenerateForm $array
    }
}

