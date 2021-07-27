# # # # Phase 7: Manual Tools # # # #
$global:Caps = "$global:logpath\$global:DevID-ManAV_ScrCaps"
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
    $Prompt = [System.Windows.MessageBox]::Show('Please run MBAM Full System Scan, Please ensure MBAM window is visible on screen when Scan is complete, click CONTINUE to capture screenshot.','MBAM Complete','CONTINUE','Error')
    switch ($Prompt) {
        'CONTINUE' {
            MBSS
        }
    }
    $Prompt | out-null
}
function Kill_Mbam
{
    ."M:\Functions\Modules\MBAM_Deploy.ps1" -DeploymentType "Uninstall" -DeployMode "silent"
}
function IMSS
{
    $File = "$global:Caps\Immunet_Results.bmp"
    $global:Grp.CopyFromScreen($global:Lft, $global:top, 0, 0, $global:BMP.size)
    $global:BMP.save($File)
}
function IMSCN
{
    $Prompt = [System.Windows.MessageBox]::Show('Please run Immunet Full System Scan, Please ensure results window is visible on screen when scan is complete, click CONTINUE to capture screenshot.','Immunet Complete','CONTINUE','Error')
    switch ($Prompt) {
        'CONTINUE' {
            IMSS
        }
    }
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
    $Prompt = [System.Windows.MessageBox]::Show('Please run Housecall Full System Scan, Please ensure results window is visible on screen when scan is complete,  click CONTINUE to capture screenshot.','Housecall Complete','CONTINUE','Error')
    switch ($Prompt) {
        'CONTINUE' {
            AHCSS
        }
    }
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
    $Prompt = [System.Windows.MessageBox]::Show('Please run Panda Full System Scan, Please ensure results window is visible on screen when scan is complete,  click CONTINUE to capture screenshot.','Panda Complete','CONTINUE','Error')
    switch ($Prompt) {
        'CONTINUE' {
            PANSS
        }
    }
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
    $Prompt = [System.Windows.MessageBox]::Show('Please run BitDefender Full System Scan, Please ensure results window is visible on screen when scan is complete,  click CONTINUE to capture screenshot.','Bitdefender Complete','CONTINUE','Error')
    switch ($Prompt) {
        'CONTINUE' {
            BITSS
        }
    }
    $Prompt
}
function DRGSS
{
    $File = "$global:Caps\Comodo_Results.bmp"
    $global:Grp.CopyFromScreen($global:Lft, $global:top, 0, 0, $global:BMP.size)
    $global:BMP.save($file)
}
function DRGSCN
{
    $Prompt = [System.Windows.MessageBox]::Show('Please run Comodo Full System Scan, Please ensure results window is visible on screen when scan is complete, click CONTINUE to capture screenshot.','Comodo Complete','CONTINUE','Error')
    switch ($Prompt) {
        'CONTINUE' {
            DRGSS
        }
    }
    $Prompt
}
function init_Phase_7
{
    MBAM
    IMSCN
    HCSCN
    PANSCN
    BITSCN
    DRGSCN
}
init_Phase_7