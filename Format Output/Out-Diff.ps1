function Out-Diff {
    <#
    .Synopsis 
        Generate html diff from git diff output using diff2html.
    .Description
        Pretty HTML diff output for text and file input using git diff and diff2html.
    .Example
        #compare two strings using default outputstyle (sideByside) and diffstyle (word)
        Out-Diff 'this is a test' 'this is a new test'
    .Example
        #compare two text files using default outputstyle (sideByside) and diffstyle (word)
        Out-Diff -ReferenceFile c:\test.txt -DiffernceFile c:\test2.text
    .Example
        #compare two strings using LineByLine outputstlye and character diffstyle
        Out-Diff 'this is a test' 'this is a new test' -OutputStyle LineByLine -DiffStyle char
    .Link
        https://diff2html.xyz
    #>
    [CmdletBinding(DefaultParameterSetName = 'Text')]
    param(
        [Parameter(Mandatory, Position = 0, ParameterSetName = 'Text')]
        $ReferenceText,
        [Parameter(Mandatory, Position = 1, ParameterSetName = 'Text')]
        $DifferenceText,
        [Parameter(Mandatory, ParameterSetName = 'File')]
        [ValidateScript( {
                if (-not (Test-Path -PathType Leaf -LiteralPath $_ )) {
                    throw "Path '$_' does not exist. Please provide the path to an existing File."
                }
                $true
            })]
        $ReferenceFile,
        [Parameter(Mandatory, ParameterSetName = 'File')]
        [ValidateScript( {
                if (-not (Test-Path -PathType Leaf -LiteralPath $_ )) {
                    throw "Path '$_' does not exist. Please provide the path to an existing File."
                }
                $true
            })]
        $DifferenceFile,
        [ValidateSet('LineByLine', 'SideBySide')]
        $OutputStyle = 'SideBySide'
    )
    try {
        $Null = Get-Command diff2html.cmd -ErrorAction Stop
    }
    catch {
        Write-Warning 'diff2html is not installed. Go to https://diff2html.xyz/#cli for instructions on how to install it'
        exit
    }
    try {
        $Null = Get-Command git.exe -ErrorAction Stop
    }
    catch {
        Write-Warning 'git.exe is not installed. Please install git.exe.'
        exit
    }
    if ($ReferenceText) {
        $ReferenceFile = [IO.Path]::GetTempFileName()
        $ReferenceText | Set-Content $ReferenceFile
        $DifferenceFile = [IO.Path]::GetTempFileName()
        $DifferenceText | Set-Content $DifferenceFile
    }
    
    $style = [regex]::Match($OutputStyle, '(.*)By.*').Groups[1].Value.ToLower()
    
    $Null = git diff "$ReferenceFile" "$DifferenceFile" | diff2html -i stdin -s $style 
    #diff2html -s line -f html -d word -i command -o preview -- -M HEAD~1
    if ($ReferenceText) {
        Remove-Item $ReferenceFile
        Remove-Item $DifferenceFile
    }
}