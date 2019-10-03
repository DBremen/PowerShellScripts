Function Invoke-ContextMenuAction {
    <#
        .SYNOPSIS
        List or permforms verb actions on file system objects that show up in the context menu.

        .DESCRIPTION
        Invokes verbs that are in the context menu for the target file system item. The list of verbs is dynamic depending on what is installed on 
        your current system. Many of the verbs require user interaction but give you the ability to execute them via script. 

        .PARAMETER Path
        Path to invoke the context menu action for.

        .PARAMETER Verb
        Action to invoke from the context menu of the selected item.
        If no argument is provided the command will list the available actions for the selected item.

        .PARAMETER List
        Switch parameter if provided lists the available actions for the selected item.

        .NOTES
        Created by: Allan Miller at CHLA
        Version: 1.0
        Date: 12/20/2010
        I created this function to handle advanced file permission changes to files or folders when my fellow administrators transition to handling 
        them via the command line. Since we use dual account administration, it is not easy to manage the permission 
        on a series of folders that are in a drive mapping of your standard user.

        .EXAMPLE
        Invoke-ContextMenuAction
        This will list the verbs that are available on the current object (. or current folder).

        .EXAMPLE
        Invoke-ContextMenuAction -Path "\\server\share\directory" -Verb Properties
        This will open the properties window for the \\server\share\directory.

        .EXAMPLE
        Invoke-ContextMenuAction -Path "C:\TestDir" -Verb Cut; Invoke-ContextMenuAction -Path "\\server\share" -Verb Paste
        The copy, cut, and paste actions allow you to move items as you would using keystrokes or the mouse.
    #>
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName,
        Position = 0)] 
        [Alias("FullName")]
        $Path= ".",
        [Parameter(Position = 1)] [string]$Verb,
        [switch]$List
    )
    PROCESS{
        $Item = Get-Item $Path
        $shell = new-object -ComObject Shell.Application
        $NS = $shell.NameSpace($Item.FullName)
        $FSObject = $NS.Self
        $Verbs = $FSObject.Verbs()
        if ($List -OR $Verb -eq "") {
            if ($Verbs.Count -gt 0) {
                Write-Output "Verb List for $($Item.FullName)"
                foreach ($Action in $Verbs) { if ($Action.Name -ne "") { ($Action.Name).Replace("&", "") } }
            } #end if $Verbs
        } #end if List
        else {
            foreach ($Action in $Verbs) {
                if ((($Action.Name).Replace("&", "")) -match $Verb) { $Action.Doit() }
            } #end foreach
        } #end else List
    }
} #End Invoke-ContextMenuAction