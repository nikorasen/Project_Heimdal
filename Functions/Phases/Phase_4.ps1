################## Phase 4: Repair ##################
$Logfile = $global:LOGFILE
$ErrorActionPreference = "SilentlyContinue"
#
Function init_Phase_4
{
    Write-Host "$head1 Initializing Phase 4: Repair at $Timestamp $head2" 2>&1 >> $Logfile
    # # # # MSI Installer Cleanup # # # # 
    Write-Host "$head1 Culling abandoned MSI cache files ... $head2" 2>&1 >> $Logfile
    Start-Process $Toolbox\MSIclean\msizap.exe G! 2>&1 >> $Logfile
    Write-Host "$head1 MSI Cleanup COMPLETE $head2" 2>&1 >> $Logfile
    # # # # DISM Cleanup # # # #
    Write-Host "$head1 Running Corruption Fixes with DISM ... $head2"
    dism /online /cleanup-image /checkhealth 2>&1 >> $Logfile
    dism /online /cleanup-image /scanhealth 2>&1 >> $Logfile
    dism /online /cleanup-image /restorehealth 2>&1 >> $Logfile
    dism /online /cleanup-image /analyzecomponentstore 2>&1 >> $Logfile
    dism /online /cleanup-image /startcomponentcleanup 2>&1 >> $Logfile
    dism /online /clenaup-image /startcomponentcleanup /resetbase 2>&1 >> $Logfile
    if (test-path $env:RAW_LOGS\dism_check.log)
    {
        Write-Host "$head1 DISM Check Logs: $head2" 2>&1 >> $Logfile
        Get-Content $env:RAW_LOGS\dism_check.log 2>&1 >> $Logfile
    }
    if (test-path $env:RAW_LOGS\dism_repair.log)
    {
        Write-Host "$head1 DISM Repair Logs: $head2" 2>&1 >> $Logfile
        Get-Content $env:RAW_LOGS\dism_repair.log 2>&1 >> $Logfile
    }
    Write-Host "$head1 DISM fix complete $head2" 2>&1 >> $Logfile
    # # # # SFC # # # #
    Write-Host " $head1 Starting SFC scan ... $head2" 2>&1 >> $Logfile
    sfc /scannow 2>&1 >> $Logfile
    if (test-path $env:SystemRoot\logs\cbs\cbs.log)
    {
        Get-Content $env:SystemRoot\logs\cbs\cbs.log 2>&1 >> $Logfile
    }
    Write-Host " $head1 SFC Scan COMPLETE $head2" 2>&1 >> $Logfile
    # # # # Minor Net Error Repairs # # # #
    Write-Host "$head1 Resetting Network adapters ... $head2" 2>&1 >> $Logfile
    ipconfig /flushdns 2>&1 >> $Logfile
    netsh interface ip delete arpcache 2>&1 >> $Logfile
    Netsh winsock reset catalog 2>&1 >> $Logfile
    # # # # Phase 4: Repair Complete # # # #
    write-host "$head1 Phase 4: Repair COMPLETE at $Timestamp $head2" 2>&1 >> $Logfile
}
init_Phase_4