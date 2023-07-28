# Run with administrator privileges
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {Start-Process PowerShell.exe "-File `"$PSCommandPath`"" -Verb runas -WindowStyle hidden; exit}
$ErrorActionPreference = 'silentlycontinue'
$Services = @(
"AudioEndpointBuilder"
"Audiosrv"
"BFE"
"BITS"
"BrokerInfrastructure"
"CoreMessagingRegistrar"
"CryptSvc"
"DcomLaunch"
"defragsvc"
"Dhcp"
"Dnscache"
"dot3svc"
"DusmSvc"
"EventLog"
"EventSystem"
"gpsvc"
"LSM"
"mpssvc"
"Netman"
"netprofm"
"NlaSvc"
"nsi"
"PlugPlay"
"Power"
"ProfSvc"
"RpcEptMapper"
"RpcSs"
"SamSs"
"Schedule"
"SecurityHealthService"
"ShellHWDetection"
"SysMain"
"SystemEventsBroker"
"Themes"
"TrkWks"
"UsoSvc"
"WlanSvc"
"wlidsvc"
"WpnService"
"WpnUserService"
"WSearch"
"WwanSvc"
)
foreach ($Service in $Services) {
	Set-Service -Name $Service -StartupType Automatic
}
$Services = @(
"CDPUserSvc"
"icssvc"
"lltdsvc"
"OneSyncSvc"
"RmSvc"
"DPS"
"PcaSvc"
"WdiServiceHost"
"WdiSystemHost"
"WerSvc"
)
foreach ($Service in $Services) {
	Set-Service -Name $Service -StartupType Manual
}
$ErrorActionPreference = 'silentlycontinue'
$Services = Get-WmiObject -Class Win32_Service
$List = foreach ($Service in $Services) {
	# Delayed Startup
	$ItemProperty = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\$($Service.Name)"
	if ($ItemProperty.Start -eq 2 -and $ItemProperty.DelayedAutoStart -eq 1) {
		Set-Service -Name $Service.Name -StartupType AutomaticDelayedStart
		continue
	}
	# Triggered Startup
	if (Test-Path -Path "HKLM:\SYSTEM\CurrentControlSet\Services\$($Service.Name)\TriggerInfo\") {
		Set-Service -Name $Service.Name -StartupType Manual
		continue
	}
	[PSCustomObject] @{
		DisplayName = $Service.DisplayName
		Name = $Service.Name
		StartMode = $Service.StartMode
		Status = $Service.State
	}
}
$List | Out-GridView -Title "Services" -Wait
#Start-Sleep -Seconds 3
