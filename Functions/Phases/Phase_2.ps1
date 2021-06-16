################## Phase 2: Debloat #######################
# # # # Sets Power settings to EWT Standard # # # #
$Logfile = $global:LOGFILE
$ErrorActionPreference = "SilentlyContinue"
Function PwrSet
    {
    #changes the power settings to absolute max performance
    Powercfg /change hibernate-timeout-ac 0
    Powercfg /change disk-timeout-ac 0
    Powercfg /change standby-timeout-ac 0
    }
# # # # Debloats Windows 10 # # # #
Function Debloat
    {
    #Removes Bloatware Listed, to add follow format of the listed programs
    $AppXApps = @(

            #Unnecessary Win10 AppX Apps
            "*Microsoft.BingNews*"
            "*Microsoft.Getstarted*"
            #"*Microsoft.NetworkSpeedTest*"
            "*Microsoft.Xbox.TCUI*"
            "*Microsoft.XboxApp*"
            "*Microsoft.XboxGameOverlay*"
            "*Microsoft.XboxIdentityProvider*"
            "*Microsoft.XboxSpeechToTextOverlay*"
            "*Microsoft.ZuneMusic*"
            "*Microsoft.ZuneVideo*"
            "*Duoline-LearnLanguagesforFree*"
            "*PandoraMediaInc*"
            "*CandyCrush*"
            "*Wunderlist*"
            "*Flipboard*"
            "*Twitter*"
            "*Facebook*"
            "*Google Drive*"
        
            #Optional: Typically not removed but you can if you need to for some reason
            "*Microsoft.Advertising.Xaml_10.1712.5.0_x64__8wekyb3d8bbwe*"
            "*Microsoft.Advertising.Xaml_10.1712.5.0_x86__8wekyb3d8bbwe*"
            "*Microsoft.BingWeather*"
            "*Microsoft.MSPaint*"
            "*Microsoft.MicrosoftStickyNotes*"
            "*Microsoft.Windows.Photos*"
            "*Microsoft.WindowsCalculator*"
            #"*Microsoft.WindowsStore*"
        )
            foreach ($App in $AppXApps) {
            Write-Verbose -Message ('Removing Package {0}' -f $App) 2>&1 >> $Logfile
            Get-AppxPackage -Name $App | Remove-AppxPackage -ErrorAction SilentlyContinue 2>&1 >> $Logfile
            Get-AppxPackage -Name $App -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue 2>&1 >> $Logfile
            Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $App | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue 2>&1 >> $Logfile
        }
        
        #Removes AppxPackages not in Whitelist
        [regex]$WhitelistedApps = 'Microsoft.Paint3D|Microsoft.WindowsCalculator|Microsoft.WindowsStore|Microsoft.Windows.Photos|CanonicalGroupLimited.UbuntuonWindows|Microsoft.MicrosoftStickyNotes|Microsoft.MSPaint*'
        Get-AppxPackage -AllUsers | Where-Object {$_.Name -NotMatch $WhitelistedApps} | Remove-AppxPackage 2>&1 >> $Logfile
        Get-AppxPackage | Where-Object {$_.Name -NotMatch $WhitelistedApps} | Remove-AppxPackage 2>&1 >> $Logfile
        Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -NotMatch $WhitelistedApps} | Remove-AppxProvisionedPackage -Online 2>&1 >> $Logfile

    }
# # # # MURDER CORTANA # # # #
Function KillCortana
    {
    Write-Host "Disabling Cortana"
        $Cortana1 = "HKCU:\SOFTWARE\Microsoft\Personalization\Settings"
        $Cortana2 = "HKCU:\SOFTWARE\Microsoft\InputPersonalization"
        $Cortana3 = "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore"
	    If (!(Test-Path $Cortana1)) {
		    New-Item $Cortana1
	    }
	    Set-ItemProperty $Cortana1 AcceptedPrivacyPolicy -Value 0 
	    If (!(Test-Path $Cortana2)) {
		    New-Item $Cortana2
	    }
	    Set-ItemProperty $Cortana2 RestrictImplicitTextCollection -Value 1 
	    Set-ItemProperty $Cortana2 RestrictImplicitInkCollection -Value 1 
	    If (!(Test-Path $Cortana3)) {
		    New-Item $Cortana3
	    }
	    Set-ItemProperty $Cortana3 HarvestContacts -Value 0
    Write-Host "Cortana has been EXTERMINATED!!!" 2>&1 >> $Logfile
    }
