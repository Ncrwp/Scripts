@echo off
setlocal enabledelayedexpansion

:: Check if MyFiles folder exists
if not exist "MyFiles\" (
    echo MyFiles folder not found!
    pause
    exit /b
)

:: Create hashes folder if it doesn't exist
if not exist "Hashes\" mkdir "Hashes"

:: Generate hashes for all files in MyFiles
echo Generating MD5 hashes and file details...
echo. > "Hashes\md5_hashes.txt"
echo MD5 Hashes and file info generated on %date% %time% >> "Hashes\md5_hashes.txt"
echo ===================================================== >> "Hashes\md5_hashes.txt"

echo.
echo LIVE FILE INFO:
echo ===========================

for /r "MyFiles" %%f in (*) do (
    set "file=%%f"

    :: Get MD5 hash
    set "hash="
    for /f "skip=1 delims=" %%h in ('certutil -hashfile "%%f" MD5 ^| find /v "CertUtil"') do (
        set "hash=%%h"
    )
    set "hash=!hash: =!"

    :: Get file size in bytes
    for %%s in ("%%f") do set "size=%%~zs"

    :: Get line count (text files only)
    set "lineCount="
    for /f %%c in ('find /v /c "" ^< "%%f" 2^>nul') do set "lineCount=%%c"

    :: Get character count (for text files)
    set "charCount="
    for /f %%x in ('powershell -Command "(Get-Content -Raw -Encoding UTF8 -ErrorAction Ignore '%%f').Length"') do set "charCount=%%x"

    echo !file!
    echo   MD5: !hash!
    echo   Size: !size! bytes
    echo   Lines: !lineCount!
    echo   Chars: !charCount!
    echo -----------------------------------

    >> "Hashes\md5_hashes.txt" (
        echo FILE=!file!
        echo MD5=!hash!
        echo SIZE=!size!
        echo LINES=!lineCount!
        echo CHARS=!charCount!
        echo -----------------------------------
    )
)

echo.
echo ===========================
echo Done. Results saved in Hashes\md5_hashes.txt
pause
