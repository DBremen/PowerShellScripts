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
.Synopsis
   Wrapper around everything search (http://www.voidtools.com/) commandline es.exe
.DESCRIPTION
   PowerShell wrapper around the everything search commandline tool es.exe. Returns the result
   of the es.exe commandline utility and converts it into FileSystemInfo objects which are then 
   output via Out-GridView. The selected item(s) in the GridView are output and optionally "actioned"
   depending on the specified switch parameter (OpenItem, CopyFullPath, OpenFolder, AsObject). 
   The default (without switch) is the output the selected item(s) Name, DirectoryName, FileSize and LastModifiedDate.
.PARAMETER OpenItem
   Switch parameter, if specified the selected item is invoked
.PARAMETER CopyFullPath
   Swtich parameter, if specified copies the fullpath of the selected item to the clipboard
.PARAMETER OpenFolder
   Switch parameter, if specified opens the folder that contains the selected item in windows explorer
.PARAMETER AsObject
   Swtich parameter, if specified outputs the selected item as FileSystemInfo Object
.EXAMPLE
   search test 
   #search for files and folders containing the word "test", show results in Out-GridView and output the selected item(s) Name, DirectoryName, FileSize and LastModifiedDate.
.EXAMPLE
   search test -CopyFullPath
   #search for files and folders containing the word "test", show results in Out-GridView and copy fullPath of selected item to clipboard
.EXAMPLE
   search test -OpenItem
   #search for files and folders containing the word "test", show results in Out-GridView and invoke the selected item(s) (only applies to files not folders)
.EXAMPLE
   search test -OpenFolder
   #search for files and folders containing the word "test", show results in Out-GridView and opens the folder(s) that contain(s) the selected item in windows explorer
.EXAMPLE
   search test -AsObject
   #search for files and folders containing the word "test", show results in Out-GridView and output the item(s) as FileSystemInfo objects
.Link
   http://www.voidtools.com/
#>
    [CmdletBinding()]
    [Alias("search")]
    Param
    (
        #searchterm
        [Parameter(Mandatory=$true, Position=0)]
        $SearchTerm,
        #openitem
        [switch]$OpenItem,
        [switch]$CopyFullPath,
        [switch]$OpenFolder,
        [switch]$AsObject
    )
    $esPath = 'C:\Program Files*\es\es.exe'
    if (!(Test-Path (Resolve-Path $esPath).Path)){
        Write-Warning "Everything commandline es.exe could not be found on the system please download and install via http://www.voidtools.com/es.zip"
        exit
    }
	$result = & (Resolve-Path $esPath).Path $SearchTerm
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
                                                    select Name,DirectoryName,@{Name="Size";Expression={$_.Length | Get-FileSize }},`
                                                    LastWriteTime
                                               }
        }
    }
}
