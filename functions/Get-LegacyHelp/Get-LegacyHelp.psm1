function Prepare-Environment{
    $agilityPath = "$rootFolder\lib\HtmlAgilityPack.dll"

     #download windows commandline help if not present
    if (!(Test-Path "$dataFolder\WinCmdRef.chm")){
        Write-Host "Windows commandline reference (WinCmdRef.chm) not found. Downloading it now!"
        $url = 'https://download.microsoft.com/download/7/2/9/729BB069-C0B9-4C68-9245-0ED23C11B6ED/WinCmdRef.chm'
        $fullPath = Join-Path $dataFolder $url.Split("/")[-1]
        (New-Object Net.WebClient).DownloadFile($url,$fullPath)
    }
    #download html agility pack if not present
    if (!(Test-Path $agilityPath)){
        Write-Host "HTML agility pack DLL (HtmlAgilityPack.dll) not found. Downloading it now!"
        #using codeplex download to make it work with older PowerShell version
        $tempFolder = New-Item "$env:Temp\AgilityDownload" -ItemType Directory -force
        $url = 'http://download-codeplex.sec.s-msft.com/Download/Release?ProjectName=htmlagilitypack&DownloadId=437941&FileTime=129893731308330000&Build=21031'
        $downloadPath = "$tempFolder\HtmlAgilityPack.1.4.6.zip"
        (New-Object Net.WebClient).DownloadFile($url, $downloadPath)
        (New-Object -ComObject Shell.Application).Namespace($tempFolder).CopyHere((New-Object -ComObject Shell.Application).Namespace($downloadPath).Items(),16)
        #only copy the .net 4.5 assembly
        Copy-Item "$tempFolder\net45\HtmlAgilityPack.dll" $agilityPath
        del $tempFolder -Recurse -Force
    }
}

function Decompile-HelpFile{
    hh.exe -decompile ""$dataFolder"" ""$dataFolder\WinCmdRef.chm""
}


function Rename-CmdFiles($dataFolder){
    $doc.Load("$dataFolder\WinCmdRef.hhc")
    $nodes = $doc.DocumentNode.SelectSingleNode('html[1]/body[1]/ul[1]/li[1]/ul[1]/li')
    $commands = $nodes.SelectNodes('ul')
    foreach ($command in $commands){
        if (($command.Descendants().SelectNodes('ul') | Measure-Object).Count){
            #command that contains subcommands
            $name, $relativePath = ($command.Descendants().SelectNodes('param') | select -First 2).Attributes[1,3].Value
            $relativePath = $relativePath.SubString(5)
            ren -Path "$dataFolder\html\$relativePath" -NewName ($name + '.htm')
            $subcommands = $command.Descendants().SelectNodes('ul')
            #prefix subcommands with _commandName
            foreach ($subcommand in $subcommands){
                if ($subcommand){
                    $subname, $relativePath = $subcommand.Descendants().SelectNodes('param').Attributes[1,3].Value
                    #make sure that the command name only appears once
                    $subname = "_$name " + $subname.Replace($name,'').Trim()
                    if ($subname -match '["\\/:|?*<>]'){
                        #replace invalid characters by placeholders
                        foreach($key in $htReplacements.Keys){
                            $subname = $subname.Replace($key,$htReplacements.$key)
                        }
                    }
                    $relativePath = $relativePath.SubString(5)
                    ren -Path "$dataFolder\html\$relativePath" -NewName ($subname + '.htm')
                }
            }
        }
        else{
            $name, $relativePath = $command.Descendants().SelectNodes('param').Attributes[1,3].Value
            $relativePath = $relativePath.SubString(5)
            ren -Path "$dataFolder\html\$relativePath" -NewName ($name + '.htm')
        } 
    }
    $nodes = $doc.DocumentNode.SelectSingleNode('html[1]/body[1]/ul[1]/li[1]/ul[3]/li')
    $nodes = $nodes.Clone()
    $commands = $nodes.SelectNodes('ul')
    foreach ($command in $commands){
        $name, $relativePath = $command.Descendants().SelectNodes('param').Attributes[1,3].Value
        #ren -Path "$dataFolder\$relativePath" -NewName ($name + '.htm') 
        #check if the subcommands are identified correctly
        if ($name){
            $doc.Load("$dataFolder\html\$($name + '.htm')")
            $rows = $doc.DocumentNode.SelectNodes('//table')[1].ChildNodes | where Name -eq 'tr' |
                select -Skip 1
            foreach ($row in $rows){
                $subCommandName = ($row.ChildNodes | where Name -eq 'td')[0].InnerText.Trim()
                if (Test-Path "$dataFolder\html\$($subCommandName + '.htm')"){
                    $newName = '_' + $name + '_' + $subCommandName
                    ren -Path "$dataFolder\html\$($subCommandName + '.htm')" -NewName ($newName + '.htm')
                }
            }
        }
    }

}

