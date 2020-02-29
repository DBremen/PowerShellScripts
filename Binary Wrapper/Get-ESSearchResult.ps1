filter Get-FileSize {
	"{0:N2} {1}" -f $(
	if ($_ -lt 1kb) { $_, 'Bytes' }
	elseif ($_ -lt 1mb) { ($_/1kb), 'KB' }
	elseif ($_ -lt 1gb) { ($_/1mb), 'MB' }
	elseif ($_ -lt 1tb) { ($_/1gb), 'GB' }
	elseif ($_ -lt 1pb) { ($_/1tb), 'TB' }
	else { ($_/1pb), 'PB' }
	)
}

function Get-ESSearchResult {
     <#    
    .SYNOPSIS
        PowerShell wrapper around Everything search command line (es.exe).
    .DESCRIPTION
        Get-ESSearchResult function (alias search) searches for all items containing the search term (SearchTerm parameter is the only mandatory parameter). 
        The search results (if multiple) are piped to Out-GridView with the -PassThru option enabled so that the result can be seen in GUI and one or multiple items 
        from within the search results can be selected. By default (no switches turned on) the selected item(s) 
        are converted to FileSystemInfo objects and their Name, DirectoryName, FileSize and LastModifiedDate are output. 
        The resulting objects can be used for further processing (copying, deleting….)
	.PARAMETER SearchTerm
		The search term to search for see es.exe syntax for options.
	.PARAMETER OpenItem
		Switch enabled = Invoke the selected item(s) (only applies to files not folders).
    .PARAMETER CopyFullPath
		Switch enabled = Copy the full Path of the selected item to the clipboard.
    .PARAMETER OpenFolder
		Switch enabled = Opens the folder(s) that contain(s) the selected item(s) in windows explorer
    .PARAMETER AsObject
		Switch enabled = Similar to default output but the full FileSystemInfo objects related to the selected item(s) are output
	.EXAMPLE
		search 'mySearchTerm'
    .LINK
        https://powershellone.wordpress.com/2015/02/28/using-everything-search-command-line-es-exe-via-powershell/
    .LINK
        https://www.voidtools.com/support/everything/command_line_interface/
    #>
    [CmdletBinding()]
    [Alias("search")]
    Param
    (
        [Parameter(Mandatory=$true, Position=0)]
        $SearchTerm,
        [switch]$OpenItem,
        [switch]$CopyFullPath,
        [switch]$OpenFolder,
        [switch]$AsObject
    )
    $esPaths = @('C:\Program Files*\es\es.exe','c:\ProgramData\chocolatey\bin\es.exe')
    foreach($esPath in $esPaths){
        $esPath = (Resolve-Path $esPath -ErrorAction SilentlyContinue)
        if (!$esPath -or !(Test-Path $esPath.Path)){
            $esPath = ""
        } else {
            break
        }
    }
    if ($esPath -eq ""){
        Write-Warning "Everything commandline es.exe could not be found on the system please download and install via http://www.voidtools.com/es.zip or using Chocolatey ('choco install everything')"
        break
    }
    $result = & $esPath.Path $SearchTerm
    if($result.Count -gt 1){
        $result = $result | Out-GridView -PassThru
    }
    foreach($record in $result){
        switch ($PSBoundParameters){
	        { $_.ContainsKey("CopyFullPath") } { $record | clip }
	        { $_.ContainsKey("OpenItem") }     { if (Test-Path $record -PathType Leaf) {  & "$record" } }
	        { $_.ContainsKey("OpenFolder") }   {  & "explorer.exe" /select,"$(Split-Path $record)" }
	        { $_.ContainsKey("AsObject") }     { $record | Get-ItemProperty }
	        default                            { $record | Get-ItemProperty | 
                                                    select Name,DirectoryName,@{Name="Size";Expression={$_.Length | Get-FileSize }},LastWriteTime
                                               }
        }
    }
}
