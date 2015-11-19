<#
Add-Type -Path 'C:\Scripts\ps1\get-stats\HtmlAgilityPack.dll'
function html2text($html) {
    $doc = New-Object HtmlAgilityPack.HtmlDocument
    $doc.LoadHtml($html)
    [System.Web.HttpUtility]::HtmlDecode($doc.DocumentNode.InnerText)
}
#>
<#
$Site = "http://www.asknumbers.com/MilesToFeetConversion.aspx"
$Request = Invoke-WebRequest -URI $Site
$Request.AllElements | Where-Object {$_.InnerHtml -like "*=*"} |
Sort-Object { $_.InnerHtml.Length } | Select-Object InnerText -First 1
#>
function ConvertFrom-HtmlToText{
    <#
    .SYNOPSIS
        Extract the text out of a HTML string
    .DESCRIPTION
        Converts a string of HTML to an array of strings where each HTML elements text is one item using InternetExplorer COM object
    .PARAMETER html
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
        $html
    )
    $ie = New-Object -com InternetExplorer.Application
    $null = $ie.Navigate2("About:blank")
    while ($ie.Busy) {
        sleep 50
    }
    $html = @"
    <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
    <html xmlns="http://www.w3.org/1999/xhtml">
    <head></head><body>
    $html
    </body></html>
"@
    $ie.Document.documentElement.LastChild.innerHtml = $html
    $ie.Document.getElementsByTagName("*") | select -Skip 3 | select -ExpandProperty InnerText
    $null = $ie.Quit()
    $null = [System.Runtime.Interopservices.Marshal]::ReleaseComObject($ie)
}


$html = @'
<option value="Automatic removal">Automatic removal</option><option value="Manual removal">Manual removal</option><option value="No threat found">No threat found</option><option value="Semi automatic removal">Semi automatic removal</option>
'@ 

$result = html2text $html 

