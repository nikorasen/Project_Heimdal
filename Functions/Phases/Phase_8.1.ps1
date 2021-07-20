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
$DevID = hostname 
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
$Outpath = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$Outpath = $Outpath + "{$DevID}_Final_Report.docx"
$doc.SaveAs([ref]$outpath, [ref] [Microsoft.Office.Interop.Word.WdSaveFormat]::wdFormatPDF)
$doc.close([Microsoft.Office.Interop.Word.WdSaveOptions]::wdDoNotSaveChanges)
$word.Quit()