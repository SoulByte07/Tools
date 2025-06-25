@echo off
setlocal enabledelayedexpansion

:: Set base path
set "BASE_PATH=%~dp0"

:: Remove trailing backslash
if "%BASE_PATH:~-1%"=="\" set "BASE_PATH=%BASE_PATH:~0,-1%"

:: Set directories
set "ADB_PATH=%BASE_PATH%\adb"
set "APK_DIR=%BASE_PATH%\APKs"
set "LOG_DIR=%BASE_PATH%\Logs"

:: Create log directory if it doesn't exist
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%"

:: Format date and time
for /f "tokens=1-3 delims=/" %%a in ("%date%") do (
    set "DATE=%%c-%%a-%%b"
)
for /f "tokens=1-2 delims=:." %%a in ("%time%") do (
    set "TIME=%%a-%%b"
)

:: Set log file name
set "LOG_FILE=%LOG_DIR%\Bulk_APK_Installs_%DATE%_%TIME%.txt"

:: Temporarily add adb to PATH
set "PATH=%ADB_PATH%;%PATH%"

:: Initialize failed list
set "FAILED_LIST="

echo [INFO] Starting APK installations... > "%LOG_FILE%"
echo ================================================ >> "%LOG_FILE%"

:: Loop through APKs
for %%F in ("%APK_DIR%\*.apk") do (
    echo Installing: %%~nxF
    echo Installing: %%~nxF >> "%LOG_FILE%"

    adb install -r "%%F" >> "%LOG_FILE%" 2>&1
    if !errorlevel! equ 0 (
        echo SUCCESS: %%~nxF >> "%LOG_FILE%"
    ) else (
        echo ERROR: Failed to install %%~nxF >> "%LOG_FILE%"
        set "FAILED_LIST=!FAILED_LIST! %%~nxF"
    )
    echo. >> "%LOG_FILE%"
)

:: Summary
echo. >> "%LOG_FILE%"
echo ================================================= >> "%LOG_FILE%"
echo [SUMMARY] Failed APK Installations: >> "%LOG_FILE%"
if defined FAILED_LIST (
    for %%A in (!FAILED_LIST!) do (
        echo - %%A >> "%LOG_FILE%"
    )
) else (
    echo None. All APKs installed successfully. >> "%LOG_FILE%"
)

echo. >> "%LOG_FILE%"
echo [DONE] All APKs attempted. >> "%LOG_FILE%"

echo Log saved at: "%LOG_FILE%"
echo Press any key to exit...
pause >nul