# # # # Removes Bloatware Registry Keys # # # #
function RegDeblo
    {
    $Keys = @(
            
            #Remove Background Tasks
            "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\46928bounde.EclipseManager_2.2.4.51_neutral__a5h4egax66k6y"
            "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
            "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.MicrosoftOfficeHub_17.7909.7600.0_x64__8wekyb3d8bbwe"
            "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
            "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
            "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
            
            #Windows File
            "HKCR:\Extensions\ContractId\Windows.File\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
            
            #Registry keys to delete if they aren't uninstalled by RemoveAppXPackage/RemoveAppXProvisionedPackage
            "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\46928bounde.EclipseManager_2.2.4.51_neutral__a5h4egax66k6y"
            "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
            "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
            "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
            "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
            
            #Scheduled Tasks to delete
            "HKCR:\Extensions\ContractId\Windows.PreInstalledConfigTask\PackageId\Microsoft.MicrosoftOfficeHub_17.7909.7600.0_x64__8wekyb3d8bbwe"
            
            #Windows Protocol Keys
            "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
            "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
            "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
            "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
               
            #Windows Share Target
            "HKCR:\Extensions\ContractId\Windows.ShareTarget\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
        )
        
        #This writes the output of each key it is removing and also removes the keys listed above.
        ForEach ($Key in $Keys) {
            Write-Output "Removing $Key from registry" 2>&1 >> $Logfile
            Remove-Item $Key -Recurse
        }
    }
# # # # Remove Teams # # # # 
Function TricTeams
    {
    $TeamsPath = [System.IO.Path]::Combine($env:LOCALAPPDATA, 'Microsoft', 'Teams')
    $TeamsUpdateExePath = [System.IO.Path]::Combine($env:LOCALAPPDATA, 'Microsoft', 'Teams', 'Update.exe')

    try
     {
        if (Test-Path -Path $TeamsUpdateExePath)
         {
            Write-Host "... Uninstalling Teams process ..." 2>&1 >> $Logfile

            # Uninstall app
            $proc = Start-Process -FilePath $TeamsUpdateExePath -ArgumentList "-uninstall -s" -PassThru
            $proc.WaitForExit()
        }
        if (Test-Path -Path $TeamsPath)
         {
            Write-Host "... Deleting Teams directory ..." 2>&1 >> $Logfile
            Remove-Item -Path $TeamsPath -Recurse
                    
         }
        }
        catch
        {
            Write-Error -ErrorRecord $_
            exit /b 1
        }
    }
# # # # Remove OneDrive # # # #
Function NoOneDrive
    {
    Write-Output "Uninstalling OneDrive. Please wait..." 2>&1 >> $Logfile
    
        New-PSDrive  HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT
        $onedrive = "$env:SYSTEMROOT\SysWOW64\OneDriveSetup.exe"
        $ExplorerReg1 = "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}"
        $ExplorerReg2 = "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}"
	    Stop-Process -Name "OneDrive*"
	    Start-Sleep 2
	    If (!(Test-Path $onedrive)) {
		    $onedrive = "$env:SYSTEMROOT\System32\OneDriveSetup.exe"
	    }
	    Start-Process $onedrive "/uninstall" -NoNewWindow -Wait
	    Start-Sleep 2
        Write-Output "Stopping explorer"
        Start-Sleep 1
	    .\taskkill.exe /F /IM explorer.exe
	    Start-Sleep 3
        Write-Output "Removing leftover files"
	    Remove-Item "$env:USERPROFILE\OneDrive" -Force -Recurse
	    Remove-Item "$env:LOCALAPPDATA\Microsoft\OneDrive" -Force -Recurse
	    Remove-Item "$env:PROGRAMDATA\Microsoft OneDrive" -Force -Recurse
	    If (Test-Path "$env:SYSTEMDRIVE\OneDriveTemp") {
		    Remove-Item "$env:SYSTEMDRIVE\OneDriveTemp" -Force -Recurse
	    }
        Write-Output "Removing OneDrive from windows explorer" 2>&1 >> $Logfile
        If (!(Test-Path $ExplorerReg1)) {
            New-Item $ExplorerReg1
        }
        Set-ItemProperty $ExplorerReg1 System.IsPinnedToNameSpaceTree -Value 0 
        If (!(Test-Path $ExplorerReg2)) {
            New-Item $ExplorerReg2
        }
        Set-ItemProperty $ExplorerReg2 System.IsPinnedToNameSpaceTree -Value 0
        Write-Output "Restarting Explorer that was shut down before." 
        Start-Process explorer.exe -NoNewWindow
    }
