# # # # Phase 7: Manual Tools # # # #
& M:\Toolbox\Mbam\mbam.exe | Out-Null
[system.windows.messagebox]::show('MalwareBytes scan COMPLETE. Please Take a screenshot of the scan results and save to the EncArch.')
& M:\Toolbox\Immunet\immunetSetup.exe | Out-Null
& M:\Toolbox\House\HousecallLauncher64.exe | Out-Null
& M:\Toolbox\Panda\PADNAFREEAV.exe | Out-Null
& M:\Toolbox\bitdefender_online.exe | Out-Null
