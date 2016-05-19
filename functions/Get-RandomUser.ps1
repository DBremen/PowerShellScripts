function Get-RandomUser {
    <#
        .SYNOPSIS
            Generate random user data.
        .DESCRIPTION
            This function uses the free API for generating random user data from https://randomuser.me/
        .EXAMPLE
            Get-RandomUser 10
        .EXAMPLE
            Get-RandomUser -Amount 25 -Nationality us,gb -Format csv -ExludeFields picture
        .LINK
            https://randomuser.me/
        .NOTES
            Author: Øyvind Kallstad
            Date: 08.04.2016
            Version: 2.0
    #>
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [ValidateRange(1,5000)]
        [alias('Results')]
        [int] $Amount,

        [Parameter()]
        [ValidateSet('Male','Female')]
        [string] $Gender,

        # Pictures won't be affected by this, but data such as location, cell/home phone, id, etc. will be more appropriate.
        [ValidateSet('AU','BR','CA','CH','DE','DK','ES','FI','FR','GB','IE','IR','NL','NZ','TR','US')]
        [alias('Nat')]
        [string[]] $Nationality,

        # Seeds allow you to always generate the same set of users.
        [int] $Seed,

        [ValidateSet('json','csv','yaml','xml')]
        [string] $Format = 'json',

        # Fields to include in the results.
        [ValidateSet('gender','name','location','email','login','registered','dob','phone','cell','id','picture','nat')]
        [alias('Inc')]
        [string[]] $IncludeFields,

        # Fields to exclude from the the results.
        [ValidateSet('gender','name','location','email','login','registered','dob','phone','cell','id','picture','nat')]
        [alias('Exc')]
        [string[]] $ExcludeFields
    )
    $rootUrl = "http://api.randomuser.me/?format=$($Format)"
    $htParamAlias = (Get-Command Get-RandomUser).Parameters.Values | Where-Object Aliases | 
        Select-Object Name, Aliases | Group-Object Name -AsHashTable -AsString
    $PSBoundParameters.GetEnumerator() | foreach {
        $value = $_.Value -join ','
        $key = $_.Key
        if ($htParamAlias.ContainsKey($key)){
            $key = $htParamAlias.$Key.Aliases.ToLower()
        }
        $rootUrl += "&$key=$value"
    }
    Invoke-RestMethod -Uri $rootUrl
}