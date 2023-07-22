# Run as Admin
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process PowerShell "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit}

# Speeds up PowerShell startup time by 10x
$env:path = $([Runtime.InteropServices.RuntimeEnvironment]::GetRuntimeDirectory())
[AppDomain]::CurrentDomain.GetAssemblies() | % {
    if (! $_.location) {continue}
    $Name = Split-Path $_.location -leaf
    Write-Host -ForegroundColor Yellow "NGENing : $Name"
    ngen install $_.location | % {"`t$_"}
}

# Run these tasks in the background to make sure that it's all ngened
.\schtasks /Run /TN "\Microsoft\Windows\.NET Framework\.NET Framework NGEN v4.0.30319"
.\schtasks /Run /TN "\Microsoft\Windows\.NET Framework\.NET Framework NGEN v4.0.30319 64"
