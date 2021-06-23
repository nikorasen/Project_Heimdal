################## Phase 3: Disinfect ################## 
$ErrorActionPreference = "SilentlyContinue"
$Global:rKill_log = "$Global:RAW_LOGPATH\{$Global:DevID}-rKill_Log.txt"
$Global:Kvrt_log = "$Global:RAW_LOGPATH\{$Global:DevID}-KVRT_Log.txt"
$Global:Sophos_log = "$Global:RAW_LOGPATH\{$Global:DevID}-Sophos_log.txt"
$Global:Emisoft_log = "$Global:RAW_LOGPATH\{$Global:DevID}-Emisoft_log.txt"
$Global:Panda_log = "$Global:RAW_LOGPATH\{$Global:DevID}-Panda_log.txt"
$Global:Clam_log = "$Global:RAW_LOGPATH\{$Global:DevID}-Clam_log.txt"
$Global:Comodo_log = "$Global:RAW_LOGPATH\{$Global:DevID}-Comodo_log.txt"
$Global:Mbam_log = "$Global:RAW_LOGPATH\{$Global:DevID}-Mbam_log"
$Global:Adw_Cl_Log = "$Global:RAW_LOGPATH\{$Global:DevOD}-ADWCL_log.txt"
$Logfile = $global:LOGFILE
function init_Phase_3
{
    write-host "$head1 Initializing Phase 3: Disinfection on $global:DevID at $global:Timestamp ... $head2" 2>&1 >> $Logfile
    write-Host "$head1 Starting job: rKill on $global:DevID at $Global:Timestamp ... $head2" 2>&1 >> $Logfile
    #rKill
    Write-Host "$head1 Job: rKill - Log $Timestamp $head2" 2>&1 >> $Global:rKill_log
    wget https://www.bleepingcomputer.com/download/rkill/dl/10/ -outfile M:\Toolbox\rkill\Vaccine.exe
    & M:\Toolbox\rkill\Vaccine.exe 2>&1 >> $Global:rKill_log | Out-Null
    $Logcheck1 = Test-Path $env:USERPROFILE\Desktop\rkill.txt
    if ($Logcheck1 -eq 'True')
    {
        Get-Content $env:USERPROFILE\Desktop\rkill.txt 2>&1 >> $Global:rKill_log
        Remove-Item $env:USERPROFILE\Desktop\rkill.txt -force -Recurse
    }
    Get-Content $Global:rKill_log 2>&1 >> $Logfile
    Write-host "$head1 Job: rKill COMPLETE on $global:DevID at $global:Timestamp $head2" 2>&1 >> $Logfile
    # KVRT
    Write-Host "$head1 Starting Job: KVRT on $global:DevID at $global:Timestamp $head2" 2>&1 >> $Logfile
    Write-Host "$head1 Job: KVRT - LOG `n $global:Timestamp `n $head2" 2>&1 >> $Global:Kvrt_log
    $TP01 = Test-Path C:\EWT
    If (-not $TP01)
    {
        mkdir C:\EWT
    }
    wget https://devbuilds.s.kaspersky-labs.com/devbuilds/KVRT/latest/full/KVRT.exe -outfile M:\Toolbox\kvrt\Dimitri.exe
    Copy-Item -path M:\Toolbox\kvrt\Dimitri.exe -destination C:\EWT\Dimitri.exe
    & C:\EWT\Dimitri.exe -accepteula -silent -adinsilent -processlevel 3 -dontencrypt -allvolumes -d "N:\EncArch\Archive\RAW_Logs\KVRT" | out-null
    Get-Content N:\Archive\RAW_Logs\KVRT\kvrt_scan.log\Reports\details*.klr N:\EncArch\Archive\RAW_Logs\KVRT\kvrt_log.txt
    Get-Content N:\Archive\RAW_Logs\KVRT\kvrt_scan.log\Reports\report*.klr N:\EncArch\Archive\RAW_Logs\KVRT\kvrt_log.txt
    Remove-Item C:\EWT\kvrt.exe -Recurse -force 
    Get-Content $Global:Kvrt_log 2>&1 >> $Logfile
    Write-Host "$head1 Job KVRT: COMPLETED on $global:DevID at $global:Timestamp $head2" 2>&1 >> $Logfile
    #Sophos
    Write-Host "$head1 Starting Job: SOPHOS at $Timestamp ... $head2" 2>&1 >> $Logfile
    Write-host "$head1 Job: Sophos - Log" 2>&1 >> $Global:Sophos_log
    wget https://secure2.sophos.com/en-us/products/free-tools/virus-removal-tool/free-download.aspx -outfile M:\Toolbox\SVRT\svrtcli.exe
    & M:\Toolbox\SVRT\Seraphim.exe-yes -debug -uninstall 2>&1 >> $Global:Sophos_log | Out-Null
    $LogCheck2 = Test-Path "$env:ProgramData\Sophos\Sophos Virus Removal Tool\Logs\SophosVirusRemovalTool.log"
    if ($LogCheck2 -eq 'True')
    {
        Get-Content "$env:ProgramData\Sophos\Sophos Virus Removal Tool\Logs\SophosVirusRemovalTool.log" 2>&1 >> $Global:Sophos_log
        Remove-Item $env:ProgramData\Sophos -Force -Recurse
    }
    Get-Content $Global:Sophos_log 2>&1 >> $Logfile
    write-Host "$head1 Job: Sophos COMPLETED at $Timestamp $head2" 2>&1 >> $Logfile
    #Emisoft
    Write-host "$head1 Starting Job: EMISOFT EMERGENCY KIT at $global:Timetamp ... $head2" 2>&1 >> $Logfile
    Write-Host "$head1 Job: Emisoft Emergency Kit - Log $global:Timestamp" 2>&1 >> $Global:Emisoft_log
    & M:\Toolbox\EEK\a2cmd.exe /f="c:\" /update 2>&1 >> $Global:Emisoft_log | Out-Null
    & M:\Toolbox\EEK\a2cmd.exe /f="c:\" /malware /rk /traces /pup /memory /archive /ntfs /ac /quarantine=$global:LockUp /log=$Global:Emisoft_log 2>&1 >> $Global:Emisoft_log | Out-Null 
    & M:\Toolbox\EEK\a2cmd.exe /quarantinelist 2>&1 >> $Global:Emisoft_log
    Get-Content $Global:Emisoft_log 2>&1 >> $Logfile
    Write-Host "$head1 Job Emisoft Emergency Kit: COMPLETED at $Timestamp $head2" 2>&1 >> $Logfile
    #ClamAV
    Write-host "$head1 Starting Job: CLAMAV at $Timestamp ... $head2" 2>&1 >> $Logfile
    Write-Host "$head1 Job: Clam AV - Log $Timestamp $head2" 2>&1 >> $Global:Clam_log
    & M:\Toolbox\ClamAV\freshclam.exe 2>&1 >> $Global:Clam_log | Out-Null
    & M:\Toolbox\ClamAV\Sopngebob.exe --log=$Global:Clam_log --move=$global:BRIG --heuristic-alerts=yes --alert-encrypted=yes --recursive C:\ 2>&1 >> $Global:Clam_log | Out-Null
    Get-Content $Global:Clam_log 2>&1 >> $Logfile
    Write-Host "$head1 Job ClamAV: COMPLETED at $Timestamp $head2" 2>&1 >> $Logfile
    Write-Host "$head1 Starting Job: COMODO CLEANER at $Timestamp $head2" 2>&1 >> $Logfile
    Write-Host "$head1 Job: COMODO CLEANER - Log $Timestamp $head2" 2>&1 >> $Global:Comodo_log
    & M:\Toolbox\Komodo\Dragon.exe -s "m;c;f;r" -o "ARCHIVE;CAMAS;Heur=3;LOGLEVEL=2" -shift -d "c" -w "Dragon" -noreboot 2>&1 >> $Global:Comodo_log | Out-Null
    Write-Host "$head1 Job: COMODO CLEANER: COMPLETED at $Timestamp $head2 " 2>&1 >> $Logfile
    #ADWCleaner
    Write-Host "$head1 Starting Job: ADWCLEANER at $Timestamp $head2" 2>&1 >> $Logfile
    Write-Host "$head1 Job: ADWCLEANER - Log " 2>&1 >> $Global:Adw_Cl_Log
    M:\Toolbox\ADWcleaner\Baptism.exe /path /scan /preinstalled 2>&1 >> $Global:Adw_Cl_Log | Out-Null
    M:\Toolbox\ADWcleaner\Baptism.exe /clean /preinstalled /noreboot 2>&1 >> $Global:Adw_Cl_Log | Out-Null
    Get-Content $Global:Adw_Cl_Log 2>&1 >> $Logfile
    Write-Host "$head1 Job: ADWCLEANER: COMPLETED at $Timestamp $head2" 2>&1 >> $Logfile

    # When I figure out how to download, install, & scan with MB via CLI then this section will be uncommented - NC 06/16/21
    #Write-Host "$head1 Starting Job: MalwareBytes at $global:Timestamp" 2>&1 >> $Logfile
    #wget https://www.malwarebytes.com/mwb-download/thankyou/ -outfile M:\Toolbox\Mbam\MBSetup.exe
    #& M:\Toolbox\Mbam\MBSetup.exe /silent /nocancel /noicons /suppressmsgboxes /verysilent /norestart /dir=M:\Toolbox\Mbam /log=$Global:Mbam_log 2>&1 >> $Logfile
    #& "C:\Program Files\Malwarebytes\Anti-Malware\mbam.exe" /set terminateie on detectpup 1 detectpum 1 defaultscan 1 

    #Get-Content $Global:Mbam_log 2>&1 >> $Logfile
    #Write-Host "$head1 Job Malwarebytes COMPLETED at $Global:Timestamp" 2>&1 >> $Logfile
    Write-host "$head1 Phase 3 COMPLETED on $global:DevID at $global:Timestamp `n" 2>&1 >> $Logfile
}
init_Phase_3