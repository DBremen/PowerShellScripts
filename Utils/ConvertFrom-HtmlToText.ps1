function ConvertFrom-HtmlToText{
    <#
    .SYNOPSIS
        Extract the text out of a HTML string
    .DESCRIPTION
        Converts a string of HTML to an array of strings where each HTML elements text is one item, using InternetExplorer COM object
    .PARAMETER HTML
        The HTML fragment (The function automatically wraps it into well-formed HTML)
    .EXAMPLE
        #using alias
        PS> '<li>test1</li><li>test2</li>' | html2Text
        #output: 
        test1
        test2
    #>
    [CmdletBinding()]
    [Alias("Html2text")]
    param(
        [Parameter(Mandatory, 
                   ValueFromPipeline, 
                   Position=0)]
        $HTML
    )
    $ie = New-Object -com InternetExplorer.Application
    $null = $ie.Navigate2("About:blank")
    while ($ie.Busy) {
        Start-Sleep 50
    }
    $newHTML = @"
    <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
    <html xmlns="http://www.w3.org/1999/xhtml">
    <head></head><body>
    $HTML
    </body></html>
"@
    $ie.Document.documentElement.LastChild.innerHtml = $newHTML
    $ie.Document.getElementsByTagName("*") | Select-Object -Skip 3 | Select-Object -ExpandProperty InnerText
    $null = $ie.Quit()
    $null = [System.Runtime.Interopservices.Marshal]::ReleaseComObject($ie)
}