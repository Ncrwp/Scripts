@echo off
set a=user
set b=password
title Open Client
:home
set c=
set d=
set cname=
cls
echo Menu:
echo.
echo 1) IP
echo 2) Name
echo 3) Custom
echo 4) Clear Drives
echo 5) Exit
echo.

set /P c=Type option: 
if "%c%"=="2" set cname=[EDITEDOUT] goto :name
if "%c%"=="1" set cname=11.68.&& goto :name
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