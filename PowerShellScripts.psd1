#
# Module manifest for module 'PowerShellScripts'
#
# Generated by: Dirk
#
# Generated on: 07/06/2019
#

@{

# Script module or binary module file associated with this manifest.
# RootModule = ''

# Version number of this module.
ModuleVersion = '1.0'

# Supported PSEditions
# CompatiblePSEditions = @()

# ID used to uniquely identify this module
GUID = 'af69d37a-16bc-4314-b381-9f99471fc931'

# Author of this module
Author = 'Dirk'

# Company or vendor of this module
CompanyName = 'Unknown'

# Copyright statement for this module
Copyright = '(c) 2019 Dirk. All rights reserved.'

# Description of the functionality provided by this module
# Description = ''

# Minimum version of the Windows PowerShell engine required by this module
# PowerShellVersion = ''

# Name of the Windows PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the Windows PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# CLRVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
# RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
# FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
NestedModules = @(
'.\Binary wrapper\Diff-CSV.ps1',
'.\Binary wrapper\Diff-Excel.ps1',
'.\Binary wrapper\Get-ESSearchResult.ps1',
'.\Binary wrapper\SilverSearcher.ps1',
'.\Data Wrangling\Add-LookupColumn.ps1',
'.\Data Wrangling\Convert-CsvToXls.ps1',
'.\Data Wrangling\ConvertFrom-NamedCaptureGroup.ps1',
'.\Data Wrangling\Get-ChangeLog.ps1',
'.\Data Wrangling\Get-CSVDelimiter.ps1',
'.\Data Wrangling\Get-LineNumber.ps1',
'.\Data Wrangling\Get-TextWithin.ps1',
'.\Data Wrangling\grep.ps1',
'.\Data Wrangling\Group-ConsecutiveRanges.ps1',
'.\Data Wrangling\Import-Excel.ps1',
'.\Data Wrangling\Join-CSV.ps1',
'.\Data Wrangling\Join-Linq.ps1',
'.\Data Wrangling\Query-Csv.ps1',
'.\Data Wrangling\Sort-CustomList.ps1',
'.\Data Wrangling\Update-Content.ps1',
'.\Extend Builtin\Compare-File.ps1',
'.\Extend Builtin\Get-Choice.ps1',
'.\Extend Builtin\Get-HelpExamples.ps1',
'.\Extend Builtin\Get-HelpSyntax.ps1',
'.\Extend Builtin\Get-Range.ps1',
'.\Extend Builtin\Join-Tables.ps1',
'.\Extend Builtin\Simplified-Select.ps1',
'.\Extend Builtin\WhereEx.ps1',
'.\format output\Add-FormatTableView.ps1',
'.\format output\Add-PropertySet.ps1',
'.\format output\ConvertTo-HtmlConditionalFormat.ps1',
'.\format output\Format-Error.ps1',
'.\format output\Format-Pattern.ps1',
'.\format output\Get-FormatView.ps1',
'.\format output\Out-ConditionalColor.ps1',
'.\format output\Out-ConditionalColorProperties.ps1',
'.\format output\Out-Diff.ps1',
'.\modules\ACE\ACE.psm1',
'.\modules\Clear-Clipboard\Clear-Clipboard.psm1',
'.\modules\FileSearcher\FileSearcher.psm1',
'.\modules\Get-FileMethods\Get-FileMethods.psm1',
'.\modules\Get-LegacyHelp\Get-LegacyHelp.psm1',
'.\modules\Logging\Logging.psm1',
'.\modules\Out-DataGridView\Out-DataGridView.psm1',
'.\modules\Set-OOTO\Set-OOTO.psm1',
'.\programming exercises\8 Queens.ps1',
'.\programming exercises\Confirm-Brackets.ps1',
'.\programming exercises\GenerateSolveMaze.ps1',
'.\programming exercises\Get-CartesianProduct.ps1',
'.\programming exercises\TowerOfHanoi.ps1',
'.\Utils\Add-PowerShellContextMenu.ps1',
'.\Utils\ConvertFrom-ExcelClipboard.ps1',
'.\Utils\ConvertFrom-HtmlToText.ps1',
'.\Utils\ConvertTo-PSFunction.ps1',
'.\Utils\Delete-ComputerRestorePoint.ps1',
'.\Utils\ForeachFor2.ps1',
'.\Utils\Get-Breaktimer.ps1',
'.\Utils\Get-Field.ps1',
'.\Utils\Get-FileAndExtract.ps1',
'.\Utils\Get-FileEncoding.ps1',
'.\Utils\Get-FirstPSVersion.ps1',
'.\Utils\Get-FormatStrings.ps1',
'.\Utils\Get-GoogleSuggestion.ps1',
'.\Utils\Get-MSDNInfo.ps1',
'.\Utils\Get-OutputProducingCommand.ps1',
'.\Utils\Get-ParamInfo.ps1',
'.\Utils\Get-Uninstaller.ps1',
'.\Utils\Get-WIFIPassword.ps1',
'.\Utils\Invoke-ContextMenuAction.ps1',
'.\Utils\Invoke-HTMLPesterReport.ps1',
'.\Utils\Invoke-LegacyCommand.ps1',
'.\Utils\Invoke-Parallel.ps1',
'.\Utils\Invoke-Parser.ps1',
'.\Utils\Migrate-ScheduledTask.ps1',
'.\Utils\Monitor-Folder.ps1',
'.\Utils\New-PSObject.ps1',
'.\Utils\Open-Registry.ps1',
'.\Utils\Restart-Process.ps1'
)
# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = @('*')

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = @()

# Variables to export from this module
VariablesToExport = '*'

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = @('*')

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
# FileList = @()

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        # Tags = @()

        # A URL to the license for this module.
        # LicenseUri = ''

        # A URL to the main website for this project.
        # ProjectUri = ''

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        # ReleaseNotes = ''

    } # End of PSData hashtable

} # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}
































































































