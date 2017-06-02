function Get-Choice {
<#    
    .SYNOPSIS
        An alternative to the built-in PromptForChoice providing a consistent UI across different hosts.

    .DESCRIPTION
        The PromptForChoice method on the System.Management.Automation.Host.PSHostUserInterface is declared as an abstract method. 
        This basically means that the implementation details are up to the respective PowerShell host (as long as the method complies with the declaration).
        As a result your script will not provide a consistent user experience across PowerShell hosts (e.g. ISE, Console). 
        Because of this I wrote a little Windows.Form based helper function that provides the same features as PromptForChoice but will look the same across all PowerShell hosts

	.PARAMETER Title
		Title of the dialog.

	.PARAMETER Options
		String array of options to be shown. Each option will be shown as the caption of a button within the dialog.
        Similar to the way it works in PromptForChoice preceding a character from within the option values with an ampersand (e.g. Option &1) 
        will make the button accessible via ALT-key + the letter (e.g. ALT + 1)

    .PARAMETER DefaultChoice
		Number of the option (1 Option = 1) to be the default. A value of -1 indicates that the dialog will not have a default option.

	.EXAMPLE
        #Create a dialog with 3 Options, choosing Option2 as the default choice.
		Get-Choice "Pick Something!" (echo Option&1 Option&2 Option&3) 2

    .LINK
        https://powershellone.wordpress.com/2015/09/10/a-nicer-promptforchoice-for-the-powershell-console-host/
#>
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true,Position=0)]
        $Title,

        [Parameter(Mandatory=$true,Position=1)]
        [String[]]
        $Options,

        [Parameter(Position=2)]
        $DefaultChoice = -1
    )
    if ($DefaultChoice -ne -1 -and ($DefaultChoice -gt $Options.Count -or $DefaultChoice -lt 1)){
        Write-Warning "DefaultChoice needs to be a value between 1 and $($Options.Count) or -1 (for none)"
        exit
    }
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing
    [System.Windows.Forms.Application]::EnableVisualStyles()
    $script:result = ""
    $form = New-Object System.Windows.Forms.Form
    $form.FormBorderStyle = [Windows.Forms.FormBorderStyle]::FixedDialog
    $form.BackColor = [Drawing.Color]::White
    $form.TopMost = $True
    $form.Text = $Title
    $form.ControlBox = $False
    $form.StartPosition = [Windows.Forms.FormStartPosition]::CenterScreen
    #calculate width required based on longest option text and form title
    $minFormWidth = 100
    $formHeight = 44
    $minButtonWidth = 70
    $buttonHeight = 23
    $buttonY = 12
    $spacing = 10
    $buttonWidth = [Windows.Forms.TextRenderer]::MeasureText((($Options | Sort-Object Length)[-1]),$form.Font).Width + 1
    $buttonWidth = [Math]::Max($minButtonWidth, $buttonWidth)
    $formWidth =  [Windows.Forms.TextRenderer]::MeasureText($Title,$form.Font).Width
    $spaceWidth = ($options.Count+1) * $spacing
    $formWidth = ($formWidth, $minFormWidth, ($buttonWidth * $Options.Count + $spaceWidth) | Measure-Object -Maximum).Maximum
    $form.ClientSize = New-Object System.Drawing.Size($formWidth,$formHeight)
    $index = 0
    #create the buttons dynamically based on the options
    foreach ($option in $Options){
        Set-Variable "button$index" -Value (New-Object System.Windows.Forms.Button)
        $temp = Get-Variable "button$index" -ValueOnly
        $temp.Size = New-Object System.Drawing.Size($buttonWidth,$buttonHeight)
        $temp.UseVisualStyleBackColor = $True
        $temp.Text = $option
        $buttonX = ($index + 1) * $spacing + $index * $buttonWidth
        $temp.Add_Click({ 
            $script:result = $this.Text; $form.Close() 
        })
        $temp.Location = New-Object System.Drawing.Point($buttonX,$buttonY)
        $form.Controls.Add($temp)
        $index++
    }
    $shownString = '$this.Activate();'
    if ($DefaultChoice -ne -1){
        $shownString += '(Get-Variable "button$($DefaultChoice-1)" -ValueOnly).Focus()'
    }
    $shownSB = [ScriptBlock]::Create($shownString)
    $form.Add_Shown($shownSB)
    [void]$form.ShowDialog()
    $result
}