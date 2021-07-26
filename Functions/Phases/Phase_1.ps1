$ErrorActionPreference = "SilentlyContinue"
################## Phase 1: TempClean #######################
$CUtil = certutil.exe
$CUTArg1 = -URLcache
$CUTArg2 = *
$CUTArg3 = delete
$IEClean = rundll32.exe
$IECArg1 = "inetcpl.cpl,ClearMyTracksByProcess"
$IECArg2 = "4351"
$TempFolders = @("C:\Windows\Temp\*","C:\Windows\Prefetch\*","C:\Documents and Settings\*\Local Settings\temp\*","C:\Users\*\Appdata\Local\Temp\*")
$Caches = @("$env:SystemDrive\MSOCache","$env:SystemDrive\i386","$env:SystemDrive\RECYCLER","$env:SystemDrive\$Recycle.Bin",
"$env:ALLUSERSPROFILE\Microsoft\Windows\WER\ReportArchive","$env:ALLUSERSPROFILE\Microsoft\Windows\WER\ReportQueue",
"$env:ALLUSERSPROFILE\Microsoft\Windows Defender\Scans\History\Results\Quick", "$env:ALLUSERSPROFILE\Microsoft\Windows Defender\Scans\History\Results\Resource",
"$env:ALLUSERSPROFILE\Microsoft\Search\Data\Temp", "$env:windir\*.log","$env:windir\*.txt","$env:windir\*.bmp","$env:windir\*.tmp","$env:windir\Web\Wallpaper\Dell",
"$env:ProgramFiles\NVIDIA Corporation\Installer", "$env:ProgramFiles\NVIDIA Corporation\Installer2","${env:ProgramFiles(x86)}\NVIDIA Corporation\Installer",
"${env:ProgramFiles(x86)}\NVIDIA Corporation\Installer2", "$env:ProgramData\NVIDIA Corporation\Downloader", "$env:ProgramData\NVIDIA\Downloader",
"$env:windir\System32\dllcache\tourstrt.exe", "$env:windir\system32\dllcache\tourw.exe", "$env:windir\system32\tourstart.exe", "$env:windir\Help\Tours",
"$env:windir\Media") 
$Logfile = $global:LOGFILE
function init_Phase_1
{
    Write-Host "$head1 Phase 1: START at $global:Timestamp $head2" 2>&1 >> $Logfile
    # Clear SSL Cache
    & $CUtil $CUTArg1 $CUTArg2 $CUTArg3 2>&1 >> $Logfile
    # Clear IE History
    & $IEClean $IECArg1 $IECArg2 2>&1 >> $Logfile
    Remove-Item $TempFolders -Force -Recurse
    Remote-Item $env:TEMP\* -force -Recurse
    #Remove Temporary User files
    ."M:\Functions\Modules\TempCleanByUser.ps1"
    #Check for and Remove leftover drivers
    if (test-path "C:\Program Files\NVIDIA Corporation\Installer2")
    {
        Remove-Item "C:\Program Files\NVIDIA Corporation\Installer2" -Force -Recurse
    }
    if (test-path "C:\Program Files\NVIDIA Corporation\NetService")
    {
        Remove-Item "C:\Program Files\NVIDIA Corporation\NetService" -Force -Recurse
    }
    #Remove System Caches
    foreach ($cache in $Caches)
    {
        if (test-path $cache)
        {
            takeown /f $cache /a /r /d
            Remove-Item $cache -Force -Recurse
        }
    }
    #Clear MUI Cache
    reg delete "HKCU\SOFTWARE\Classes\Local Settings\Muicache" /f
    #Hotfix cleanup
    push-location $env:windir
    write-host "`n $header `n $halfhead Hotfix Folder Removal $halfhead `n $global:DevID $header `n $global:Timestamp `n" 2>&1 >> $Logfile
    Get-Childitem -Path C:\$*$ -hidden -recurse -force | out-file -filepath $LOGPATH\hfx_nuke_list.txt
    ForEach ($a in (Get-Content -Path "$LOGPATH\hfx_nuke_list.txt") ) 
    {
        write-host "Deleting $a ... `n" 2>&1 >> $Logfile
        write-host "Deleted folder $a `n"
        remove-item $a | Out-File -Path $LOGFILE -Append 
    }
    write-host "`n $Header `n $Halfhead Hotfix Cleanup Complete $Halfhead `n $global:DevID $header `n $global:Timestamp `n"
    Pop-Location
    #Ccleaner
    write-host "`n $halfhead Launching job CCleaner ... $halfhead `n $global:DevID $header `n $global:Timestamp `n" 2>&1 >> $Logfile
    & M:\Toolbox\CCleaner.exe /auto 2>&1 >> $Logfile | Out-Null
    write-host "`n $halfhead CCleaner Complete $halfhead `n $header `n " 2>&1 >> $Logfile
    #Find Duplicate Files
    write-host "`n $header `n $halfhead Launching job FindDupe ... $halfhead `n $global:DevID $header `n $global:Timestamp `n" 2>&1 >> $Logfile
    foreach ($User in $Users)
    {
        start-process -filepath $Toolbox\finddupe.exe -z -p -del "$env:USERPROFILE\Downloads\**" -wait 2>&1 >> $Logfile
    }
    write-Host "`n $Halfhead FindDupe Complete $halfhead `n $global:DevID $header `n $global:Timestamp `n" 2>&1 >> $Logfile
    #Cleanup USB Drives
    write-host "$Halfhead Launching job USB Device Cleanup at $global:Timestamp ... $Halfhead `n " 2>&1 >> $Logfile
    & M:\Toolbox\DriveCleanup.exe -n 2>&1 >> $Logfile
    Write-host "`n $header `n $halfhead USB Cleanup Complete $halfhead `n $global:DevID $header `n $global:Timestamp `n" 2>&1 >> $Logfile
    #Clear Windows Update Cache
    Write-Host "$Header `n $Halfhead Stopping Windows Update Service, clearing Update Cache ... $halfhead `n $global:DevID $header `n $global:Timestamp `n" 2>&1 >> $Logfile
    Stop-Service wuauserv -NoWait 2>&1 >> $Logfile
    if (Test-path $env:Windir\softwaredistribution\download)
    {
        Remove-Item $env:windir\softwaredistribution\download -Recurse 2>&1 >> $Logfile
    }
    #Dism cleanup
    write-Host "`n $Header `n $halfhead DISM cleanup START ... $halfhead `n $global:DevID $header `n $global:Timestamp `n" 2>&1 >> $Logfile
    dism /online /cleanup-image /analyzecomponentstore 2>&1 >> $Logfile
    dism /online /cleanup-image /startcomponentcleanup 2>&1 >> $Logfile
    dism /online /cleanup-image /startcomponentcleanup /resetbase 2>&1 >> $Logfile
    write-host "`n $halfhead Windows Update Cleanup Complete $halfhead `n $global:DevID $header `n $global:Timestamp `n " 2>&1 >> $Logfile
    #Reset Branch Cache
    write-host "`n $Header `n $halfhead Resetting Branch Cache ... $halfhead `n $global:DevID $header `n $global:Timestamp `n " 2>&1 >> $Logfile
    Get-BCStatus 2>&1 >> $Logfile
    Clear-BCCache -Confirm:$false 2>&1 >> $Logfile
    write-host "`n $Header `n $halfhead Branch Cache Reset Successfully! $halfhead `n $global:DevID $header `n $global:Timestamp `n " 2>&1 >> $Logfile
    #Run Windows Cleanup
    write-host "`n $header `n $halfhead Running Windows Disk Cleanup ... $halfhead `n $global:DevID $header `n $global:Timestamp `n " 2>&1 >> $Logfile
    ."M:\Functions\Modules\Autoclean.ps1" 2>&1 >> $Logfile
    write-host "`n $header `n $halfhead Disk Cleanup Complete! $halfhead `n $header `n $global:DevID $header `n $global:Timestamp `n " 2>&1 >> $Logfile
    Write-Host " `n $header `n $halfhead TempFileCleanup v$SCRIPT_VERSION, finished. Executed as $env:USERDNSDOMAIN\$env:USERNAME `n Executed at: $Timestamp `n $header `n" 2>&1 >> $Logfile
    Write-Host "$head1 Phase 1: COMPLETE at $timestamp $Head2" 2>&1 >> $Logfile
} 
init_Phase_1