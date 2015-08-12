<#
Requirements:
    -Everything command line version (requires the UI version to be installed,too) installed to ‘C:\Program Files*\es\es.exe’
    -The Search-FileContent cmdlet is implemented via the SearchFileContent.dll which can be downloaded from my GitHub repository and needs to reside in the same folder as the FileSearcher.psm1 file.
    -Because the Search-FileContent cmdlet is written in F# it requires the FSharp.Core assembly to be present which can be downloaded and installed via the following PowerShell code:
       $webclient = New-Object Net.WebClient
       $url = 'http://download.microsoft.com/download/E/A/3/EA38D9B8-E00F-433F-AAB5-9CDA28BA5E7D/FSharp_Bundle.exe'
       $webclient.DownloadFile($url, "$pwd\FSharp_Bundle.exe")
       .\FSharp_Bundle.exe /install /quiet
    The ability to open files from the file search content results via double-click with the cursor on the respective line requires Notepad++
#>
function Out-DataTable{
	param($Properties="*")
	Begin
	{
	    $dt = New-Object Data.datatable  
	    $First = $true 
	}
	Process{
	    $DR = $DT.NewRow()  
	    foreach ($item in $_ |  Get-Member -type *Property $Properties ){  
	      $name = $item.Name
	      if ($first) {  
	        $Col =  New-Object Data.DataColumn  
	        $Col.ColumnName = $name
	        $DT.Columns.Add($Col)       }  
	        $DR.Item($name) = $_.$name  
	    }  
	    $DT.Rows.Add($DR)  
	    $First = $false  
	}
	End{
	    return @(,($dt))
	}
}

