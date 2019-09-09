function Get-HelpExamples {
    <#    
    .SYNOPSIS
        Get examples for a Cmdlet.
    .DESCRIPTION
        Extracts example code, title, and remarks as objects. From the respective command's help.
	.PARAMETER Command
		Name of the command to get the examples for.
	.EXAMPLE
		Get-HelpExamples gcm
    #>
    [CmdletBinding()]
    Param(
        # Param1 help description
        [Parameter(Mandatory, 
            ValueFromPipeline = $false,
            Position = 0
        )]
        $Command)

    (Get-Help $Command).examples.example | foreach {
        [PSCustomObject]@{
            Code    = $_.Code.Split("`n") | foreach {
                if ($_.StartsWith('PS C:\>')) {
                    $_.replace('PS C:\>', '')
                }
                else {
                    "# $_"
                }
            } | Out-String
            Title   = $_.Title
            Remarks = $_.Remarks | Out-String 
        }

    } 
}
