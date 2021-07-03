# # # # Report Compilation # # # #
function init_Phase_8
{
    $Final = "$global:Logpath\Final_Report.txt"
    Write-Host "Project Heimdal Report:
    Device: $global:DevID 
    Timestamp: $global:End_Time" > $Final
    $rkill = get-content $Global:rKill_log 2>&1 >> $Final
    $kvrt = get-content $Global:Kvrt_log 2>&1 >> $Final
    $Sophos = get-content $Global:Sophos_log 2>&1 >> $Final
    $Emisoft = Get-content $Global:Emisoft_log 2>&1 >> $Final
    $Panda = Get-Content $Global:Panda_log 2>&1 >> $Final
    $Clam = Get-Content $Global:Clam_log 2>&1 >> $Final
    $AWCL = Get-Content $Global:Adw_Cl_Log 2>&1 >> $Final
    $Full_Log = Get-Content $global:LOGFILE 2>&1 >> $Final
    $RAW = Get-Content $global:RAW_LOG
    $rkill
    $kvrt
    $Sophos
    $Emisoft
    $Panda
    $Clam
    $AWCL
    Write-host "Command-Line Antivirus Scan Results:" 2>&1 >> $Final
    $Full_Log
    Write-Host "RAW Logs:"
    $RAW
}
init_Phase_8