Get-ChildItem $psscriptroot\ -Include '*.ps1' -Recurse | where { $_.DirectoryName -ne 'C:\Scripts\ps1\PowerShellScripts' } | ForEach-Object { 
	#write-host $_.FullName
	. $_.FullName 
}