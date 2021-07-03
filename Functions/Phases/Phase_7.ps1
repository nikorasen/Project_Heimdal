# # # # Phase 7: Manual Tools # # # #
$global:Caps = "$global:logpath\ManAV_ScrCaps\"
Add-type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
$global:Scr = [System.Windows.Forms.SystemInformation]::VirtualScreen
$global:Wid = $Screen.Width
$global:Hei = $Screen.Height
$global:Lft = $Screen.Left
$global:Top = $Screen.Top
$global:BMP = New-Object System.Drawing.Bitmap $global:Wid, $global:Hei
$global:Grp = [System.Drawing.Graphics]::fromimage($global:BMP)
function MBSS
{
    #captures screenshot after manual malwarebytes scan
    $File = "$global:Caps\MBAM_Results.bmp"
    $global:Grp.CopyFromScreen($global:Lft, $global:top, 0, 0, $global:BMP.size)
    $global:BMP.save($File)
}
function MBAM
{
    $Prompt = [System.Windows.MessageBox]::Show('MalwareBytes scan COMPLETE. Please ensure MBAM window is visible on screen, then click CONTINUE to capture screenshot.','MBAM Complete','CONTINUE','Error')
    switch ($Prompt) {
        'CONTINUE' {
            MBSS
        }
    }
    & M:\Toolbox\Mbam\mbam.exe | Out-Null
    $Prompt
}
function IMSS
{
    $File = "$global:Caps\Immunet_Results.bmp"
    $global:Grp.CopyFromScreen($global:Lft, $global:top, 0, 0, $global:BMP.size)
    $global:BMP.save($File)
}
function IMSCN
{
    $Prompt = [System.Windows.MessageBox]::Show('Immunet scan COMPLETE. Please ensure results window is visible on screen, then click CONTINUE to capture screenshot.','Immunet Complete','CONTINUE','Error')
    switch ($Prompt) {
        'CONTINUE' {
            IMSS
        }
    }
    & M:\Toolbox\Immunet\immunetSetup.exe | Out-Null
    $Prompt
}
function AHCSS
{
    $File = "$global:Caps\Housecall_Results.bmp"
    $global:Grp.CopyFromScreen($global:Lft, $global:top, 0, 0, $global:BMP.size)
    $global:BMP.save($File)
}
function HCSCN
{
    $Prompt = [System.Windows.MessageBox]::Show('Housecall scan COMPLETE. Please ensure results window is visible on screen, then click CONTINUE to capture screenshot.','Housecall Complete','CONTINUE','Error')
    switch ($Prompt) {
        'CONTINUE' {
            AHCSS
        }
    }
    & M:\Toolbox\House\HousecallLauncher64.exe | Out-Null
    $Prompt
}
function PANSS
{
    $File = "$global:Caps\Panda_Results.bmp"
    $global:Grp.CopyFromScreen($global:Lft, $global:top, 0, 0, $global:BMP.size)
    $global:BMP.save($File)
}
function PANSCN
{
    $Prompt = [System.Windows.MessageBox]::Show('Panda scan COMPLETE. Please ensure results window is visible on screen, then click CONTINUE to capture screenshot.','Panda Complete','CONTINUE','Error')
    switch ($Prompt) {
        'CONTINUE' {
            PANSS
        }
    }
    & M:\Toolbox\Panda\PADNAFREEAV.exe | Out-Null
    $Prompt
}
function BITSS
{
    $File = "$global:Caps\Bitdefender_Results.bmp"
    $global:Grp.CopyFromScreen($global:Lft, $global:top, 0, 0, $global:BMP.size)
    $global:BMP.save($File)
}
function BITSCN
{
    $Prompt = [System.Windows.MessageBox]::Show('Bitdefender scan COMPLETE. Please ensure results window is visible on screen, then click CONTINUE to capture screenshot.','Bitdefender Complete','CONTINUE','Error')
    switch ($Prompt) {
        'CONTINUE' {
            BITSS
        }
    }
    & M:\Toolbox\bitdefender_online.exe | Out-Null
    $Prompt
}
function init_Phase_7
{
    MBAM
    IMSCN
    HCSCN
    PANSCN
    BITSCN
}
init_Phase_7