function Get-Parameters($doc,$htCommand){
    #check for parameters
    $div = $doc.DocumentNode.SelectNodes("//h2[@class='heading'][contains(., 'Parameter')]/following-sibling::div") 
    if (!$div){
        $div = $doc.DocumentNode.SelectNodes("//h5[@class='subHeading'][contains(., 'Parameter')]/following-sibling::div") 
    }
    if ($div){
        $table = $table=$div.FindFirst('table')
            if($table.Count -eq $null){
            $htCommand.Parameters = 'No parameters'
            return
        }
        else{
            try{$htCommand.Parameters = @()}catch{
                $htCommand
            }
            $rows = $table.ChildNodes | where Name -eq tr
            $htParams = @{}
            foreach ($row in $rows){
                $cols = $row.SelectNodes('td')
                $colCount = 1
                foreach ($col in $cols){
                    if ($colCount -eq 1){
                        $paramSyntax = ([Web.HttpUtility]::HtmlDecode($col.InnerText)).Trim()
                        $paramName = ($paramSyntax -replace '[/\[]' -replace ':.*').Trim()
                    }
                    else{
                        if ($paramName){
                            $paramSyntaxDesc = [Web.HttpUtility]::HtmlDecode($col.InnerText).Trim()
                            $htCommand.Parameters += [PSCustomObject]@{            
                                Name        = $paramName
                                Syntax      = $paramSyntax
                                Description = $paramSyntaxDesc
                            }
                        }
                    }
                    $colCount++
                }
            }
        }
        New-Object PSObject -Property $htCommand
    }
}

function Get-Properties($doc,$htCommand){
    $paragraphs = $doc.DocumentNode.SelectNodes("//div[@id='mainBody']/p")
    if ($paragraphs){
        $htCommand.AppliesTo = $paragraphs[0].InnerText.Replace('Applies To:','').Trim().Split(',')
        $htCommand.Description = $paragraphs[1..($paragraphs.Count-1)].InnerText.Trim()
    }
    #check for Remarks
    $div = $doc.DocumentNode.SelectNodes("//h2[@class='heading'][contains(., 'Remarks')]/following-sibling::div") 
    if (!$div){
        $div = $doc.DocumentNode.SelectNodes("//h5[@class='subHeading'][contains(., 'Remarks')]/following-sibling::div") 
    }
    if ($div){
        $remarks = $div.FindFirst('ul')
        if (!$ul){
            $remarks = $div.FindFirst('content')
        }
        $htCommand.Remarks = ($remarks.InnerText.Split("`n").Trim() | where {$_}) -join "`n"            
    }
    #check for syntax
    $div = $doc.DocumentNode.SelectNodes("//h2[@class='heading'][contains(., 'Syntax')]/following-sibling::div") 
    if (!$div){
        $div = $doc.DocumentNode.SelectNodes("//h5[@class='subHeading'][contains(., 'Syntax')]/following-sibling::div") 
    }
    if ($div){
        $table = $table=$div.FindFirst('table')
        if($table.Count -ne $null -and $table.Count -ne 0){
            #skip the header row
            $htCommand.Syntax = [Web.HttpUtility]::HtmlDecode(($table.ChildNodes | where Name -eq tr | select -Skip 1).InnerText) -join "`n"
        }
        else{
            $htCommand.Syntax = [Web.HttpUtility]::HtmlDecode($div.FindFirst('p').InnerText)
        }
    }
    #check for Examples
    $div = $doc.DocumentNode.SelectNodes("//h2[@class='heading'][contains(., 'Examples')]/following-sibling::div") 
    if (!$div){
        $div = $doc.DocumentNode.SelectNodes("//h5[@class='subHeading'][contains(., 'Examples')]/following-sibling::div") 
    }
    if ($div){
        $htCommand.Example = @()
        $content = $div.FindFirst('content').ChildNodes | 
            where {$_.InnerText.Trim() -ne ''}
        $index = 0
        foreach($item in $content){
            $htExample = @{}
            $nextContent = $content[$index+1].InnerText
            if ($nextContent) { $nextContent = $nextContent.Trim() }
            if ($item.Name -eq 'p' -or $nextContent -like '*Copy Code*' -or 
                $nextContent -like '/*'){
                $htExample.Add('Description',$item.InnerText.Trim())
            }
            elseif($item.Name -eq 'div' -or $content[$index].InnerText.Trim() -like '/*'){
                $htExample.Add('Code',$item.InnerText.Replace('Copy Code','').Trim())
                #check if the next two elements are p's if yes add the first one to the description
                #or a div without Copy Code 
                if ($content[$index+1].Name -eq 'p' -and $content[$index+2] -eq 'p' -or 
                  $content[$index+1].Name -eq 'div' -and $nextContent -notlike '*Copy Code*' -and 
                   $content[$index+2].InnerText -notlike '*Copy Code*'){
                    $htExample.Description += "`n" + $nextContent
                    $htCommand.Example += New-Object PSObject -Property $htExample
                    $index+=2
                    $null = $foreach.MoveNext()
                    continue
                }
                $htCommand.Example += New-Object PSObject -Property $htExample
            }
            $index++
        }
    }
    $htCommand
}

