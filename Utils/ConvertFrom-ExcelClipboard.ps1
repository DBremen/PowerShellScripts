function ConvertFrom-ExcelClipboard {
    <#
        .SYNOPSIS
            Convert copied range from excel to an array of PSObjects
        .DESCRIPTION
            A range of cells copied into the clipboard is converted into PSObject taking the first row (or provided property names via Header parameter) as the properties.
        .EXAMPLE
            #Considering a range of cells including header has been copied to the clipboard
            ConvertFrom-ExcelClipboard
        .EXAMPLE
            #Convert excel range without headers providing property names through argument to the Headers parameter
            ConvertFrom-ExcelClipboard -Header test1,test2,test3
        .LINK
            https://powershellone.wordpress.com/2016/06/02/powershell-tricks-convert-copied-range-from-excel-to-an-array-of-psobjects/
    #>
    [CmdletBinding()]
    [Alias('pasteObject')]
    param(
        #Specifies an alternate column header row. The column header determines the names of the properties of the object(s) created.
        [string[]]$Header,
        #If specified, the content of the clipboard is returned as is.
        [switch]$Raw
    )

    Add-Type -AssemblyName System.Windows.Forms
    $tb = New-Object System.Windows.Forms.TextBox
    $tb.Multiline = $true
    $tb.Paste()
    if ($Raw){
        $tb.Text
    }
    else{
        $ht = $PSBoundParameters
        #compare Header Count to Column count of first row
        if ($Header -and $ht.Header.Count -ne  $tb.Text.Split(@("`r`n"),'None')[0].Split("`t").Count){
            Write-Warning 'Header values do not equal the number of columns copied to the clipboard'
        }
        $tb.Text | ConvertFrom-Csv -Delimiter "`t" @PSBoundParameters
    }
}
