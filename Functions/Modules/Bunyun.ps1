#The Logger
#Gets all the logs
$DevID = hostname 
$Date = Get-Date
$Timestamp = Get-Date -Format o | ForEach-Object { $_ -replace ':', '.' } 
$Start = $Date.adddays(-7)
$Header = "==============================================================================================="
$HalfHead = "================================="
$NatLogs = "N:\EncArch\Archive\RAW_Logs\$DevID-Native_Windows_Logs.txt"
$ErrorActionPreference = "SilentlyContinue"
function Bunyun
{
    #Get Native Windows Logs First
    $SysEvLog = get-eventlog -ComputerName $DevID -log System -After $Start -EntryType Error, Warning
    $AppEvLog = get-eventlog -ComputerName $DevID -Log Application -After $Start -EntryType Error, Warning
    $SecEvLog = get-eventlog -ComputerName $DevID -Log Security -After $Start -EntryType Error, Warning
    Set-Content -Path $NatLogs -Value "$Header `n $HalfHead NATIVE WINDOWS LOGS $HalfHead `n Device: $DevID `n Date: $Date `n Time: $Timestamp `n $Header `n"
    $SysEvLog 2>&1 >> $NatLogs
    $AppEvLog 2>&1 >> $NatLogs
    $SecEvLog 2>&1 >> $NatLogs
}
Bunyun