@echo off
:: Run as Administrator
reg query "HKU\S-1-5-19" >nul || ((
	echo Set UAC = CreateObject("Shell.Application"^)
	echo UAC.ShellExecute "%~s0", "%~dp0", "", "runas", 1
)>"%temp%\runas.vbs" &"%temp%\runas.vbs" &exit)
pushd %SystemRoot%\System32
title %~n0 //github.com/mki77
cscript //nologo slmgr.vbs /xpr
echo.
echo.Press a key to (re)activate.
pause>nul
echo.
for /f "skip=2 tokens=3*" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v EditionID') do set "EditionID=%%a"
::
::https://docs.microsoft.com/en-us/windows-server/get-started/kms-client-activation-keys
::
if "%EditionID%" equ "Core"   set key=TX9XD-98N7V-6WMQ6-BX7FG-H8Q99
if "%EditionID%" equ "Core N" set key=3KHY7-WNT83-DGQKR-F7HPR-844BM
if "%EditionID%" equ "Professional"   set key=W269N-WFGWX-YVC9B-4J6C9-T83GX
if "%EditionID%" equ "Professional N" set key=MH37W-N47XK-V7XM9-C7227-GCQG9
if "%EditionID%" equ "Professional Workstation"   set key=NRG8B-VKK3Q-CXVCJ-9G2XF-6Q84J
if "%EditionID%" equ "Professional Workstation N" set key=9FNHH-K3HBT-3W4TD-6383H-6XYWF
if "%EditionID%" equ "Enterprise"   set key=NPPR9-FWDCX-D2C8J-H872K-2YT43
if "%EditionID%" equ "Enterprise N" set key=DPH2V-TTNVB-4X9Q3-TJR4H-KHJW4
::
cscript //nologo slmgr.vbs /upk
cscript //nologo slmgr.vbs /ipk %key%
set servers= ^
kms9.msguides.com ^
kms8.msguides.com ^
kms7.msguides.com ^
kms.cangshui.net ^
kms.digiboy.ir ^
kms.jm33.me ^
kms.loli.beer
for %%s in (%servers%) do (
	ping -n 1 -w 500 %%s | findstr /r /c:"=[0-9]*ms" && (
		cscript //nologo slmgr.vbs /skms %%s:1688
		cscript //nologo slmgr.vbs /ato
		timeout /t 3 >nul &exit
))
exit