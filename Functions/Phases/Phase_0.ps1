################## Phase 0: Prep #######################
#Sets app variable locations, grabs timestamp, and grabs all the logs#
#import-module -name M:\Toolbox\Modules\Bunyun.psm1
$ErrorActionPreference = "SilentlyContinue"
$FWlog = "C:\Windows\system32\LogFiles\Firewall\pfirewall.log"
$Logfile = $global:LOGFILE
# With the variables set we can begin
function Get-RB 
{
    (New-Object -ComObject Shell.Application).Namespace(0x0a).Items() | Select-Object Name, Size, Path
}
function init_Phase_0
{
    write-host "$Header `n $Header `n $HalfHead Phase 0: Prep`n Begin at $global:Timestamp $halfhead `n $header `n $header `n" 2>&1 >> $Logfile
    Write-Host "$Header `n $Halfhead Grabbing Native Windows Logs $Halfhead `n $Header"
    #Call Bunyun to get the logs
    ."M:\Functions\Modules\Bunyun.ps1"
    Write-host "$Header `n $halfhead Port Scan with Cports.exe $Halfhead `n Device: $global:DevID `n Timestamp:$global:Timestamp `n" 2>&1 >> $Logfile
    #Copy Cports to root folder to avoid execution errors
    Copy-Item -Path M:\Toolbox\Cports.exe -Destination C:\EWT\HEIMDAL 
    & C:\EWT\HEIMDAL\Cports.exe /stext 'N:\EncArch\Archive\$global:DevID-Cports.txt' /startashidden
    Get-Content N:\EncArch\Archive\$global:DevID-Cports.txt 2>&1 >> $Logfile
    Write-Host "$Header `n $HaldHead 2-Minute Traffic Capture with NetworkTrafficView.exe $Halfhead `n Device: $DevID `n Timestamp: $Timestamp `n"  2>&1 >> $Logfile
    #Network Traffic Capture
    & M:\Toolbox\NetworkTrafficView.exe /stext N:\EncArch\Archive\$global:DevID-NetTraffCap.txt /CaptureTime 120 /startashidden
    Get-Content N:\EncArch\Archive\$global:DevID-NetTraffCap.txt 2>&1 >> $Logfile
    #Browser Downloads
    Write-Host "$Header `n $Halfhead Browser Downloads with BrowserDownloadsView.exe $HalfHead `n Device: $DevID `n Timestamp: $Timestamp `n "  2>&1 >> $Logfile
    & M:\Toolbox\BrowserDownloadsView.exe /stext N:\EncArch\Archive\$global:DevID-BrowserDownloads.txt /startashidden
    Get-Content N:\EncArch\Archive\$global:DevID-BrowserDownloads.txt 2>&1 >> $Logfile          
    #Browser History
    Write-Host "$Header `n $Halfhead Internet Explorer, Edge, Chrome, and Firefox Browsing History $HalfHead `n Device: $DevID `n Timestamp: $Timestamp `n "  2>&1 >> $Logfile
    & M:\Toolbox\BrowsingHistoryView.exe /stext N:\EncArch\Archive\$global:DevID-BrowserHistory.txt /savedirect /historysource 1 /LoadIE 1 /LoadFirefox 1 /LoadChrome 1 /LoadSafari 1 /startashidden  
    Get-Content N:\EncArch\Archive\$global:DevID-BrowserHistory.txt 2>&1 >> $Logfile
    #Browser Cookies
    Write-Host "$Header `n $HalfHead Internet Explorer, Edge, Chrome, and Firefox Cookies $Halfhead `n Device: $DevID `n Timestamp: $Timestamp `n "  2>&1 >> $Logfile
    & M:\Toolbox\EdgeCookiesView.exe /LoadFrom 1 /stext N:\EncArch\Archive\$global:DevID-EdgeCookies.txt /startashidden  
    Get-Content N:\EncArch\Archive\$global:DevID-EdgeCookies.txt 2>&1 >> $Logfile
    & M:\Toolbox\ChromeCookiesView.exe /stext N:\EncArch\Archive\$global:DevID-ChromeCookies.txt
    Get-Content N:\EncArch\Archive\$global:DevID-ChromeCookies.txt 2>&1 >> $Logfile
    & M:\Toolbox\mzcv.exe /stext N:\EncArch\Archive\$global:DevID-FirefoxCookies.txt
    Get-Content N:\EncArch\Archive\$global:DevID-FirefoxCookies.txt 2>&1 >> $Logfile
    # Browser Settings
    write-host "$Header `n $HalfHead Browser Settings Export $Halfhead `n Device: $DevID `n Timestamp: $Timestamp `n "  2>&1 >> $Logfile
    reg export "HKCU\Software\Microsoft\Internet Explorer" N:\EncArch\Reports\{$DevID}_IEsettings-user_{$Timestamp}_.txt
    reg export "HKLM\Software\Microsoft\Internet Explorer" N:\EncArch\Reports\{$DevID}_IEsettings-device_{$Timestamp}_.txt
    write-host "`n $header `n" 2>&1 >> $Logfile
    #Currently Opened Files
    Write-Host "$Header `n $HalfHead Currently Opened files $Halfhead `n Device: $DevID `n Timestamp: $Timestamp `n "  2>&1 >> $Logfile
    & M:\Toolbox\OpenedFilesView.exe /stext N:\EncArch\Archive\$global:DevID-OpenedFiles.txt /startashidden  
    Get-Content N:\EncArch\Archive\$global:DevID-OpenedFiles.txt 2>&1 >> $Logfile
    # User List
    Write-Host "$Header `n $Halfhead Enumerated User List Export $Halfhead `n Device: $DevID `n Timestamp: $Timestamp `n "  2>&1 >> $Logfile
    Get-LocalUser Select-Object * 2>&1 >> $Logfile
    Write-Host "`n $header `n" 2>&1 >> $Logfile
    # Outlook Accounts
    $OLA = New-Object -ComObject 'Outlook.application'
    $Accts = $OLA.session.Accounts
    Write-Host "$Header `n $Halfhead Enumerated Outlook Accounts $Halfhead `n Device: $DevID `n Timestamp: $Timestamp `n "  2>&1 >> $Logfile
    $Accts | Select-Object DisplayName, SmtpAddress 2>&1 >> $Logfile 
    Write-Host "`n $header `n" 2>&1 >> $Logfile
    Write-Host "$Header `n $Halfhead Current Network Configuration $Halfhead `n Device: $DevID `n Timestamp: $Timestamp `n "  2>&1 >> $Logfile
    ipconfig /all 2>&1 >> $Logfile
    Write-Host "`n $header `n" 2>&1 >> $Logfile
    # DNS Records
    Write-Host "$Header `n $Halfhead Enumerated DNS Records $Halfhead `n Device: $DevID `n Timestamp: $Timestamp `n "  2>&1 >> $Logfile
    ipconfig /displaydns 2>&1 >> $Logfile
    Write-Host "`n $header `n" 2>&1 >> $Logfile
    # Network Apps
    Write-Host "$Header `n $Halfhead Enumerated Network Enabled Applications $Halfhead `n Device: $DevID `n Timestamp: $Timestamp `n "  2>&1 >> $Logfile
    & M:\Toolbox\AppNetworkCounter.exe /CaptureTime 20000 /stext N:\EncArch\Archive\$global:DevID-NetAppCount.txt /startashidden  
    Get-Content N:\EncArch\Archive\$global:DevID-NetAppCount.txt 2>&1 >> $Logfile
    # Network Usage
    Write-Host "$Header `n $Halfhead Enumerated Network Usage Statistics $Halfhead `n Device: $DevID `n Timestamp: $Timestamp `n "  2>&1 >> $Logfile
    & M:\Toolbox\NetworkUsageView.exe /stext N:\EncArch\Archive\$global:DevID-NetUsage.txt /startashidden  
    Get-Content N:\EncArch\Archive\$global:DevID-NetUsage.txt 2>&1 >> $Logfile
    #Running Tasks
    Write-Host "$Header `n $Halfhead Running Tasks List $Halfhead `n Device: $DevID `n Timestamp: $Timestamp `n "  2>&1 >> $Logfile
    Tasklist 2>&1 >> $Logfile
    Write-Host "`n $header `n" 2>&1 >> $Logfile
    # Installed & Uninstalled Programs, Apps, and Packages
    Write-Host "$Header `n $Halfhead Enumerated Programs List $Halfhead `n Device: $DevID `n Timestamp: $Timestamp `n N:\EncArch\Reports\unin_app_b4.txt, Inst_App_b4.txt, Inst_Pk_b4.txt `n"  2>&1 >> $Logfile
    Write-Host "$head1 Uninstalled Apps: `n" 2>&1 >> N:\EncArch\Archive\unin_app_b4.txt 
    & M:\Toolbox\UninstallView.exe /runasadmin /showitemswithoutuninstallstr 1 /showitemswithoutdisplayname 1 /LoadFrom 2 /ShowItemsWithParent 1 /stext N:\EncArch\Archive\unin_app_b4.txt /startashidden  
    Get-Content N:\EncArch\Archive\unin_app_b4.txt 2>&1 >> N:\EncArch\Archive\$global:DevID-unin_app_b4.txt
    & M:\Toolbox\InstalledAppView.exe /stext N:\EncArch\Archive\Inst_App_b4.txt /startashidden  
    Write-Host "$head1 Installed Apps: `n" 2>&1 >> N:\EncArch\Archive\$global:DevID-Inst_App_b4.txt
    Get-Content N:\EncArch\Archive\Inst_App_b4.txt 2>&1 >> N:\EncArch\Archive\$global:DevID-Inst_App_b4.txt
    & M:\Toolbox\InstalledPackagesView.exe /stext N:\EncArch\Archive\inst_pkg_b4.txt /startashidden  
    Write-Host "$Head1 Installed Packages: `n" 2>&1 >> N:\EncArch\Archive\$global:DevID-Inst_pkg_b4.txt
    Get-Content N:\EncArch\Archive\inst_pkg_b4.txt 2>&1 >> N:\EncArch\Archive\$global:DevID-Inst_pkg_b4.txt
    # Get Executed programs list
    Write-Host "$Header `n $Halfhead Executed Programs List $Halfhead `n Device: $DevID `n Timestamp: $Timestamp `n "  2>&1 >> $Logfile
    & M:\Toolbox\ExecutedProgramsList.exe /stext N:\EncArch\Archive\Exe_List.txt /startashidden  
    Get-Content N:\EncArch\Archive\Exe_List.txt 2>&1 >> $Logfile
    #Startup Programs
    wmic startup get caption,command 2>&1 >> $Logfile
    #Login History
    & M:\Toolbox\WinLogOnView.exe /source 1 /stext N:\EncArch\Archive\$global:DevID-Logins.txt /startashidden  
    Get-Content N:\EncArch\Archive\$global:DevID-Logins.txt 2>&1 >> $Logfile
    #Services List
    Write-Host "$Header `n $Halfhead Currently Running Services $Halfhead `n Device: $DevID `n Timestamp: $Timestamp `n "  2>&1 >> $Logfile
    Get-Service  Where-Object {$_.Status -eq "Running"}  2>&1 >> $Logfile
    Write-Host "`n $Halfhead All services by status $halfhead `n Device: $DevID `n Timestamp: $Timestamp `n "  2>&1 >> $Logfile
    Get-Service  Sort-Object Status  2>&1 >> $Logfile
    #Firewall Logs
    Write-Host "$Header `n $Halfhead Grabbing Windows Firewall Logs $Halfhead `n Device: $DevID `n Timestamp: $Timestamp `n "  2>&1 >> $Logfile
    Get-Content $FWlog 2>&1 >> $Logfile
    #Recycle Bin
    Write-Host "$head1 Grabbing Recycle bin list... $head2"  2>&1 >> $Logfile
    Get-RB Out-File -Filepath $LOGPATH\RAW_Logs\Phase_0.log\RecBin-B4.txt
    Clear-RecycleBin -DriveLetter C -Force -Confirm:$false
    #RDP logs
    Write-Host "$Header `n $Halfhead RDP Records $Halfhead `n Device: $DevID `n Timestamp: $Timestamp `n "  2>&1 >> $Logfile
    Get-WinEvent -logname "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational"  2>&1 >> $Logfile
    Write-Host "$Halfhead Phase 0 End at $timestamp $Halfhead `n" 2>&1 >> $Logfile
} 
init_Phase_0