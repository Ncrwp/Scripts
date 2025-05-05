@echo off
title Static IPv4
:home

rem IP
set a=

echo IP = %a%

rem Subneting
set b=

echo SubNeting = %b%

rem Gateway
set c=

echo Gateway = %c%

tzutil /g

pause

netsh interface ipv4 set address name="Ethernet" static %a% %b% %c%
netsh interface ipv4 set dns name="Ethernet" static PRIMARY_DNS_IP
netsh interface ipv4 add dns name="Ethernet" SECONDARY_DNS_IP index=2
pause
ncpa.cpl

del %0