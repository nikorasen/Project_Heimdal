# # # # Porject HEIMDAL Primer # # # #
# Lubes up the system #
# Check Privs #
$ErrorActionPreference = "SilentlyContinue"
Function PrivCheck
{
    $ver = $Host | Select-Object version 
    if ($ver.Version.Major -gt 1) {$Host.Runspace.ThreadOptions = "ReuseThread"}
    #Verify current runnning script is run with elevated privileges
    $IsAdmin = [Security.Principal.WindowsIdentity]::GetCurrent()
    If ((New-Object Security.Principal.WindowsPrincipal $IsAdmin).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) -eq $False)
    {
        Write-Host "`n ERROR: You are NOT a local administrator. Closing this session and reopening with proper permissions..."
        $NewProc = New-Object System.Diagnostics.ProcessStartInfo "Powershell.exe";
        $newProc.Arguments = "M:\HEIMDAL.ps1"
        $NewProc.verb = "runas";
        [System.Diagnostics.Process]::Start($NewProc)
        exit 
    }
}
function FS_Verify 
{
    #Import-Module .\Functions\Modules\Blops.psm1 -Force
    #Get-ChildItem N:\EncArch | Disable-FileEncryption
    if (Test-Path N:\EncArch\Logs\HEIMDAL_Logs -eq $True)
    {
        Write-Host "N:\EncArch\Logs\HEIMDAL_Logs verified."
    } elseif (Test-Path N:\EncArch\Logs\HEIMDAL_Logs -eq $False)
    {
        mkdir N:\EncArch\Logs\HEIMDAL_Logs
        write-host "N:\EncArch\Logs\HEIMDAL_Logs created successfully."
    }
    if (Test-Path N:\EncArch\Alcatraz -eq $True)
    {
        write-host "N:\EncArch\Alcatraz verified."
    } elseif (Test-Path N:\EncArch\Alcatraz -eq $False)
    {
        mkdir N:\EncArch\Alcatraz
        write-host "N:\EncArch\Alcatraz created successfully."
    }
    if (Test-Path N:\EncArch\Kamino -eq $True)
    {
        Write-Host "N:\EncArch\Kamino verified."
    } elseif (Test-Path N:\EncArch\Kamino -eq $False)
    {
        mkdir N:\EncArch\Kamino 
        write-host "N:\EncArch\Kamino created successfully."
    }
    if (Test-Path C:\EWT -eq $True)
    {
        write-Host "C:\EWT verified."
    } elseif (Test-Path C:\EWT -eq $False)
    {
        mkdir C:\EWT
        mkdir C:\EWT\HEIMDAL 
        write-host "C:\EWT\HEIMDAL created successfully."
    }
    write-host "Archive successfully verified."
}
function TestNet 
{
    $global:Online = (Test-NetConnection).PingSucceeded
    return $global:Online
}
function FinalPrep 
{
    push-location "$env:USERPROFILE\.."
    $global:ALLPROFILES = %CD%
    pop-location
    $global:Timestamp = (Get-Date -Format o | ForEach-Object { $_ -replace ':', '.' } )
    $global:WinVer = (Get-WmiObject -class Win32_OperatingSystem).Caption
    return $ALLPROFILES
    return $Timestamp
    return $WinVer
}
function init_LogHeader
{
    $DevID = hostname
    $Tzone = (Get-Timezone).Id 
    Write-host "$header `n" | & $Chop
    Write-Host " HEIMDAL v. $Script_Version     Updated: $Script_Date `n" | & $Chop
    Write-Host " Windows Build: $WinVer `n" | & $Chop
    Write-Host " Executing as:      $Env:Username on $DevID `n" | & $Chop
    Write-Host " Logfile:           $global:LOGPATH\$global:LOGFILE `n" | & $Chop
    Write-Host " Timezone:          $Tzone `n" | & $Chop
    Write-Host " Run Start Time:    $global:Start_Time `n" | & $Chop
}
function Get-DiskSpace
{
    Write-Host "Disk Space before HEIMDAL Run: " | & $Chop
    Get-CimInstance -Class CIM_LogicalDisk | Select-Object @{Name="Size(GB)";Expression={$_.size/1gb}}, @{Name="Free Space(GB)";Expression={$_.freespace/1gb}}, @{Name="Free (%)";Expression={"{0,6:P0}" -f(($_.freespace/1gb) / ($_.size/1gb))}}, DeviceID, DriveType | Where-Object DriveType -EQ '3' | & $Chop 
}
function InternalChecks
{
    if ($Online -eq $False)
    {
        write-host "No Network connection detected, skipping update checks." | & $Chop 
    } elseif ($Online -eq $True)
    {
        write-host "Checking for updates..." | & $Chop
        Install-module PSWindowsUpdate -confirm:$False
        Import-Module PSWindowsUpdate 
        Get-WindowsUpdate -Microsoftupdate -AcceptAll -ForceDownload -ForceInstall
        Download-WindowsUpdate -MicrosoftUpdate -AcceptAll -ForceDownload -ForceInstall
        Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -ForceDownload -ForceInstall -IgnoreReboot -Confirm:$False
        Write-Host "Update checks complete." | & $Chop
    }
}
function SetPath
{
    $global:WMIC = "C:\Windows\System32\wbem\wmic.exe"
    $global:FIND = "C:\Windows\System32\find.exe"
    $global:FINDSTR = "C:\Windows\System32\findstr.exe"
    $global:REG = "C:\Windows\System32\reg.exe"
    return $WMIC
    return $FIND
    return $FINDSTR
    return $REG
}
Function Primer
{
    PrivCheck
    FS_Verify
    TestNet
    FinalPrep
    init_LogHeader
    Get-DiskSpace
    InternalChecks
    SetPath
}
Primer