# # # # Stop Edge from Taking over # # # #
Function Undertaker
    {
#is called Undertaker because it stops Edge from taking over. Get it? If you don't, you suck.
        Write-Output "Stopping Edge from taking over as the default .PDF viewer" 2>&1 >> $Logfile
        $NoPDF = "HKCR:\.pdf"
        $NoProgids = "HKCR:\.pdf\OpenWithProgids"
        $NoWithList = "HKCR:\.pdf\OpenWithList" 
        If (!(Get-ItemProperty $NoPDF  NoOpenWith)) {
            New-ItemProperty $NoPDF NoOpenWith 
        }        
        If (!(Get-ItemProperty $NoPDF  NoStaticDefaultVerb)) {
            New-ItemProperty $NoPDF  NoStaticDefaultVerb 
        }        
        If (!(Get-ItemProperty $NoProgids  NoOpenWith)) {
            New-ItemProperty $NoProgids  NoOpenWith 
        }        
        If (!(Get-ItemProperty $NoProgids  NoStaticDefaultVerb)) {
            New-ItemProperty $NoProgids  NoStaticDefaultVerb 
        }        
        If (!(Get-ItemProperty $NoWithList  NoOpenWith)) {
            New-ItemProperty $NoWithList  NoOpenWith
        }        
        If (!(Get-ItemProperty $NoWithList  NoStaticDefaultVerb)) {
            New-ItemProperty $NoWithList  NoStaticDefaultVerb 
        }
            
        #Appends an underscore '_' to the Registry key for Edge
        $Edge = "HKCR:\AppXd4nrz8ff68srnhf9t5a8sbjyar1cr723_"
        If (Test-Path $Edge) {
            Set-Item $Edge AppXd4nrz8ff68srnhf9t5a8sbjyar1cr723_ 
        }
    }
# # # # Removes Windows Tracking # # # #
Function LokPriv
    {
    #Stops Telemetry and Protects Privacy
    #Disables Windows Feedback Experience
        Write-Output "Disabling Windows Feedback Experience program ..." 2>&1 >> $Logfile
        $Advertising = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo"
        If (Test-Path $Advertising) {
            Set-ItemProperty $Advertising Enabled -Value 0 
        }
            
        #Stops Cortana from being used as part of your Windows Search Function
        Write-Output "Stopping Cortana from being used as part of your Windows Search Function ..." 2>&1 >> $Logfile
        $Search = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
        If (Test-Path $Search) {
            Set-ItemProperty $Search AllowCortana -Value 0 
        }

        #Disables Web Search in Start Menu
        Write-Output "Disabling Bing Search in Start Menu ..." 2>&1 >> $Logfile
        $WebSearch = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
        Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" BingSearchEnabled -Value 0 
	    If (!(Test-Path $WebSearch)) {
            New-Item $WebSearch
	    }
	    Set-ItemProperty $WebSearch DisableWebSearch -Value 1 
            
        #Stops the Windows Feedback Experience from sending anonymous data
        Write-Output "Stopping the Windows Feedback Experience program ..." 2>&1 >> $Logfile
        $Period = "HKCU:\Software\Microsoft\Siuf\Rules"
        If (!(Test-Path $Period)) { 
            New-Item $Period
        }
        Set-ItemProperty $Period PeriodInNanoSeconds -Value 0 

        #Prevents bloatware applications from returning and removes Start Menu suggestions               
        Write-Output "Adding Registry key to prevent bloatware apps from returning ..." 2>&1 >> $Logfile
        $registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
        $registryOEM = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
        If (!(Test-Path $registryPath)) { 
            New-Item $registryPath
        }
        Set-ItemProperty $registryPath DisableWindowsConsumerFeatures -Value 1 

        If (!(Test-Path $registryOEM)) {
            New-Item $registryOEM
        }
            Set-ItemProperty $registryOEM  ContentDeliveryAllowed -Value 0 
            Set-ItemProperty $registryOEM  OemPreInstalledAppsEnabled -Value 0 
            Set-ItemProperty $registryOEM  PreInstalledAppsEnabled -Value 0 
            Set-ItemProperty $registryOEM  PreInstalledAppsEverEnabled -Value 0 
            Set-ItemProperty $registryOEM  SilentInstalledAppsEnabled -Value 0 
            Set-ItemProperty $registryOEM  SystemPaneSuggestionsEnabled -Value 0          
    
        #Preping mixed Reality Portal for removal    
        Write-Output "Setting Mixed Reality Portal value to 0 so that you can uninstall it in Settings ..." 2>&1 >> $Logfile
        $Holo = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Holographic"    
        If (Test-Path $Holo) {
            Set-ItemProperty $Holo  FirstRunSucceeded -Value 0 
        }

        #Disables Wi-fi Sense
        Write-Output "Disabling Wi-Fi Sense ..." 2>&1 >> $Logfile
        $WifiSense1 = "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting"
        $WifiSense2 = "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots"
        $WifiSense3 = "HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config"
        If (!(Test-Path $WifiSense1)) {
	        New-Item $WifiSense1
        }
        Set-ItemProperty $WifiSense1  Value -Value 0 
	    If (!(Test-Path $WifiSense2)) {
	        New-Item $WifiSense2
        }
        Set-ItemProperty $WifiSense2  Value -Value 0 
	    Set-ItemProperty $WifiSense3  AutoConnectAllowedOEM -Value 0 
        
        #Disables live tiles
        Write-Output "Disabling live tiles ..." 2>&1 >> $Logfile
        $Live = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications"    
        If (!(Test-Path $Live)) {      
            New-Item $Live
        }
        Set-ItemProperty $Live  NoTileApplicationNotification -Value 1 
        
        #Turns off Data Collection via the AllowTelemtry key by changing it to 0
        Write-Output "Turning off Data Collection ..." 2>&1 >> $Logfile
        $DataCollection1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
        $DataCollection2 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
        $DataCollection3 = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection"    
        If (Test-Path $DataCollection1) {
            Set-ItemProperty $DataCollection1  AllowTelemetry -Value 0 
        }
        If (Test-Path $DataCollection2) {
            Set-ItemProperty $DataCollection2  AllowTelemetry -Value 0 
        }
        If (Test-Path $DataCollection3) {
            Set-ItemProperty $DataCollection3  AllowTelemetry -Value 0 
        }
    
        #Disabling Location Tracking
        Write-Output "Disabling Location Tracking ..." 2>&1 >> $Logfile
        $SensorState = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}"
        $LocationConfig = "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration"
        If (!(Test-Path $SensorState)) {
            New-Item $SensorState
        }
        Set-ItemProperty $SensorState SensorPermissionState -Value 0 
        If (!(Test-Path $LocationConfig)) {
            New-Item $LocationConfig
        }
        Set-ItemProperty $LocationConfig Status -Value 0 
        
        #Disables People icon on Taskbar
        Write-Output "Disabling People icon on Taskbar ..." 2>&1 >> $Logfile
        $People = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People"    
        If (!(Test-Path $People)) {
            New-Item $People
        }
        Set-ItemProperty $People  PeopleBand -Value 0 
        
        #Disables scheduled tasks that are considered unnecessary 
        Write-Output "Disabling scheduled tasks ..." 2>&1 >> $Logfile
        Get-ScheduledTask  XblGameSaveTaskLogon | Disable-ScheduledTask 2>&1 >> $Logfile
        Get-ScheduledTask  XblGameSaveTask | Disable-ScheduledTask 2>&1 >> $Logfile
        Get-ScheduledTask  Consolidator | Disable-ScheduledTask 2>&1 >> $Logfile
        Get-ScheduledTask  UsbCeip | Disable-ScheduledTask 2>&1 >> $Logfile
        Get-ScheduledTask  DmClient | Disable-ScheduledTask 2>&1 >> $Logfile
        Get-ScheduledTask  DmClientOnScenarioDownload | Disable-ScheduledTask 2>&1 >> $Logfile
    
        Write-Output "Stopping and disabling WAP Push Service" 2>&1 >> $Logfile
        #Stop and disable WAP Push Service
	    Stop-Service "dmwappushservice"
	    Set-Service "dmwappushservice" -StartupType Disabled

        Write-Output "Stopping and disabling Diagnostics Tracking Service" 2>&1 >> $Logfile
        #Disabling the Diagnostics Tracking Service
	    Stop-Service "DiagTrack"
	    Set-Service "DiagTrack" -StartupType Disabled
    }
