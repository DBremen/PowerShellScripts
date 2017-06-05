Get-ChildItem $psscriptroot\ -Include '*.ps1' -Recurse | ForEach-Object { 
	#write-host $_.FullName
	. $_.FullName 
}