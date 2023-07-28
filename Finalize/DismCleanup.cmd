@echo off
>nul reg add hkcu\software\classes\.admin\shell\runas\command /f /ve /d "cmd /x /d /r set \"f0=%%2\"&call \"%%2\" %%3"&set _= %*
>nul fltmc || if "%f0%" neq "%~f0" (cd.>"%temp%\runas.admin" &start "%~n0" /high "%temp%\runas.admin" "%~f0" "%_:"=""%"&exit)
pushd "%~dp0"
title %~n0 //github.com/mki77
color 4f
mode con:cols=80 lines=40
set DISM=dism.exe /English /LogLevel:1 /LogPath:%SystemRoot%\Temp\dism.log /Online
set "_=                          "
set strip=[7m %_%[ DiSM CleanUp ]%_% [0m
set strip=cls^&echo.^&echo.%strip%^&echo.
call %strip%
call :RmApps
rem call :RmFeatures
call :RmPackages
echo.
echo This script will close in seconds...
timeout /t 10 >nul
shutdown.exe /r /t 10
exit /b
:RmApps
setlocal enableDelayedExpansion
if not exist Apps.txt (
	for /f "tokens=3" %%a in ('%DISM% /Get-ProvisionedAppxPackages ^| find "Package"') do echo %%a
)>Apps.txt
if not exist Apps.txt goto :eof
call %strip%
echo.Apps.txt entries will be removed. Press a key to continue...
pause>nul
echo Removing Windows Apps...
for /f "tokens=*" %%a in (Apps.txt) do %DISM% /Remove-ProvisionedAppxPackage /PackageName:%%a
goto :eof
:RmFeatures
setlocal enableDelayedExpansion
if not exist Features.txt (
	for /f "tokens=4" %%a in ('%DISM% /Get-Features ^| find "Name"') do echo.%%a
)>Features.txt
if not exist Features.txt goto :eof
call %strip%
echo.Features.txt entries will be removed. Press a key to continue...
pause>nul
echo Removing Windows Features...
for /f "tokens=*" %%a in (Features.txt) do %DISM% /Disable-Feature /FeatureName:%%a /Remove /NoRestart
goto :eof
:RmPackages
setlocal EnableDelayedExpansion
if not exist Packages.txt (
	for /f "tokens=*" %%a in ('REG query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages" /f "-" /k') do (
	set "_=%%~na"
	set _=!_:Microsoft-=!
	set _=!_:Windows-=!
	set _=!_:merged-=!
	set _=!_:WOW64-=!
	set _=!_:-Package= !
	for %%s in ("!_:* = !") do (set _=!_:%%~s=!)
	if not "!_!"=="!_:-=!" echo.!_!
))>Packages.txt
sort /unique Packages.txt /o Packages.txt
if not exist Packages.txt goto :eof
call %strip%
echo.Packages.txt entries will be removed. Press a key to continue...
pause>nul
echo Removing System Components...
title DISM Running... 0%%
:: Loops are written this way to get better execution speed, do not modify
for /f %%p in (Packages.txt) do (for /f "tokens=*" %%a in ('REG query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages" /f "%%p" /k ^| find "-"') do (
	set /a steps+=1
>nul 2>&1 (
	reg add "%%a" /v Visibility /t REG_DWORD /d 1 /f
	reg add "%%a" /v DefVis /t REG_DWORD /d 2 /f
	reg delete "%%a\Owners" /f)
))
for /f "tokens=2 delims=:" %%a in ('%DISM% /Get-Packages') do (set _=%%a
	for /f %%p in (Packages.txt) do (
		if not "!_:%%p=!"=="!_!" (
			%DISM% /Remove-Package /PackageName:"!_:~1!" /NoRestart >nul && echo !_:~1!
			set /a step+=1
			set /a "progress=(!step!*100)/!steps!"
			title DISM Running... !progress!%%
)))
title DISM Running... 100%%
>nul 2>&1 (
	REG add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /v Cleanup /t REG_SZ /d "DISM /Online /Cleanup-Image /StartComponentCleanup /ResetBase" /f
	REG add "HKLM\Software\Microsoft\Windows\CurrentVersion\SideBySide\Configuration" /v "DisableResetBase" /t "REG_DWORD" /d "0" /f
	DISM /Online /Remove-DefaultAppAssociations
	rem DISM /Optimize-ProvisionedAppxPackages
)
goto :eof
exit /b
:Init
set menu= ^
1:RmApps:"Remove Windows apps":"Does not remove user-installed apps" ^
2:RmFeatures:"Remove optional features":"..." ^
3:RmPackages:"Remove system components":"..." ^
0:ReBoot:"Reboot Windows"
call %strip%
echo.
set "_= "
for %%i in (%menu%) do (
	for /f "delims=: tokens=1-4" %%a in ("%%i") do echo.%_%[7m %%a [0m %%~c&echo.%_%    %%~d&echo.
)
echo Press a number...
choice /n /c:1234567890 /m ">"
call set /a n=%errorlevel%
if %n% equ 10 call shutdown.exe /o /r /t 10
for %%i in (%menu%) do (
	for /f "tokens=1-2 delims=:" %%a in ("%%i") do (if %n% equ %%a call :%%b)
)
goto :Init
exit /b