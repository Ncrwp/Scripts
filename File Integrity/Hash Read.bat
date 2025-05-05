@echo off
setlocal enabledelayedexpansion

if not exist "MyFiles\" (
    echo MyFiles folder not found!
    pause
    exit
)

echo MD5 Hash Verifier + File Info
echo ------------------------------
echo.

set /a total=0
set /a matches=0

for %%f in ("MyFiles\*") do (
    echo File: %%~nxf

    :: Get current MD5 hash
    set "hash="
    for /f "skip=1 delims=" %%h in ('certutil -hashfile "%%f" MD5 ^| find /v "CertUtil"') do set "hash=%%h"
    set "hash=!hash: =!"

    :: Get file size
    for %%s in ("%%f") do set "size=%%~zs"

    :: Get line count (text only)
    set "lineCount="
    for /f %%c in ('find /v /c "" ^< "%%f" 2^>nul') do set "lineCount=%%c"

    :: Get character count using PowerShell
    set "charCount="
    for /f %%x in ('powershell -Command "(Get-Content -Raw -Encoding UTF8 -ErrorAction Ignore '%%f').Length"') do set "charCount=%%x"

    :: Show file info
    echo Size       : !size! bytes
    echo Line Count : !lineCount!
    echo Char Count : !charCount!
    echo MD5 Hash   : !hash!
    echo.

    set /p "userhash=Enter expected MD5 hash: "
    set "userhash=!userhash: =!"

    if /i "!hash!" == "!userhash!" (
        echo [MATCH] Hashes are identical
        set /a matches+=1
    ) else (
        echo [MISMATCH] Hashes differ
    )

    set /a total+=1
    echo -------------------------------
    echo.
)

echo Summary:
echo Files Checked: !total!
echo Matches      : !matches!
set /a mismatches=!total!-!matches!
echo Mismatches   : !mismatches!
pause
