function Get-FileAndExtract{
<#
    .SYNOPSIS
        Function to download and extract files.        
    .DESCRIPTION
		Downloads files to the provided destination folder. 
        If the destination folder does not exist it will be created. 
        In case the provided Url ends with .zip the content gets automatically extracted.
        If the .zip contains already a folder with the same name as the .zip file the content is extracted within
        the provided destination, otherwise the content is extracted within a subfolder (with the same name as the
        zip file) of the provided destination. 
        This way the extracted content always ends up within a subfolder of the destination folder.
        Existing files will be overwritten automatically when extracted unless the $NoOverwrite switch is specified.     
    .PARAMETER Url
        Source Url of the file to download.   
    .PARAMETER Destination
        Destination folder.		
	.PARAMETER NoOverwrite
		Switch parameter. If specified dialog is displayed for files being overwritten while extracting.     
    .EXAMPLE  
        #Download SubInACL.msi to Desktop and start installer
        Get-FileAndExtract 'http://download.microsoft.com/download/1/7/d/17d82b72-bc6a-4dc8-bfaa-98b37b22b367/subinacl.msi' "$([Environment]::GetFolderPath("Desktop"))"         
    .EXAMPLE  
        #Download and extract the contents of SysinternalSuite.zip to Desktop\SysInternalSuite (folder SysInternalSuite is created)
        Get-FileAndExtract 'http://download.sysinternals.com/files/SysinternalsSuite.zip' "$([Environment]::GetFolderPath("Desktop"))"
    .EXAMPLE  
        #Download and extract the contents of WorkSmartGuides.zip to Desktop\WorkSmartGuides (no folder is created since .zip already contains folder)
        Get-FileAndExtract 'http://download.microsoft.com/download/1/C/2/1C2D966E-F713-4A4F-9D5C-F7FB6E93E4B9/WorkSmartGuides.zip' "$([Environment]::GetFolderPath("Desktop"))\NewFolder"	
#>
    [cmdletbinding()]
    param(
        $Url,
        $Destination,
        [switch]$NoOverwrite
    )
	$flags=16
	if ($NoOverwrite) { $flags=0 }
    if (!(Test-Path $destination)){
		$null=New-Item -ItemType Directory -Path $destination 
	}
    $fullPath=Join-Path $destination $url.Split("/")[-1]
	(New-Object Net.WebClient).DownloadFile($url,$fullPath)
    if ($fullPath.EndsWith(".zip")){
        #extract here
        $extractDest=$destination
        #check if the .zip contains already a folder with the same name
	    $zip=(New-Object -ComObject Shell.Application).Namespace($fullPath)
        if (@($zip.Items()).Path -notcontains $fullPath.Replace(".zip","")){
            #extract in subfolder with same name as .zip
            $extractDest=$fullPath.Replace(".zip","")
            $null=New-Item -ItemType Directory -Path $extractDest
        }
        (New-Object -ComObject Shell.Application).Namespace($extractDest).CopyHere((New-Object -ComObject Shell.Application).Namespace($fullPath).Items(),$flags)
        Remove-Item $fullPath -Force
    }
}