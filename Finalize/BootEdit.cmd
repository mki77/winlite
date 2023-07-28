@echo off
:: Enable boot menu (yes|no)
bcdedit /set {bootmgr} displaybootmenu yes
bcdedit /timeout 3
:: Enable F8 key menu
bcdedit /set bootmenupolicy Legacy
:: Disable BIOS logo, spinner
rem bcdedit /set bootuxdisabled on
:: Disable boot animation
rem bcdedit /set {globalsettings} custom:16000067 true
:: Disable loading circle
rem bcdedit /set {globalsettings} custom:16000069 true
:: Disable Driver Signature Enforcement
rem bcdedit /set nointegritychecks on
rem bcdedit /set loadoptions DISABLE_INTEGRITY_CHECKS
:: Disable Hyper-V (default)
bcdedit /set hypervisorlaunchtype off
bcdedit /debug off
timeout 3 >nul
exit
:: Rename boot items
bcdedit
bcdedit /set {guid} description "New Name"
:: Get device ID
GWMI -namespace root\cimv2 -class win32_volume | FL -property DriveLetter, DeviceID
bcdedit /set {afc41ce3-4701-11eb-984d-2089848358ec} description "Windows 11"
bcdboot c:\windows /l en-us
