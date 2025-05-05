@echo off
title Static IPv4
:home

rem IP
echo Enter IP:  & set /P a=10.80.248.

echo IP = %a%

rem Subneting
set b=255.255.255.128

echo SubNeting = %b%

rem Gateway
set c=10.80.248.62

echo Gateway = %c%

tzutil /g

pause

netsh interface ipv4 set address name="Ethernet" static %a% %b% %c%
netsh interface ipv4 set dns name="Ethernet" static 10.80.253.220
pause
ncpa.cpl

echo.

FOR /F "tokens=* USEBACKQ" %%F IN (`hostname`) DO (
SET var=%%F
)
echo %var%

set /P hnme= New Host Name:
if "%hnme%"=="" goto :Home

WMIC computersystem where caption="%var%" call rename name="%hnme%"
echo Done
pause


del %0