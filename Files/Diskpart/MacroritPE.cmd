@echo off
pushd "%Temp%"
curl.exe -L -o mde-free-setup.zip https://disk-tool.com/download/mde/mde-free-setup.zip
PowerShell.exe "Expand-Archive mde-free-setup.zip -DestinationPath ."
start mde-free-setup.exe
