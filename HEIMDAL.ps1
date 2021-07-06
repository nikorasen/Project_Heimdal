#           Project HEIMDAL: Antivirus & Optimization Suite
#           Purpose: All-In-One Malware removal suite, system optimization, and system cleanup, as automated as possible.
#           Inspired by Vocatus's TRON bat script suite
#           Mostly CLI enabled tools, some are manual and must be run at the end. Please consult the README for more information
#           Author: Nic "RANT" Colon        "The lie is that you weren't complete to begin with..."
#                                           "Just because you have a choice, it doesn't mean one of them HAS to be right."
#           Requirements: Windows 10 installation version 1903 or higher.
#           Version:                        3.0.0.1
#           Usage:                          Run as administrator, follow the prompts, reboot when finished. 
#                                           Read the instructions within the README for information on changing default run options.  
#  
###########################
###Initial Prep & Checks###
###########################
Add-Type -AssemblyName PresentationCore,PresentationFramework
$ErrorActionPreference = "SilentlyContinue"
Set-ExecutionPolicy unrestricted
$global:SCRIPT_VERSION = "3.0.0.1 'Vonnegut'"
$global:SCRIPT_DATE = 2021-07-06
$global:LOGPATH = "N:\EncArch\Archive"
$global:RAW_LOGPATH = "N:\EncArch\Archive\RAW_Logs"
$global:RAW_LOG = "N:\EncArch\Archive\RAW_Logs\HEIMDAL_RAW.txt"
$global:BRIG = "N:\EncArch\Alcatraz"
$global:KAMINO = "N:\EncArch\Kamino"
#$LOGFILE = "$LOGPATH\ELSETRON_RAW_run.log"
$global:LockUp = "$Brig\Solitary"
$global:Header = "======================================================================================================================="
$global:HalfHead = "================================="
$global:Head1 = "`n $Header `n $halfhead" 
$global:Head2 = "$halfhead `n $header `n"
#$Chop = Out-file -Filepath $LOGFILE -Append
$global:Timestamp = Get-Date -Format o | ForEach-Object { $_ -replace ':', '.' } 
$global:Users = Get-ChildItem C:\Users
$global:Toolbox = "M:\Functions\Toolbox"
$global:Mods = "M:\Functions\Modules"
$global:DevID = hostname
$global:LOGFILE = "N:\EncArch\Archive\{$global:DevID}_Heimdal_Log_{$global:Timestamp}.txt"
Write-Host "... Initiating HEIMDAL v3.0.0.1 ... "
Write-Host "HEIMDAL started at $global:Timestamp" 2>&1 >> $global:RAW_LOG
#
function init1
{
    $~d0 2>NUL 
    push-location "$~dp0" 2>NUL 
    push-location resources 
    Write-Host "HEIMDAL v3.0.0.1 'Vonnegut'" 
    Write-Host "HEIMDAL SEES ALL. HEIMDAL KNOWS ALL. HEIMDAL is the culmination of every virus's worst nightmare composed into one graceful gravity bomb" 
    Write-Host "HEIMDAL will now clone and collect detailed logs on the compromised system."
}
function Flashpoint
{
    $Global:Start_Time = Get-Date -Format o | ForEach-Object { $_ -replace ':', '.'}
    ."M:\Functions\Modules\Primer.ps1"
    init1
    SetPath 
    # # # # HEIMDAL PHASES BEGIN # # # #
    ."M:\Functions\Phases\Phase_0.ps1"
    ."M:\Functions\Phases\Phase_1.ps1"
    ."M:\Functions\Phases\Phase_2.ps1"
    ."M:\Functions\Phases\Phase_3.ps1"
    ."M:\Functions\Phases\Phase_4.ps1"
    ."M:\Functions\Phases\Phase_5.ps1"
    ."M:\Functions\Phases\Phase_6.ps1"
    $Global:End_Time = Get-Date -Format o | ForEach-Object { $_ -replace ':', '.' } 
    ."M:\Functions\Phases\Phase_7.ps1"
    ."M:\Functions\Phases\Phase_8.ps1"
    # # # # HEIMDAL COMPLETE # # # # 
}
Flashpoint