# # # # Cleans user temporary files and folders # # # #
# # # # Enumerates the USer list, then iterates through the list and checks for the presense of temporary files # # # #
# # # # For each temporary file found, this script removes it # # # # 
$ErrorActionPreference = "SilentlyContinue"
foreach ($User in $users)
{
    $folders = @("$($user.fullname)\AppData\Local\temp",
    "$($user.fullname)\Documents\*.tmp",
    "$($user.fullname)\My Documents\*.tmp",
    "$($user.fullname)\*.blf",
    "$($user.fullname)\*.regtrans-ms",
    "$($user.fullname)\AppData\LocalLow\Sun\Java\*",
    "$($user.fullname)\AppData\Local\Google\Chrome\User Data\Default\Cache\*",
    "$($user.fullname)\Appdata\Local\Google\Chrome\User Data\Default\JumpListIconsOld\*",
    "$($user.fullname)\AppData\Local\Google\Chrome\User Data\Default\JumpListIcons\*",
    "$($user.fullname)\Appdata\Local\Google\Chrome\User Data\Default\Local Storage\http*.*",
    "$($user.fullname)\Appdata\Local\Google\Chrome\User Data\Default\Media Cache\*",
    "$($user.fullname)\Appdata\Local\Microsoft\Internet Explorer\Recovery\*",
    "$($user.fullname)\Appdata\Local\Microsoft\Terminal Server Client\Cache\",
    "$($user.fullname)\AppData\Local\Microsoft\Windows\Caches\*",
    "$($user.fullname)\Appdata\Local\Microsoft\Windows\Explorer\*",
    "$($user.fullname)\AppData\Local\Microsoft\Windows\History\low\*",
    "$($user.fullname)\AppData\Local\Microsoft\Windows\INetCache\*",
    "$($user.fullname)\AppData\Local\Microsoft\Windows\Temporary Internet Files\*",
    "$($user.fullname)\AppData\Local\Microsoft\Windows\WER\ReportArchive\*",
    "$($user.fullname)\AppData\Local\Microsoft\Windows\WER\ReportQueue\*",
    "$($user.fullname)\AppData\Local\Microsoft\Windows\WebCache\*",
    "$($user.fullname)\AppData\Roaming\Adobe\Flash Player\*",
    "$($user.fullname)\AppData\Roaming\Macromedia\Flash Player\*",
    "$($user.fullname)\AppData\Roaming\Microsoft\Windows\Recent\*",
    "$($user.fullname)\Application Data\Adobe Flash Player\*",
    "$($user.fullname)\Application Data\Macromedia\Flash Player\*",
    "$($user.fullname)\Application Data\Microsoft\Dr Watson\*",
    "$($user.fullname)\Application Data\Microsoft\Windows\WER\ReportArchive\*",
    "$($user.fullname)\Application Data\Microsoft\Windows\WER\ReportQueue\*",
    "$($user.fullname)\Application Data\Sun\Java\*",
    "$($user.fullname)\Local Settings\Application Data\ApplicationHistory\*",
    "$($user.fullname)\Local Settings\Application Data\Google\Chrome\User Data\Default\Cache\*",
    "$($user.fullname)\Local Settings\Application Data\Google\Chrome\User Data\Default\JumpListIconsOld\*",
    "$($user.fullname)\Local Settings\Application Data\Google\Chrome\User Data\Default\JumpListIcons\*",
    "$($user.fullname)\Local Settings\Application Data\Google\Chrome\User Data\Default\Local Storage\http*.*",
    "$($user.fullname)\Local Settings\Application Data\Google\Chrome\User Data\Default\Media Cache\*",
    "$($user.fullname)\Local Settings\Temp\*",
    "$($user.fullname)\Local Settings\Temporary Internet Files\*",
    "$($user.fullname)\Recent\*")
    foreach ($Folder in $Folders)
    {
        If (Test-Path $Folder) 
        {
            Get-ChildItem -path $folder -Include * | remove-item -force -Recurse
        }
    } 
}