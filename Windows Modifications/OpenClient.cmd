@echo off
set a=USER
set b=PASSWORD
title Open Client
:home
set c=
set d=
set cname=
cls
echo Menu:
echo.
echo 1) Name
echo 2) IP
echo 3) Custom
echo 4) Clear Drives
echo 5) Exit
echo.

set /P c=Type option: 
if "%c%"=="1" set cname=PGGWD20H0&& goto :name
if "%c%"=="2" set cname=11.68.&& goto :name
if "%c%"=="3" set /P cname=Type:&& goto :name
if "%c%"=="4" net use * /delete && goto :home
if "%c%"=="5" exit
if "%c%"=="" goto :home

:name
set /P d=%cname%
net use * \\%cname%%d%\c$ /USER:%a% %b%
pause
Start "" "%SystemRoot%\explorer.exe" /Select,"This PC"
goto :home