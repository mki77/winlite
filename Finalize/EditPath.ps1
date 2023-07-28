$Dirs = Get-ItemPropertyValue -Path HKCU:\Environment -Name "Path"
$Dirs = ($Dirs.Split(';') | ? {$_.Trim() -ne "" } | Sort-Object -Unique) -Join ';'
echo $Dirs
Set-ItemProperty -Path HKCU:\Environment -Name "Path" -Value "$Dirs;"
rundll32.exe sysdm.cpl,EditEnvironmentVariables
