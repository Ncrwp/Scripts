@Echo off

title IPv4 Changer
:Home
set a=
set b=
set c=
set d=
set adrs=
set sbnt=
set nstat=
set hnme=
set sw1=1-CWControlClientInstaller.msi
set sw2=2-Agent_Install(wizard).MSI
set sw3=3-Agent_Install(backend).exe
set log="%CD%\%Computername%.txt"
cls

:Menu
echo Menu:
echo.
echo 1) Edit Ethernet IP
echo 2) Ethernet Info
echo 3) Edit Wi-Fi IP
echo 4) Wi-Fi Info
echo 5) IP Configuration Info
echo 6) DHCP ON
echo 7) Hostname
echo 8) Edit Hostname
echo 9) Multi Install
echo 10) Verify hosts file
echo 11) Admin priv
echo 12) Control
echo 13) Domain settings


echo i) Info
echo e) Exit
echo.

set /P a=Type option: 
if "%a%"=="1" set adap=Ethernet & goto :IpChange
if "%a%"=="2" netsh interface IPv4 show config name="Ethernet" & pause & goto :Home
if "%a%"=="3" set adap=Wi-Fi & goto :IpChange
if "%a%"=="4" netsh interface IPv4 show config name="Wi-Fi" & pause & goto :Home
if "%a%"=="5" ipconfig & pause & goto :Home
if "%a%"=="6" netsh interface ipv4 set address name="%adap%" source=dhcp & netsh interface ipv4 show config name="%adap%" & pause & goto :Home
if "%a%"=="7" hostname & pause & goto :Home
if "%a%"=="8" goto :HostNameEdit
if "%a%"=="9" goto :MultiInstall
if "%a%"=="10" start notepad.exe "C:\Windows\System32\drivers\etc\hosts" & start %windir%\explorer.exe "C:\Windows\System32\drivers\etc" & pause & goto :Home
if "%a%"=="11" goto :Admin
if "%a%"=="12" cmd.exe & pause & goto :Home
if "%a%"=="13" start sysdm.cpl pause & goto :Home
if 
if "%a%"=="i" goto :Info
if "%a%"=="e" exit
if "%a%"=="" goto :Home
echo Invalid Option
pause
goto :Home


:IpChange
netsh interface IPv4 show config name="%adap%"

set /P adrs=Enter IPv4 Address: 
if "%adrs%"=="" goto :Home

set /P b=Want to change Subnet settings [Y/N]? 
if "%b%"=="Y" set /P sbnt=Enter Subnet:
if "%b%"=="N" goto :choice
if "%b%"=="" goto :Home

:choice
set /P c=Are you sure you want to change IPv4 settings [Y/N]? 
if "%c%"=="Y" goto :Change
if "%c%"=="N" goto :Cancel
if "%c%"=="" goto :Home

:Change
netsh interface ipv4 set address name="%adap%" static %adrs% %sbnt%
netsh interface ipv4 show config name="%adap%"
pause
goto :Home

:HostNameEdit
FOR /F "tokens=* USEBACKQ" %%F IN (`hostname`) DO (
SET var=%%F
)
echo %var%

set /P hnme= New Name:
if "%hnme%"=="" goto :Home

WMIC computersystem where caption="%var%" call rename name="%hnme%"
echo Restarting...
pause
shutdown \r

pause & goto :Home

:MultiInstall
echo Installing... 
echo %sw1%
echo %sw2%
echo %sw3%

start /wait "%CD%/%sw1%"
start /wait "%CD%/%sw2%"
start /wait "%CD%/%sw3%"

pause
goto :Home

:Admin
set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )
goto :Home


:Info

echo. > %log%
hostname >> %log%
ipconfig >> %log%
wmic product get name,version >> %log%

goto :Home

:Cancel
echo.
echo Canceled
echo.
pause
goto :Home