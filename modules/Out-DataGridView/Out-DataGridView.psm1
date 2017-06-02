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

function Out-DataGridView{
     <#    
    .SYNOPSIS
        Out-Gridview like function + editing option
    .DESCRIPTION
        Like Out-GridView but with the option to edit the entries in the GridView before further processing.
        The DataGrid supports filtering (right click on column) and searching.
    .Param InputObeckt
        The object(s) that are going to be shown in the GridView
    
    .EXAMPLE
        Import-Module Out-DataGridView
        gps | select name,id,handles | Out-DataGridView 
    
    .LINK
        http://www.codeproject.com/Articles/33786/DataGridView-Filter-Popup (for the filter functions)
    #>
    [CmdletBinding()]
    param(
         [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
         $InputObject
    )
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing
    if (-not ([Management.Automation.PSTypeName]'DgvFilterPopup.DgvFilterManager').Type){
        Add-Type -Path "$PSScriptRoot\DgvFilterPopup.dll"
    }
    $form = New-Object System.Windows.Forms.Form
    $form.Size = New-Object System.Drawing.Size(900,600)
    $form.KeyPreview = $true 
    #conversion necessary for filter and sortable columns
    $source = $Input | Out-DataTable
    #otherwise this would work
    #$source = New-Object System.collections.ArrayList
    #$source.AddRange($Input)

    $textBox = New-Object System.Windows.Forms.TextBox
    $textBox.Size = New-Object System.Drawing.Size(885,100)
    $textBox.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",14,0,3,0)
    $anchorStyles = [System.Windows.Forms.AnchorStyles]
    $textBox.Anchor = $anchorStyles::Left -bor $anchorStyles::Right -bor $anchorStyles::Top 
    $textBox.Add_TextChanged({
        $bs = New-Object System.Windows.Forms.BindingSource
        $bs.DataSource = $dataGridView.DataSource
        $filter=@()
        foreach ($column in $dataGridView.Columns){
            $filter += $column.Name + " like '%" + $textBox.Text + "%'"
        }

        $bs.Filter = ($filter -join " OR ")
        $dataGridView.DataSource = $bs
    })

    $dataGridView = New-Object System.Windows.Forms.DataGridView -Property @{
        ColumnHeadersHeightSizeMode = [System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode]::AutoSize 
        SelectionMode = 'FullRowSelect' 
        ColumnHeadersVisible = $true
        DataSource = $source
        Font = New-Object System.Drawing.Font("Microsoft Sans Serif",14,0,3,0)
        Size = New-Object System.Drawing.Size(885,600)
        Location = New-Object System.Drawing.Point(0,24)
        Anchor = $anchorStyles::Left -bor $anchorStyles::Right -bor $anchorStyles::Bottom
        AutoSizeColumnsMode = [System.Windows.Forms.DataGridViewAutoSizeColumnsMode]::Fill
    }
   
    #does not work with filter
    <#
    $comboBoxColumn = New-Object System.Windows.Forms.DataGridViewComboBoxColumn -Property @{
            DataPropertyName = "test"
            HeaderText = "test"
            #column.DropDownWidth = 160;
            #column.Width = 90;
            #column.MaxDropDownItems = 3;
            #column.FlatStyle = FlatStyle.Flat;
    }
    $comboBoxColumn.DataSource = ($Input | select Name | Out-DataTable)
    $dataGridView.Columns.Insert(0, $comboBoxColumn)#>

    $dataGridView.add_DoubleClick({ 
        $script:return = $this.SelectedRows |% {$_.DataboundItem}
        $form.Close() 
    }) 
    $dataGridView.add_ColumnHeaderMouseClick({
        $column = $dataGridView.Columns[$_.ColumnIndex]
        $direction = [System.ComponentModel.ListSortDirection]::Ascending
        
        if ($column.HeaderCell.SortGlyphDirection -eq 'Descending')
        {
            $direction = [System.ComponentModel.ListSortDirection]::Descending
        }
        
        $dataGridView.Sort($dataGridView.Columns[$_.ColumnIndex], $direction)
    })
  
    $form.Add_KeyDown({ 
        if ($_.KeyCode -eq 'Enter') { 
            $script:return = $dataGridView.SelectedRows |% {$_.DataboundItem}
            $form.Close() 
        } 
        ElseIf ($_.KeyCode -eq 'Escape'){ 
            $form.Close() 
        } 
    })  
    $filterManager = New-Object DgvFilterPopup.DgvFilterManager($dataGridView)
    $form.Controls.Add($textBox)
    $form.Controls.Add($dataGridView)
    $form.Add_Shown({
        $form.Activate()
        $dataGridView.AutoResizeColumns()
        $textBox.Width = $dataGridView.Width
    })  
    $script:return = $null  
    [void]$form.ShowDialog()  
    $script:return
}

Export-ModuleMember -Function Out-DataGridView