function FileSearcher{
    [CmdletBinding()]
    param(
         [Parameter(ValueFromPipeline=$true)]
         $InputObject
    )
    # f# lib for Search-FileContent cmdlet
    Import-Module $PSScriptRoot\SearchFileContent.dll -Force
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing
    #enable rich visual styles in PowerShell console mode:
    [System.Windows.Forms.Application]::EnableVisualStyles()
    #in order set the water-marks on the textboxes
    $MethodDefinition = @'
[DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = false)]
public static extern IntPtr SendMessage(IntPtr hWnd, uint Msg, uint wParam, [MarshalAs(UnmanagedType.LPWStr)] string lParam);
'@
    $script:user32 = Add-Type -MemberDefinition $MethodDefinition -Name 'User32' -Namespace 'Win32' -PassThru
    $form = New-Object System.Windows.Forms.Form -Property @{
        Size = New-Object System.Drawing.Size(900,600)
        KeyPreview = $true 
        Text = "File searcher"
        BackColor = [Drawing.Color]::Gray 
        Icon = [Drawing.Icon]::ExtractAssociatedIcon($PSHOME + "\powershell.exe")
    }
    #exclude folders
    $source = $Input | where {!$_.PSIsContainer} | select @{n="Path";e={$_.FullName}} | Out-DataTable
    #build form
    $anchorStyles = [System.Windows.Forms.AnchorStyles]
    $textBoxPath = New-Object System.Windows.Forms.TextBox -Property @{
        Size = New-Object System.Drawing.Size(740,200)
        Font = New-Object System.Drawing.Font("Segoe UI",14,0,3,0)
        AutoCompleteMode = "SuggestAppend"
        AutoCompleteSource = "FileSystemDirectories"
        Anchor = $anchorStyles::Left -bor $anchorStyles::Right -bor$anchorStyles::Top 
        BorderStyle = [Windows.Forms.BorderStyle]::Fixed3D
        Height = $textBoxPath.PreferredHeight
    }
    #use everything to search for files
    $textBoxPath.Add_KeyDown({
        if ($_.KeyCode -eq 'Enter' -or $_.KeyCode -eq 'Return') { 
            #split it on spaces keepign quoted text together
            $keywords=@($this.Text -split '"([^"]+)"|\s?(\S+?)\s' | where {$_.Trim()})
            $filePath = $this.Text.Split()[0]
            if ($checkBoxRecursive.Checked){
                if (Test-Path $filePath){
                    $depth = ($filePath.Split('\') | where {$_}).Count
                    $keywords += "parents:$depth"
                }
            }
            #filter out folders
            if ($keywords -notContains 'file:'){
                $keywords+= 'file:'
            }
            $esPath = Resolve-Path 'c:\Program Files*\es\es.exe'
            if (!(Test-Path $esPath)){
                Write-Warning "Couldn't find everything command-line (es.exe)"
            }
            $dataGridView.DataSource= & "$esPath" $keywords |
                select @{n="Path";e={$_}} |
                Out-DataTable
        }
    })
    $checkBoxRecursive = New-Object System.Windows.Forms.CheckBox -Property @{
        Size = New-Object System.Drawing.Size(141,39)
        Font = New-Object System.Drawing.Font("Segoe UI",10,0,3,0)
        Text = "NoRecurse"
        BackColor = [Drawing.Color]::White
        Left = 741
        Top = 1
        Padding = New-Object Windows.Forms.Padding(3,0,0,0)
        Anchor = $anchorStyles::Right -bor $anchorStyles::Top
    }
    $textBoxPattern = New-Object System.Windows.Forms.TextBox -Property @{
        Size = New-Object System.Drawing.Size(610,200)
        Font = New-Object System.Drawing.Font("Segoe UI",14,0,3,0)
        Top = 38
        Anchor = $anchorStyles::Left -bor $anchorStyles::Right -bor $anchorStyles::Top
        BorderStyle = [Windows.Forms.BorderStyle]::Fixed3D
        Height = $textBoxPath.PreferredHeight
    }
    #use select-string to search through the files
    $textBoxPattern.Add_KeyDown({
        #check if list of files is currently displayed
        if (($_.KeyCode -eq 'Enter' -or $_.KeyCode -eq 'Return') -and $dataGridView.Columns.Name -eq 'Path') { 
            <#
            #using slower Select-String
            $data = $dataGridView.DataSource 
            $simple, $caseSensitive = $checkBoxSimpleMatch, $checkBoxCaseSensitive
            $items = foreach ($item in $data){
                try{
                    Select-String -Path $item.Path -Pattern "$($this.Text)" -SimpleMatch:$simple -CaseSensitive:$caseSensitive -ErrorAction SilentlyContinue 
                }
                catch{}
            }
            $dataGridView.DataSource= $items | select Path, Line, @{n="Line #";e={$_.LineNumber}}| Out-DataTable
            #>
            $files = ($dataGridView.DataSource).Path
            $simple, $caseSensitive = $checkBoxSimpleMatch.Checked, $checkBoxCaseSensitive.Checked
            $dataGridView.DataSource = 
                Search-FileContent $files -Pattern "$($this.Text)" -SimpleMatch:$simple -CaseSensitive:$caseSensitive|
                select Path, Line, @{n="Line #";e={$_.LineNumber}}| Out-DataTable
            $dataGridView.Columns[1].Width = 100
        }
    })
    $checkBoxSimpleMatch = New-Object System.Windows.Forms.CheckBox -Property @{
        Size = New-Object System.Drawing.Size(130,38)
        Font = New-Object System.Drawing.Font("Segoe UI",10,0,3,0)
        Text = "SimpleMatch"
        BackColor = [Drawing.Color]::White
        Left = 610
        Padding = New-Object Windows.Forms.Padding(3,0,0,0)
        Top = 39
        Anchor = $anchorStyles::Right -bor $anchorStyles::Top
    }
    $checkBoxCaseSensitive = New-Object System.Windows.Forms.CheckBox -Property @{
        Size = New-Object System.Drawing.Size(141,38)
        Font = New-Object System.Drawing.Font("Segoe UI",10,0,3,0)
        Text = "CaseSensitive"
        BackColor = [Drawing.Color]::White
        Left = 741
        Padding = New-Object Windows.Forms.Padding(3,0,0,0)
        Top = 39
        Anchor = $anchorStyles::Right -bor $anchorStyles::Top
    }
    $textBoxFilter = New-Object System.Windows.Forms.TextBox -Property @{
        Size = New-Object System.Drawing.Size(885,200)
        Font = New-Object System.Drawing.Font("Segoe UI",14,0,3,0)
        Top = 75
        Anchor = $anchorStyles::Left -bor $anchorStyles::Right -bor $anchorStyles::Top 
        BorderStyle = [Windows.Forms.BorderStyle]::Fixed3D
        Height = $textBoxPath.PreferredHeight
    }
    #filter the output
    $textBoxFilter.Add_TextChanged({
        $bs = New-Object System.Windows.Forms.BindingSource
        $bs.DataSource = $dataGridView.DataSource
        $filter=@()
        foreach ($column in $dataGridView.Columns){
            $filter += "[" + $column.Name + "]" + " like '%" + $textBoxFilter.Text + "%'"
        }

        $bs.Filter = ($filter -join " OR ")
        $dataGridView.DataSource = $bs
    })
    $dataGridView = New-Object System.Windows.Forms.DataGridView -Property @{
        ColumnHeadersHeightSizeMode = [System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode]::AutoSize 
        SelectionMode = 'FullRowSelect' 
        ColumnHeadersVisible = $true
        DataSource = $source
        Top = 105
        Font = New-Object System.Drawing.Font("Segoe UI",12)
        Size = New-Object System.Drawing.Size(885,465)
        Location = New-Object System.Drawing.Point(0,24)
        Anchor = $anchorStyles::Left -bor $anchorStyles::Right -bor $anchorStyles::Top
        AutoSizeColumnsMode = [System.Windows.Forms.DataGridViewAutoSizeColumnsMode]::Fill
        ReadOnly = $true
        EnableHeadersVisualStyles = $false
    }
    $dataGridView.ColumnHeadersDefaultCellStyle.BackColor = [System.Drawing.Color]::LightGray 
    #open the selected file in notepad++ and put the cursor to the correct line number
    $dataGridView.add_DoubleClick({ 
        if ($this.Columns.Name -contains 'Line'){
            $script:return= $this.SelectedRows |% {$_.DataboundItem}
            $path,$ln = $this.SelectedRows.DataBoundItem.Path, $this.SelectedRows.DataBoundItem.'Line #'
            $nppPath = Resolve-Path 'c:\Program Files*\Notepad++\notepad++.exe'
            #works only if notepad++ is not already open
            if (Test-Path $nppPath){
                & "$nppPath" "$path" -"n$ln"
            }
        }
    }) 
    #sort columns
    $dataGridView.add_ColumnHeaderMouseClick({
        $column = $dataGridView.Columns[$_.ColumnIndex]
        $direction = [System.ComponentModel.ListSortDirection]::Ascending
        
        if ($column.HeaderCell.SortGlyphDirection -eq 'Descending'){
            $direction = [System.ComponentModel.ListSortDirection]::Descending
        }
        
        $dataGridView.Sort($dataGridView.Columns[$_.ColumnIndex], $direction)
    })
    #Enter=add selected rows to output;Esc=close form
    $form.Add_KeyDown({ 
        if ($_.KeyCode -eq 'Enter') { 
            $script:return += $dataGridView.SelectedRows |% {$_.DataboundItem} 
        } 
        ElseIf ($_.KeyCode -eq 'Escape'){ 
            $form.Close() 
        } 
    })  
    $form.Controls.AddRange(($textBoxFilter,$checkBoxRecursive,$textBoxPath,$textBoxPattern,$checkBoxSimpleMatch,$checkBoxCaseSensitive,$dataGridView))
    $form.Add_Shown({
        $form.Activate()
        $dataGridView.AutoResizeColumns()
        $textBoxFilter.Width = $dataGridView.Width
        #add the watermarks
        $user32::SendMessage($textBoxFilter.Handle,0x1501, 0, "Filter results")
        $user32::SendMessage($textBoxPath.Handle,0x1501, 0, "Search for files by keyword")
        $user32::SendMessage($textBoxPattern.Handle,0x1501, 0, "Search within files by keyword")
        $this.Location = New-Object System.Drawing.Point(0, 0)
        $this.Size = [System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea.Size
    })  
    $form.Add_Resize({
        #change size of datagridview
        $dataGridView.Height = $this.Height-135
    })

    $script:return = @()
    $dataGridView.Select()
    [void]$form.ShowDialog()  
    $script:return
}

#dir C:\Scripts\ps1\PowerShellScripts\functions | FileSearcher
Export-ModuleMember -Function FileSearcher