Function Main
{
    Write-Host "$head1 Phase 2: Debloat START at $Timestamp $head2" 2>&1 >> $Logfile
    write-host "`n $header `n $halfhead Configuring Power settings ... $halfhead `n" 2>&1 >> $Logfile 
    PwrSet
    write-host "`n $header `n $halfhead Removing Microsoft Bloatware ... $halfhead `n" 2>&1 >> $Logfile
    Debloat
    write-host "`n $header `n $halfhead Taking Cortana out back with the shotgun ... $halfhead `n" 2>&1 >> $Logfile
    KillCortana
    write-Host "`n $header `n $halfhead Removing bloatware regkeys ... $halfhead `n" 2>&1 >> $Logfile
    RegDeblo
    write-host "`n $header `n $halfhead Tricking Teams into leaving ... $halfhead `n" 2>&1 >> $Logfile
    TricTeams
    write-host "`n $header `n $halfhead Removing OneDrive ... $halfhead `n" 2>&1 >> $Logfile
    NoOneDrive
    write-host "`n $header `n $halfhead Summoning the Undertaker ... $halfhead `n" 2>&1 >> $Logfile
    Undertaker
    write-host "`n $header `n $halfhead Stopping Microsoft Spyware ... $halfhead `n" 2>&1 >> $Logfile
    LokPriv
}
Write-Host "$head1 Phase 2: Debloat START at $Timestamp $head2" 2>&1 >> $Logfile 
Main
write-host "$head1 Phase 2: Debloat COMPLETED SUCCESSFULLY at $Timestamp $head2" 2>&1 >> $Logfile