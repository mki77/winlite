@echo off
:: Deny incoming connections
netsh advfirewall set currentprofile state on
netsh advfirewall set currentprofile firewallpolicy blockinboundalways,allowoutbound
netsh advfirewall firewall delete rule name=all dir=in
rem netsh advfirewall import|export policy.wfw
rem netsh advfirewall reset
