################## Phase 5: Patch ################## 
$Logfile = $global:LOGFILE
$ErrorActionPreference = "SilentlyContinue"
Function init_Phase_5
{
    Write-Host "$head1 Initializing Phase 5: Patch at $timestamp ... $head2" 2>&1 >> $Logfile
    # # # #  Update Windows Defender # # # #
    Write-host "$head1 Updating Windows Defender ... $head2" 2>&1 >> $Logfile 
    Start-Process "$env:ProgramFiles\Windows Defender\mpcmdrim.exe" -signatureupdate 2>&1 >> $Logfile
    Write-Host "$head1 Windows Defender update complete $head2" 2>&1 >> $Logfile
    Write-host "$head1 Windows Defender Update Complete. $head2" 2>&1 >> $Logfile
    # # # # Windows Updates # # # # 
    Install-module -Name PSWindowsUpdate -confirm:$false
    Import-Module -name PSWindowsUpdate 
    Get-WindowsUpdate -MicrosoftUpdate -ForceDownload -ForceInstall -AcceptAll -Confirm:$False 2>&1 >> $Logfile
    Download-WindowsUpdate -MicrosoftUpdate -ForceDownload -ForceInstall -AcceptAll -Confirm:$False 2>&1 >> $Logfile
    Install-WindowsUpdate -MicrosoftUpdate -ForceDownload -ForceInstall -AcceptAll -ignorereboot -Confirm:$False 2>&1 >> $Logfile
    Write-host "$head1 Windows Update Complete $head2" 2>&1 >> $Logfile
    # # # # DISM Update Cleanup # # # #
    Write-Host "$Head1 Start Job: DISM Cleanup ... $head2" 2>&1 >> $Logfile
    dism /online /cleanup-image /scanhealth /logpath:"$LOGPATH\dism_base_reset.log"
    dism /online /cleanup-image /restorehealth /logpath:"$LOGPATH\dism_base_reset.log"
    dism /online /cleanup-image /analyzecomponentstore /logpath:"$LOGPATH\dism_base_reset.log"
    dims /online /cleanup-image /startcomponentcleanup /resetbase /logpath:"$LOGPATH\dism_base_reset.log"
    Get-Content $LOGPATH\dism_base_reset.log 2>&1 >> $Logfile
    Write-Host "$Head1 Job DISM Cleanup COMPLETE $head2" 2>&1 >> $Logfile
    # # # # Phase 5 Complete # # # #
    Write-host "$head1 Phase 5:Patch COMPLETED at $Timestamp $head2" 2>&1 >> $Logfile
}
init_Phase_5