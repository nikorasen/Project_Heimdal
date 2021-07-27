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
    if (Test-Path N:\EncArch\Archive -eq $True)
    {
        Write-Host "N:\EncArch\Archive verified."
    } elseif (Test-Path N:\EncArch\Archive -eq $False)
    {
        mkdir N:\EncArch\Archive
        write-host "N:\EncArch\Archive created successfully."
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
    if (test-path "$global:logpath\Final_Report" -eq $true)
    {
        write-host "Final Archive Verified"
    } elseif (Test-Path "$global:Logpath\Final_Report" -eq $False)
    {
        mkdir "$global:logpath\Final_Report"
        write-host "Final Report archive created successfully"
    }
    if (test-path "M:\Toolbox" -eq $true)
    {
        write-host "Toolbox Verified."
    } elseif (test-path "M:\Toolbox" -eq $false)
    {
        mkdir "M:\Toolbox"
        write-host "Toolbox created successfully."
    }
    write-host "Archive successfully verified."
}
#function TestNet 
#{
#    $global:Online = (Test-NetConnection).PingSucceeded
#    return $global:Online
#}
function FinalPrep 
{
    push-location "$env:USERPROFILE\.."
    $global:ALLPROFILES = %CD%
    pop-location
    $Time = Get-Date
    $Timestamp = $Time.ToString("u")
    $global:WinVer = (Get-WmiObject -class Win32_OperatingSystem).Caption
    return $ALLPROFILES
    return $Timestamp
    return $WinVer
}
function init_LogHeader
{
    $DevID = hostname
    $Tzone = (Get-Timezone).Id 
    Write-host "$header `n" | 2>&1 >> $Global:RAW_LOG
    Write-Host " HEIMDAL v. $Script_Version     Updated: $Script_Date `n" | 2>&1 >> $Global:RAW_LOG
    Write-Host " Windows Build: $WinVer `n" | 2>&1 >> $Global:RAW_LOG
    Write-Host " Executing as:      $Env:Username on $DevID `n" | 2>&1 >> $Global:RAW_LOG
    Write-Host " Logfile:           $global:LOGPATH\$global:LOGFILE `n" | 2>&1 >> $Global:RAW_LOG
    Write-Host " Timezone:          $Tzone `n" | 2>&1 >> $Global:RAW_LOG
    Write-Host " Run Start Time:    $global:Start_Time `n" | 2>&1 >> $Global:RAW_LOG
}
function Get_DiskSpace
{
    Write-Host "Disk Space before HEIMDAL Run: " | 2>&1 >> $Global:RAW_LOG
    Get-CimInstance -Class CIM_LogicalDisk | Select-Object @{Name="Size(GB)";Expression={$_.size/1gb}}, @{Name="Free Space(GB)";Expression={$_.freespace/1gb}}, @{Name="Free (%)";Expression={"{0,6:P0}" -f(($_.freespace/1gb) / ($_.size/1gb))}}, DeviceID, DriveType | Where-Object DriveType -EQ '3' | 2>&1 >> $Global:RAW_LOG 
}
#function InternalChecks
#{
#    if ($Online -eq $False)
#    {
#        write-host "No Network connection detected, skipping update checks." | 2>&1 >> $Global:RAW_LOG 
#    } elseif ($Online -eq $True)
#    {
#        write-host "Checking for updates..." | 2>&1 >> $Global:RAW_LOG
#        Install-module PSWindowsUpdate -confirm:$False
#        Import-Module PSWindowsUpdate 
#        Get-WindowsUpdate -Microsoftupdate -AcceptAll -ForceDownload -ForceInstall
#        Download-WindowsUpdate -MicrosoftUpdate -AcceptAll -ForceDownload -ForceInstall
#        Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -ForceDownload -ForceInstall -IgnoreReboot -Confirm:$False
#        Write-Host "Update checks complete." | 2>&1 >> $Global:RAW_LOG
#    }
#}
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
function init_7zip
{
    if (test-path "$env:ProgramFiles\7-Zip")
    {
        new-alias 7z "$env:ProgramFiles\7-zip\7z.exe"
    } else
    {
        wget "https://www.7-zip.org/a/7z1900-x64.exe" -outfile "C:\EWT\7z1900-x64.exe"
        msiexec.exe /i "C:\EWT\7z1900-x64.exe" /qn
        start-sleep -s 120
        rm -force "C:\EWT\7*"
        new-alias 7z "$env:ProgramFiles\7-zip\7z.exe"
    }
}
function Hardware_Store
{
    $global:Toolbox = "M:\Toolbox"
    $Tools = $global:Toolbox
    wget https://www.nirsoft.net/utils/cports-x64.zip -outfile "$Tools\cports.zip"
    wget https://www.nirsoft.net/utils/networktrafficview-x64.zip -outfile "$Tools\NetTraffView.zip"
    wget https://www.nirsoft.net/utils/browserdownloadsview-x64.zip -outfile "$tools\BroDownView.zip"
    wget https://www.nirsoft.net/utils/browsinghistoryview-x64.zip -outfile "$Tools\BroHisView.zip"
    wget https://www.nirsoft.net/utils/chromecookiesview.zip -outfile "$Tools\ChromeCooks.zip"
    wget https://www.nirsoft.net/utils/edgecookiesview.zip -outfile "$Tools\EdgeCooks.zip"
    wget https://www.nirsoft.net/utils/mzcv-x64.zip -outfile "$Tools\FoxCooks.zip"
    wget https://www.nirsoft.net/utils/ofview-x64.zip -outfile "$Tools\OFView.zip"
    wget https://www.nirsoft.net/utils/appnetworkcounter-x64.zip -outfile "$Tools\AppNetCount.zip"
    wget https://www.nirsoft.net/utils/networkusageview-x64.zip -outfile "$Tools\NetUseView.zip"
    wget https://www.nirsoft.net/utils/uninstallview-x64.zip -outfile "$Tools\UninView.zip"
    wget https://www.nirsoft.net/utils/installedappview-x64.zip -outfile "$Tools\InstAppView.zip"
    wget https://www.nirsoft.net/utils/installedpackagesview-x64.zip -outfile "$Tools\InstPckView.zip"
    wget https://www.nirsoft.net/utils/executedprogramslist.zip -outfile "$Tools\ExeProList.zip"
    wget https://www.nirsoft.net/utils/winlogonview.zip -outfile "$Tools\WinLogView.zip"
    wget https://www.bleepingcomputer.com/download/rkill/dl/10/ -outfile "$Tools\Vaccine.exe"
    wget https://devbuilds.s.kaspersky-labs.com/devbuilds/KVRT/latest/full/KVRT.exe -outfile "$Tools\Dimitri.exe"
    wget https://download.comodo.com/cce/download/setups/cce_public_x64.zip -outfile "$Tools\Dragon.zip"
    wget https://downloads.malwarebytes.com/file/adwcleaner -outfile "$Tools\Baptism.exe"
    wget https://www.malwarebytes.com/mwb-download/thankyou/ -outfile "$Tools\ManualAV\Mbam.exe"
    wget https://download.immunet.com/binaries/immunet/bin/ImmunetSetup.exe -outfile "$Tools\ManualAV\ImmunetSetup.exe"
    wget https://www.ccleaner.com/ccleaner/download/standard -outfile "$Tools\ccleaner.exe"
    wget https://www.sentex.ca/~mwandel/finddupe/finddupe.exe -outfile "$Tools\finddupe.exe"
    wget https://www.portablefreeware.com/download.php?dd64=1543 -outfile "$Tools\DriveCleanup.zip"
    7z e "$Tools\cports.zip" -oM:\Toolbox
    7z e "$Tools\NetTraffView.zip" -oM:\Toolbox
    7z e "$Tools\BroDownView.zip" -oM:\Toolbox
    7z e "$Tools\BroHisView.zip" -oM:\Toolbox
    7z e "$Tools\ChromeCooks.zip" -oM:\Toolbox
    7z e "$Tools\Edgecooks.zip" -oM:\Toolbox
    7z e "$Tools\FoxCooks.zip" -oM:\Toolbox
    7z e "$Tools\OFView.zip" -oM:\Toolbox
    7z e "$Tools\AppNetCount.zip" -oM:\Toolbox
    7z e "$Tools\NetUseView.zip" -oM:\Toolbox
    7z e "$tools\UninView.zip" -oM:\Toolbox
    7z e "$Tools\InstAppView.zip" -oM:\Toolbox
    7z e "$Tools\InstPckView.zip" -oM:\Toolbox
    7z e "$Tools\ExeProList.zip" -oM:\Toolbox
    7z e "$Tools\Winlogonview.zip" -oM:\Toolbox
    7z e "$Tools\Dragon.zip" -oM:\Toolbox\Dragon
    7z e "$Tools\DriveCleanup.zip" -oM:\Toolbox
    Rename-Item -path "$tools\Dragon\CCE.exe" -NewName "Dragon.exe"

}
Function Primer
{
    PrivCheck
    FS_Verify
    #TestNet
    FinalPrep
    init_LogHeader
    Get_DiskSpace
    #InternalChecks
    SetPath
    init_7zip
    Hardware_Store
}
Primer