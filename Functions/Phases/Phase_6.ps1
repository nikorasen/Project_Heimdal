################## Phase 6: Optimize ################## 
$Logfile = $global:LOGFILE
$ErrorActionPreference = "SilentlyContinue"
function init_Phase_6
{
    Write-Host "$head1 Initializing Phase 6: Optimize at $timestamp ... $head2" 2>&1 >> $Logfile
    # # # # Reset Page File Settings # # # #
    Write-Host "$head1 Resetting Pagefile settings ... $head2" 2>&1 >> $Logfile 
    $pagefile = Get-WmiObject Win32_ComputerSystem -EnableAllPrivileges
    $pagefile.AutomaticManagedProfiles = $true 2>&1 >> $Logfile
    Write-Host "$head1 Pagefile reset COMPLETE $head2" 2>&1 >> $Logfile
    # # # # Run Defrag # # # #
    Write-Host "$head1 Defragging and retrimming drives ... $head2" 2>&1 >> $Logfile
    $SysDriv = 0
    ForEach ($disk in (Get-PhysicalDisk | Select-object DeviceID, MediaType, Size))
    {
        if ($disk.MediaType -eq 'SSD' -and $disk.size -gt 100GB)
        {
            $SysDriv = $disk.deviceid 
            Optimize-Volume -ObjectId $SysDriv -Retrim
            break
        }
        if ($disk.MediaType -eq 'HDD' -and $disk.size -gt 100GB)
        {
            $SysDriv = $disk.deviceid
            Optimize-Volume -ObjectId $SysDriv -Defrag 
            break
        }
    }
    Write-Host "$head1 Disk Defrag & Retrim COMPLETE $head2" 2>&1 >> $Logfile
    # # # # Phase 6 Complete # # # #
    Write-Host "$head1 Phase 6: Optimize COMPLETED at $timestamp $head2" 2>&1 >> $Logfile
}
init_Phase_6