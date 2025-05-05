@echo off
setlocal enabledelayedexpansion

:: CONFIGURATION
set "TARGET_VAR=testX"
set "BACKUP_FILE=%~dp0env_backup_%TARGET_VAR%_%date:~-4,4%%date:~-7,2%%date:~-10,2%.txt"
set "SYSTEM_REG_PATH=HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment"
set "USER_REG_PATH=HKCU\Environment"

:: ELEVATE TO ADMIN
NET FILE 1>NUL 2>NUL
if '%errorlevel%' neq '0' (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process -FilePath 'cmd' -ArgumentList '/c \"%~f0\"' -Verb RunAs"
    exit /b
)

:: MENU
:MENU
cls
echo ENVIRONMENT VARIABLE TOOL
echo Target variable: %TARGET_VAR%
echo.
echo 1. Backup and Set to Empty
echo 2. Backup and Delete
echo 3. Restore from Backup
echo 4. Exit
echo.
set /p "CHOICE=Select option (1-4): "
if "%CHOICE%"=="1" goto SETEMPTY
if "%CHOICE%"=="2" goto DELETEVAR
if "%CHOICE%"=="3" goto RESTORE
if "%CHOICE%"=="4" exit /b
goto MENU

:: BACKUP FUNCTION
:BACKUP
set "FOUND_ANY=0"

if exist "%BACKUP_FILE%" (
    echo Backup file already exists: %BACKUP_FILE%
    echo Skipping backup to preserve previous value.
    goto :EOF
)

:: SYSTEM
reg query "%SYSTEM_REG_PATH%" /v "%TARGET_VAR%" >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=2*" %%A in ('reg query "%SYSTEM_REG_PATH%" /v "%TARGET_VAR%"') do (
        if "%%A"=="REG_SZ" (
            set "val=%%B"
            if not "!val!"=="" (
                set "FOUND_ANY=1"
                set "systemValue=%%B"
                echo SYSTEM=%%B >> "%BACKUP_FILE%"
                echo SYSTEM variable backed up: %%B
            ) else (
                echo SYSTEM variable exists but is empty - not backed up
            )
        )
    )
)

:: USER
reg query "%USER_REG_PATH%" /v "%TARGET_VAR%" >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=2*" %%A in ('reg query "%USER_REG_PATH%" /v "%TARGET_VAR%"') do (
        if "%%A"=="REG_SZ" (
            set "val=%%B"
            if not "!val!"=="" (
                set "FOUND_ANY=1"
                set "userValue=%%B"
                echo USER=%%B >> "%BACKUP_FILE%"
                echo USER variable backed up: %%B
            ) else (
                echo USER variable exists but is empty - not backed up
            )
        )
    )
)

if "%FOUND_ANY%"=="0" (
    echo No non-empty variable found to back up.
)

goto :EOF

:: OPTION 1: SET TO EMPTY
:SETEMPTY
call :BACKUP

echo.
echo Setting variable to empty...
if defined systemValue (
    reg add "%SYSTEM_REG_PATH%" /v "%TARGET_VAR%" /t REG_SZ /d "" /f && echo SYSTEM variable set to empty
)
if defined userValue (
    reg add "%USER_REG_PATH%" /v "%TARGET_VAR%" /t REG_SZ /d "" /f && echo USER variable set to empty
)

echo.
if exist "%BACKUP_FILE%" (
    echo Backup saved to: %BACKUP_FILE%
)
pause
goto MENU

:: OPTION 2: DELETE VARIABLE
:DELETEVAR
call :BACKUP

echo.
echo Deleting variable...
if defined systemValue (
    reg delete "%SYSTEM_REG_PATH%" /v "%TARGET_VAR%" /f >nul && echo SYSTEM variable deleted
)
if defined userValue (
    reg delete "%USER_REG_PATH%" /v "%TARGET_VAR%" /f >nul && echo USER variable deleted
)

echo.
if exist "%BACKUP_FILE%" (
    echo Backup saved to: %BACKUP_FILE%
)
pause
goto MENU

:: OPTION 3: RESTORE FROM BACKUP
:RESTORE
if not exist "%BACKUP_FILE%" (
    echo Backup file not found: %BACKUP_FILE%
    pause
    goto MENU
)

echo.
echo Restoring from backup...

for /f "usebackq tokens=1* delims==" %%A in ("%BACKUP_FILE%") do (
    if "%%A"=="SYSTEM" (
        reg add "%SYSTEM_REG_PATH%" /v "%TARGET_VAR%" /t REG_SZ /d "%%B" /f && echo Restored SYSTEM variable to: %%B
    )
    if "%%A"=="USER" (
        reg add "%USER_REG_PATH%" /v "%TARGET_VAR%" /t REG_SZ /d "%%B" /f && echo Restored USER variable to: %%B
    )
)

pause
goto MENU
