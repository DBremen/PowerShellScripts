function grep {   
    <#    
      .SYNOPSIS
        Filter output based on keyword, but still retain PowerShell object format.
        Hence it can be even used in the middle of a pipeline (see example):
      .DESCRIPTION
        This was one of the great Idera PowerShell PowerTips (similar to the one in the link but not exactly this one.)
      .PARAMETER Keyword
        The text to filer
      .PARAMETER Keyword
        The keyword to filter for
       .EXAMPLE
        Get-Process | grep svchost | select name,id
      .LINK
        https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/filter-powershell-results-fast-and-text-based
    #>
    [CmdletBinding()]
    param( 
        [Parameter(Mandatory, ValueFromPipeline)] 
        $Text,
        [Parameter(Mandatory, 
            Position = 0)]   
        $Keyword
    )
    PROCESS {
        $noText = $Text -isnot [string]  
        if ($noText) {  
            $curr = $Text |   
            Format-Table -AutoSize |   
            Out-String -Width 5000 -Stream |    
            Select-Object -Skip 3  
        }  
        else {  
            $curr = $Text  
        }  
        $Text | Where-Object { $curr -like "*$Keyword*" }  
    }
}