function Get-Info($dataFolder){
    #parse first command files only
    $files = dir $dataFolder | where {!$_.BaseName.StartsWith('_') -or $_.BaseName.Split('_').Count -gt 2}
    $commands =foreach ($file in $files){
        $htCommand=@{}
        #check for commands per server role
        if ($file.BaseName.Split('_').Count -gt 2){
            $htCommand.ServerRole = $file.BaseName.Split('_')[-2]
            $htCommand.Name = $file.BaseName.Split('_')[-1]
        }
        else{
            $htCommand.Name = ($file.BaseName).Trim()
        }
        $doc.Load($file.Fullname)
        $htCommand = Get-Properties $doc $htCommand
        $object = Get-Parameters $doc $htCommand
        if ($object -eq $null){
            $htCommand.Parameters = @()
            $object = New-Object PSObject -Property $htCommand
        }
        $object
    }
    #if file is a subcommand add the syntax to an existing object
    $files = dir $dataFolder | where {$_.BaseName.StartsWith('_') -and -not($_.BaseName.Split('_').Count -gt 2)}
    foreach ($file in $files){
        $name = $file.BaseName.Replace('_','').Split(' ')[0]
        $object = $commands | where Name -eq $name 
        $doc.Load($file.FullName)
        $subCommandName = $doc.DocumentNode.SelectSingleNode("//span[@id='nsrTitle']").InnerText.
                replace("$($object.Name)",'').replace('/','').Trim()
        $htSubCommand = @{}
        $htSubCommand.Name = $subCommandName
        $htSubCommand = Get-Properties $doc $htSubCommand
        $subCommand = Get-Parameters $doc $htSubCommand
        #remove the link reference of the high level description
        if (($object.Parameters | where Name -eq "$subCommandName")){
            ($object.Parameters | where Name -eq "$subCommandName").Description = (($object.Parameters | where Name -eq "$subCommandName").
                Description -replace 'See.*for syntax and options.').Trim()
        }
        if (($object | Get-Member -MemberType NoteProperty).Name -notcontains 'SubCommands'){
            $object | Add-Member -MemberType NoteProperty -Name SubCommands -Value @()
        }
        $object.SubCommands += $subCommand
    }
    $commands | where {$_.Name -notlike '*reference'} | Export-CliXml -Path "$($dataFolder.Replace('\html',''))\commands.xml" -Depth 5
}

function Generate-LegacyHelp{
    
    #check for pre-requesites and download them if not present (Windows Commandline reference + HTML Agility Pack
    Prepare-Environment

    $script:htReplacements=@{
        ':'='colon';'?'='questionmark';'\'='backslash';'/'='slash';'*'='asterisk';'|'='pipe';
        '<'='smallerthan';'>'='greaterthan';'"'='quotationmark'
    }
    Add-Type -AssemblyName System.Web
    Add-Type -Path $agilityPath
    $script:doc = New-Object HtmlAgilityPack.HtmlDocument
    Decompile-HelpFile

    #walk through the index file to rename the individual help files + mark those files that represent sub-commands
    Rename-CmdFiles $dataFolder

    #walk through the commandline help files to parse out the information and export it to xml
    Get-Info "$dataFolder\html"
}


