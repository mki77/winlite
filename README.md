## Windows Lite

Best possible setup for Windows 11 on older, unsupported PC, no Defender, no apps!

### How To

* Get [Windows 11](https://uupdump.net/fetchupd.php?arch=amd64&ring=retail&build=22621.1), version 22H2 (22621.1), Home N (the smallest available)

* Replace the UUP script config with this [ConvertConfig](ConvertConfig.ini)

* Run 'uup_download_windows' and wait for the WIM to be built

* Export installed drivers to add to the setup:

  ``DISM /Online /Export-Driver /Destination:C:\Drivers``

* Get [NTLite](https://www.ntlite.com/download/) and load this [Preset](NTLite.xml) as is without edits

* Set your language and keyboard in 'Unattended\OOBE\Windows localization'

* Save changes to WIM image and apply it to a disk partition using DISM:

  ``DISM /Apply-Image /Imagefile:D:\22621.1_amd64\install.wim /Index:1 /ApplyDir:E: /Compact``

  Installing via DVD/USB is unsupported without [AveYo](https://github.com/AveYo/MediaCreationTool.bat/tree/main/bypass11) hacks

* Get [EasyBCD](https://neosmart.net/Download/Register) and a new boot entry (set it as default)

* Finally reboot to complete the installation.
