# Save current settings to a .reg file
Set-Content -Path .reg -Value "Windows Registry Editor Version 5.00`n"
Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Services\*' | ? ImagePath -notmatch 'drivers' | ? ImagePath -match 'system32' | ForEach-Object {";"+(Get-Service -name $_.PSChildName).DisplayName+"`n"+"[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\"+$_.PSChildName +"]`n"+'"Start"=dword:0000000'+$_.Start} | Add-Content -Path .reg
$TimeStamp = Get-Date -Format "yyddMM-HHmm"
Rename-Item -Path .reg -NewName "Services-$TimeStamp.reg"