function Get-LegacyHelp {
    <#
        .SYNOPSIS
            Display help for windows commandline commands
        .DESCRIPTION
            Similar to the built-in PowerShell help this function displays help for windows commmandline commands
        .EXAMPLE
            Get-LegacyHelp chkdsk
        .EXAMPLE
            Get-LegacHelp chkd* -Parameter c
        .EXAMPLE
            Get-LegacHelp chkd* -Parameter *
        .LINK
          
    #>
    [CmdletBinding(DefaultParameterSetName='Set1')]
    [Alias('glh')]
    param (
        #The name of the legacy windows command to find the help for. Wildcards are permitted.
        [Parameter(Mandatory,Position = 0, ParameterSetName = 'Set1')]
        [Parameter(Mandatory,Position = 0, ParameterSetName = 'Set2')]
        [Parameter(Mandatory,Position = 0, ParameterSetName = 'Set3')]
        [string]$Name, 
        
        #Displays only the detailed descriptions of the specified parameters. Wildcards are permitted.
        [Parameter(ParameterSetName = 'Set2')]
        [string]$Parameter,

        #Displays only the Name, Description and the examples for the legacy command
        [Parameter(ParameterSetName = 'Set3')]
        [switch]$Examples,

        #Displays the entire help topic for a windows legacy command, including parameter descriptions
        [Parameter(ParameterSetName = 'Set1')]
        [switch]$Full
    )

    $script:rootFolder = $PSScriptRoot
    $script:dataFolder = "$rootFolder\data"

    #generate commands.xml if it is not present
    if (!(Test-Path "$dataFolder\commands.xml")){
        Generate-LegacyHelp
    }

    $help = Import-CliXml -Path "$script:dataFolder\commands.xml" | where {$_.Name -like $Name}
    #if multiple items found, just show matching command names and description
    if ($help.Count -gt 1){
        $help | select Name, Description
    }
    elseif ($help){
        if ($Examples){
            if ($help.Example.Count){
                $output = "`nNAME`n " +`
                ("   $($help.Name)`n") +`                "`nDESCRIPTIOM`n " +`                (($help.Description | Select-String '\w' | Out-String -Width 80).Split("`n") | where {$_.Trim()} | foreach { [System.Net.WebUtility]::HtmlDecode($_.TrimStart().PadLeft($_.Length + 3)) + "`n"  })
                 for ($i=0;$i -lt $help.Example.Count;$i++){
                            $header = "-------------------------- EXAMPLE $($i+1) --------------------------`n`n"
                            $output += "`n`n" + $header.PadLeft($header.Length + 3) 
                            $output += (($help.Example[$i].Code | Select-String '\w' | Out-String -Width 80).Split("`n") | where {$_.Trim()} | foreach { [System.Net.WebUtility]::HtmlDecode($_.TrimStart().PadLeft($_.Length + 3)) + "`n`n"  })
                }
             }
        }
        elseif ($Parameter){
            $output = ''
            $matchingParams = $help.Parameters | where {$_.Name -like $Parameter}
            foreach ($matchingParam in $matchingParams){
                $output += "`n" + [System.Net.WebUtility]::HtmlDecode($matchingParam.Syntax.TrimStart().PadLeft($matchingParam.Syntax.Length + 3)) + "`n"
                $output += [System.Net.WebUtility]::HtmlDecode($matchingParam.Description.TrimStart().PadLeft($matchingParam.Description.Length + 7)) + "`n`n"
            }
        }

        else{
            #default output
            $output = "`nNAME`n " +`
            ("   $($help.Name)`n") +`            "`nDESCRIPTIOM`n " +`            (($help.Description | Select-String '\w' | Out-String -Width 80).Split("`n") | where {$_.Trim()} | foreach { [System.Net.WebUtility]::HtmlDecode($_.TrimStart().PadLeft($_.Length + 3)) + "`n"  }) +`            "`nSYNTAX`n " +`            (($help.Syntax | Select-String '\w' | Out-String -Width 80).Split("`n") | where {$_.Trim()} | foreach { [System.Net.WebUtility]::HtmlDecode($_.TrimStart().PadLeft($_.Length + 3)) + "`n"  }) +`            "`nREMARKS`n " + `
            (($help.Remarks | Select-String '\w' | Out-String -Width 80).Split("`n") | where {$_.Trim()} | foreach { [System.Net.WebUtility]::HtmlDecode($_.TrimStart().PadLeft($_.Length + 3)) + "`n"  })

            #full output
            if ($full){
                if ($help.Parameters.Count){
                    $output += "`nParameters`n "
                    $help.Parameters | foreach{
                        $output += $_.Syntax.TrimStart().PadLeft([System.Net.WebUtility]::HtmlDecode($_.Syntax.Length + 3)) + "`n"
                        $output += $_.Description.TrimStart().PadLeft([System.Net.WebUtility]::HtmlDecode($_.Description.Length + 7)) + "`n`n"
                    }
                }
                if ($help.Example.Count){
                    for ($i=0;$i -lt $help.Example.Count;$i++){
                            $header = "-------------------------- EXAMPLE $($i+1) --------------------------`n`n"
                            $output += "`n`n" + $header.PadLeft($header.Length + 3) 
                            $output += (($help.Example[$i].Code | Select-String '\w' | Out-String -Width 80).Split("`n") | where {$_.Trim()} | foreach { [System.Net.WebUtility]::HtmlDecode($_.TrimStart().PadLeft($_.Length + 3)) + "`n`n"  })
                    }
                }
            }
        }
        $output
    }
}

Export-ModuleMember Get-LegacyHelp -Alias glh

