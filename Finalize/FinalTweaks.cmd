@echo off
>nul reg add HKCU\Software\Classes\.Admin\shell\runas\command /f /ve /d "cmd /x /d /r set \"f0=%%2\"&call \"%%2\" %%3"&set _= %*
>nul fltmc || if "%f0%" neq "%~f0" (cd.>"%temp%\runas.Admin" &start "%~n0" /high "%temp%\runas.Admin" "%~f0" "%_:"=""%" &exit /b)
rem pushd "%~dp0"
color 4f
call :FastBoot
call :Fixes
echo.
echo This script will close in seconds...
timeout /t 10 >nul
shutdown.exe /r /t 10
exit
:FastBoot
:: Enable F8 key menu
bcdedit /set {bootmgr} displaybootmenu yes
bcdedit /set bootmenupolicy Legacy
bcdedit /set hypervisorlaunchtype off
bcdedit /debug off
bcdedit /timeout 3
:: Turn on fast boot and enable prefetch for better startup times
rem powercfg /setactive scheme_min|scheme_max|scheme_balanced
rem powercfg /restoredefaultschemes
powercfg /setactive scheme_balanced
powercfg /h on
powercfg /h /size 0
powercfg /h /type reduced
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /V "HiberbootEnabled" /t REG_DWORD /d "1" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnablePrefetcher" /t REG_DWORD /d "2" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnableSuperfetch" /t REG_DWORD /d "3" /f
sc config defragsvc start=auto
sc config SysMain start=auto
:: Disabling Autologgers...
for /f %%k in ('reg query HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger /s /v Start ^| find "\" ^| find /v "EventLog"') do (reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\%%~nk" /v Start /t REG_DWORD /d 0 /f >nul &&echo %%~nk)
:: Optimize NTFS [HKLM\SYSTEM\CurrentControlSet\Control\Filesystem]
fsutil behavior set allowextchar 0
fsutil behavior set disable8dot3 1
fsutil behavior set disablecompression 0
fsutil behavior set disableencryption 1
fsutil behavior set disablelastaccess 1
fsutil behavior set encryptpagingfile 0
fsutil behavior set memoryusage 1
fsutil behavior set mftzone 1
:: Strip filenames, older apps can no longer be started/uninstalled
rem fsutil 8dot3name strip /f /s c:
:: Enable TRIM feature, don't set in VMs
rem fsutil behavior set DisableDeleteNotify 0
goto :eof
:Fixes
:: Run .ps1 files with PowerShell by default
ftype Microsoft.PowerShellScript.1="PowerShell.exe" -NoLogo -File "%1" %*
:: Disable telemetry
setx DOTNET_CLI_TELEMETRY_OPTOUT 1
setx POWERSHELL_TELEMETRY_OPTOUT 1
:: Deny incoming connections
netsh advfirewall set currentprofile state on
netsh advfirewall set currentprofile firewallpolicy blockinboundalways,allowoutbound
netsh advfirewall firewall delete rule name=all dir=in
rem netsh advfirewall import|export policy.wfw
rem netsh advfirewall reset
goto :eof
