@reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "AppName" /t REG_EXPAND_SZ /d "%ProgramFiles%\AppDir\AppName.exe" /f
