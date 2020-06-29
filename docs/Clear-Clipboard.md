# Clear-Clipboard

## SYNOPSIS
Identify the process that currently blocks the clipboard (Using GetOpenClipboardWindow and GetWindowThreadProcessId API calls)
Opens a small GUI offering options to either stop or restart the process

## Script file
Clear-Clipboard\Clear-Clipboard.psm1

## Related blog post
https://powershellone.wordpress.com/2016/02/25/fix-clipboard-is-not-working-restart-process-with-powershell/

## SYNTAX

```
Clear-Clipboard
```
## DESCRIPTION
Sometimes it happens that the clipboard stops working.
The routine of copy and paste we all rely on so many times a day suddenly refuses to do its job. 
The reason this happens is usually an application blocking the keyboard, making it impossible for other applications to get access to the clipboard. 
In order to fix this, one needs to find out which application is the culprit and either stop or restart the respective process in order to "free up" the clipboard.
I put together a small PowerShell function (Clear-Clipboard), that does just that.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Clear-Clipboard
```
## PARAMETERS

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://powershellone.wordpress.com/2016/02/25/fix-clipboard-is-not-working-restart-process-with-powershell/](https://powershellone.wordpress.com/2016/02/25/fix-clipboard-is-not-working-restart-process-with-powershell/)



