@Echo off
title IPv4 Changer
:home
set a=
set b=
set c=
set d=
set adrs=
set sbnt=
set nstat=
cls
echo Menu:
echo.
echo 1) Ethernet
echo 2) Ethernet Info
echo 3) Wi-Fi
echo 4) Wi-Fi Info
echo 5) IP Configuration Info
echo 6) DHCP ON
echo 7) Exit
echo.

set /P a=Type option: 
if "%a%"=="1" set adap=Ethernet
if "%a%"=="2" netsh interface IPv4 show config name="Ethernet" & pause & goto :home
if "%a%"=="3" set adap=Wi-Fi
if "%a%"=="4" netsh interface IPv4 show config name="Wi-Fi" & pause & goto :home
if "%a%"=="5" ipconfig & pause & goto :home
if "%a%"=="6" netsh interface ipv4 set address name="%adap%" source=dhcp & netsh interface ipv4 show config name="%adap%" & pause & goto :home
if "%a%"=="7" exit
if "%a%"=="" goto :home


netsh interface IPv4 show config name="%adap%"

set /P adrs=Enter IPv4 Address: 
if "%adrs%"=="" goto :home

set /P b=Want to change Subnet settings [Y/N]? 
if "%b%"=="Y" set /P sbnt=Enter Subnet:
if "%b%"=="N" goto :choice
if "%b%"=="" goto :home

:choice
set /P c=Are you sure you want to change IPv4 settings [Y/N]? 
if "%c%"=="Y" goto :change
if "%c%"=="N" goto :cancel
if "%c%"=="" goto :home

:change
netsh interface ipv4 set address name="%adap%" static %adrs% %sbnt%
netsh interface ipv4 show config name="%adap%"
pause
goto :home

:cancel
echo.
echo Canceled
echo.
pause
goto :home