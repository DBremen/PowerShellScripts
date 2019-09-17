# Migrate-ScheduledTask

## SYNOPSIS
Script to migrate scheduled tasks from Windows XP/Server 2003 to Windows 7/Server 2008 task scheduler

## Script file
Utils\Migrate-ScheduledTask.ps1

## SYNTAX

```
Migrate-ScheduledTask
```

## DESCRIPTION
Script to migrate scheduled tasks from Windows XP/Server 2003 to Windows 7/Server 2008 task scheduler
provides an alternative,if running schtasks /query /s from the Win 7 machine connecting to the XP machine remotely 
is not an option (http://www.simonhampel.com/how-to-convert-scheduled-tasks-from-windows-xp-to-windows-7/)
Usage:
1.
Run the script from the XP machine (in order to export the .job files, the schtasks commandline and the script itself)
2.
Run the script from the Windows 7 machine in order to copy the .job files, and run the XP schtasks command in order to "register" the files on the 7 machine.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
#1. Run the script from the XP machine (in order to export the .job files, the schtasks commandline and the script itself)


Migrate-ScheduledTask
#2.
Run the script from the Windows 7 machine in order to copy the .job files, and run the XP schtasks command in order to "register" the files on the 7 machine.
Migrate-ScheduledTask
```
## PARAMETERS

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[http://www.digitalforensics.be/blog/?p=205](http://www.digitalforensics.be/blog/?p=205)



