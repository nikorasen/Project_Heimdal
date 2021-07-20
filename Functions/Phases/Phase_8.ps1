# # # # Report Compilation # # # #
function init_Phase_8
{
    $Final = "$global:Logpath\Final_Report.txt"
    $rkill = get-content $Global:rKill_log 2>&1 >> $Final
    $kvrt = get-content $Global:Kvrt_log 2>&1 >> $Final
    $Sophos = get-content $Global:Sophos_log 2>&1 >> $Final
    $Emisoft = Get-content $Global:Emisoft_log 2>&1 >> $Final
    $Panda = Get-Content $Global:Panda_log 2>&1 >> $Final 
    $Clam = Get-Content $Global:Clam_log 2>&1 >> $Final
    $AWCL = Get-Content $Global:Adw_Cl_Log 2>&1 >> $Final
    $Full_Log = Get-Content $global:LOGFILE 2>&1 >> $Final
    $RAW = Get-Content $global:RAW_LOG 2>&1 >> $Final
    $Findings = Get-Childitem -path N:\EncArch -Include *.txt, *.log -Recurse
    $Found = Foreach ($Find in $Findings) {Get-Childitem -path $Find | Get-Content $Find | Select-String -Pattern "Found" | Out-File -Append $Final}
    Write-Host "Project Heimdal Report: `n Device: $global:DevID `n Timestamp: $global:End_Time `n" > $Final
    Write-Host "Antivirus Report `n Found:" 2>&1 >> $Final
    Write-Host "$Found `n " 2>&1 >> $Final
    Write-Host "rKill Log: `n" 2>&1 >> $Final
    $rkill
    Write-Host "KVRT Log: `n" 2>&1 >> $Final
    $kvrt
    Write-Host "Sophos Log: `n" 2>&1 >> $Final
    $Sophos
    Write-Host "Emisoft Log: `n" 2>&1 >> $Final
    $Emisoft
    Write-Host "Panda Log: `n" 2>&1 >> $Final
    $Panda
    Write-Host "ClamAV Log: `n" 2>&1 >> $Final
    $Clam
    Write-Host "Adware Cleaner Log: `n" 2>&1 >> $Final
    $AWCL
    #Write-Host "Manual AV Screenshots: `n " 2>&1 >> $Final

    Write-host "Phase-By-Phase Log:" 2>&1 >> $Final
    $Full_Log
    Write-Host "RAW Logs:"
    $RAW
}
init_Phase_8