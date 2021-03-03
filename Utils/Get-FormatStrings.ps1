function Get-FormatStrings{
    <#
    .SYNOPSIS
        Show common format strings for a given input and the respective outputs
    .DESCRIPTION
        Show common format strings for a given input and the respective outputs
    .PARAMETER ToBeFormatted
        The input that should be formatted. This should either be of type [int], [double], or [datetime] otherwise the function returns a warning and exits.
    .EXAMPLE
        Get-FormatStrings (Get-Date)
        #Return common format strings for date objects

        FormatString                          Output                          
        ------------                          ------                          
        '{0:d}'       -f 05/15/2018 15:33:46  5/15/2018                       
        '{0:D}'       -f 05/15/2018 15:33:46  Tuesday, May 15, 2018           
        '{0:f}'       -f 05/15/2018 15:33:46  Tuesday, May 15, 2018 3:33 PM   
        '{0:F}'       -f 05/15/2018 15:33:46  Tuesday, May 15, 2018 3:33:46 PM
        '{0:g}'       -f 05/15/2018 15:33:46  5/15/2018 3:33 PM               
        '{0:G}'       -f 05/15/2018 15:33:46  5/15/2018 3:33:46 PM    
        ...   
    .LINK
        https://powershellone.wordpress.com/2018/07/19/get-net-format-strings-for-given-input/
    #>
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, Position=0)]
        [ValidateScript({
            if (-not ($_ -is [int] -or $_ -is [double] -or $_ -is [datetime])) {
                throw “‘${_}’ is not of type [int], [double], or [datetime]. Please provide an input of a valid type.”
            }
            $true
        })]
        $ToBeFormatted
    ) 
    process{
        foreach ($item in $ToBeFormatted){
            if ($item -is [datetime]){
                $formats = 'd;D;f;F;g;G;m;r;s;t;T;u;U;y;dddd;MMMM;dd;yyyy;M/yy;dd-MM-yy;tt;zzz;R;Y' -split ';'  
            }
            elseif ($item -is [int]){
                 $formats = @'
(#).##
00.0000
0.0
0,0
d1
d2
d3
n1
n2
n3
f
x4
X4
0%
c
e
00e+0
g
0,.
'@  -split "`r`n"
            }
            elseif ($item -is [double]){
                 $formats = @'
(#).##
00.0000
0.0
0,0
n1
n2
n3
f
0%
c
e
00e+0
g
0,.
'@  -split "`r`n"
                }

                $output = $formats | ForEach-Object {  
                    [PSCustomObject]@{
                        FormatString = "{0,-14} {1}" -f "'{0:$_}'", "-f $item"
                        Output = "{0:$_}" -f $item
                    } 
                } 
                $output | Out-Default
        }
    }
}
