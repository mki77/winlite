# https://store.rg-adguard.net
$AppxPackage = @(
'VCLibs.x64.Appx'
'VCLibs.UWPDesktop.x64.Appx'
'UI.Xaml.x64.Appx'
'WindowsCalculator.AppxBundle'
)
ForEach ($f in $AppxPackage) {Add-AppxPackage -Path .\$f}
Start-Sleep -s 5
