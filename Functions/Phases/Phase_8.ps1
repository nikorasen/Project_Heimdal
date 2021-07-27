# # # # Report Compilation # # # #
function init_Phase_8
{
    if (test-path HKLM:SOFTWARE\Classes\Word.Application)
    {
        $Arch01 = "$global:Logpath\Final_Report\$global:DevID-Final_Report.tar"
        $Arch02 = "$global:Logpath\Final_Report\$global:DevID-Final_Report.tar.gz"
        $word = New-object -ComObject "Word.Application"
        $doc = $word.documents.add()
        $selection=$word.Selection
        $Timestamp = Get-Date -Format o | ForEach-Object { $_ -replace ':', '.' } 
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
        $Found = Foreach ($Find in $Findings) {Get-Childitem -path $Find | Get-Content $Find | Select-String -Pattern "Found" | Out-File "N:\EncArch\Archive\Mal_Found.txt"}
        $Found
        $Malware = Get-Content "N:\EncArch\Archive\Mal_Found.txt"
        $Mal_Found = "$Malware `n " 
        $Final_Header = "HEIMDAL RUN REPORT `n Device: $DevID `n Timestamp: $Timestamp `n"
        $AV_Rep_Head = "Antivirus Report `n Malware Found:`n $Mal_Found `n"
        $rKill_head = "rKill Log: `n $rKill `n"
        $kvrt_head = "KVRT Log: `n $kvrt `n"
        $svrt_head = "Sophos Log: `n $sophos `n"
        $Emi_head = "Emisoft Log: `n $Emisoft `n"
        $Pan_head = "Panda Log: `n $Panda `n"
        $Clam_head = "ClamAV Log: `n $Clam `n"
        $Adw_head = "Adware Cleaner Log: `n $AWCL `n"
        $Full_head = "Phase-By-Phase Log: `n $Full_Log `n"
        $Raw_head = "RAW Logs: `n $RAW `n"
        $selection.TypeText(($Final_Header))
        $selection.TypeParagraph()
        $selection.TypeText(($AV_Rep_Head))
        $selection.TypeParagraph()
        $selection.TypeText(($Mal_Found))
        $selection.TypeParagraph()
        $selection.TypeText(($rKill_head))
        $selection.TypeParagraph()
        $selection.TypeText(($kvrt_head))
        $selection.TypeParagraph()
        $selection.TypeText(($svrt_head))
        $selection.TypeParagraph()
        $selection.TypeText(($Emi_head))
        $selection.TypeParagraph()
        $selection.TypeText(($Pan_head))
        $selection.TypeParagraph()
        $selection.TypeText(($Clam_head))
        $selection.TypeParagraph()
        $selection.TypeText(($Adw_head))
        $selection.TypeParagraph()
        $selection.TypeText(($Full_head))
        $selection.TypeParagraph()
        $selection.TypeText(($Raw_head))
        $selection.TypeParagraph()
        $Shapes = Get-Childitem -path "N:\EncArch\Archive\ManAV_ScrCaps" -include *.bmp, *.png, *.jpg -Recurse
        ForEach ($Shape in $Shapes)
        {
            $selection.InlineShapes.AddPicture("$Shape")
            $selection.TypeParagraph()
        }
        Add-Type -AssemblyName "Microsoft.Office.Interop.Word"
        $Outpath = "$global:Logpath\Final_Report\$global:DevID-Final_Report.pdf"
        $doc.SaveAs([ref]$outpath, [ref] [Microsoft.Office.Interop.Word.WdSaveFormat]::wdFormatPDF)
        $doc.close([Microsoft.Office.Interop.Word.WdSaveOptions]::wdDoNotSaveChanges)
        $word.Quit()
        7z a -ttar -mx=7 $Arch01 $Outpath
        7z h -scrcSHA256 $Arch01 2>&1 >> "N:\EncArch\Archive\Final_Report\Arch01.txt"
        Set-ItemProperty -Path "N:\EncArch\Archive\Final_Report\Arch01.txt" -name IsReadOnly -value $true
        7z a -tgzip -mx=7 -pEWTSoluti0ns $Arch02 $Arch01
        7z h -scrcSHA256 $Arch02 2>&1 >> "N:\EncArch\Archive\Final_Report\Arch02.txt"
        Set-ItemProperty -Path "N:\EncArch\Archive\Final_Report\Arch02.txt" -name IsReadOnly -value $True
    }else 
    {
        $Final = "$global:Logpath\Final_Report\$global:DevID-Final_Report.txt"
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
        $Arch01 = "$global:Logpath\Final_Report\$global:DevID-Final_Report.tar"
        $Arch02 = "$global:Logpath\Final_Report\$global:DevID-Final_Report.tar.gz"
        Write-Host "Project Heimdal Report: `n Device: $global:DevID `n Timestamp: $global:End_Time `n" > $Final
        Write-Host "Antivirus Report `n Found:" 2>&1 >> $Final
        $Found
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
        Write-Host "Manual AV Screenshots will be included within the encrypted Final_Report.tar.gzip archive." 2>&1 >> $Final
        Write-host "Phase-By-Phase Log:" 2>&1 >> $Final
        $Full_Log
        Write-Host "RAW Logs:" 2>&1 >> $Final
        $RAW 
        7z a -ttar -mx=7 $Arch01 "$global:Caps\*.bmp"
        7z u $Arch01 $Final
        7z h -scrcSHA256 $Arch01 2>&1 >> "N:\EncArch\Archive\Final_Report\Arch01.txt"
        Set-ItemProperty -Path "N:\EncArch\Archive\Final_Report\Arch01.txt" -name IsReadOnly -value $true
        7z a -tgzip -mx=7 -pEWTSoluti0ns $Arch02 $Arch01
        7z h -scrcSHA256 $Arch02 2>&1 >> "N:\EncArch\Archive\Final_Report\Arch02.txt"
        Set-ItemProperty -Path "N:\EncArch\Archive\Final_Report\Arch02.txt" -name IsReadOnly -value $True
    }
}
init_Phase_8