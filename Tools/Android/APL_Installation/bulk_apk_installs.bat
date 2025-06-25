@echo off
setlocal enabledelayedexpansion

:: Set directories
set "ADB_PATH=C:\Tools\Android\adb"
set "APK_DIR=C:\Users\soul\99_Archive\Backups\APK extractor"
set "LOG_DIR=C:\Logs\Android\ADB\APK Installs"

:: Create log directory if it doesn't exist
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%"

:: Format date and time (replace / and : with -)
for /f "tokens=1-3 delims=/ " %%a in ("%date%") do (
    set "DATE=%%c-%%a-%%b"
)
for /f "tokens=1-2 delims=: " %%a in ("%time%") do (
    set "TIME=%%a-%%b"
)

:: Set log file name
set "LOG_FILE=%LOG_DIR%\Bulk_APK_Installs_%DATE%_%TIME%.txt"

:: Add adb to PATH temporarily
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
        set "FAILED_LIST=!FAILED_LIST!%%~nxF;"
    )
    
    echo. >> "%LOG_FILE%"
)

:: Summary of failed installs
echo. >> "%LOG_FILE%"
echo ================================================= >> "%LOG_FILE%"
echo [SUMMARY] Failed APK Installations: >> "%LOG_FILE%"
if defined FAILED_LIST (
    for %%a in (!FAILED_LIST!) do (
        echo - %%a >> "%LOG_FILE%"
    )
) else (
    echo None. All APKs installed successfully. >> "%LOG_FILE%"
)

echo. >> "%LOG_FILE%"
echo [DONE] All APKs attempted. >> "%LOG_FILE%"

echo Log saved at: "%LOG_FILE%"
echo Press any key to exit...
pause >nul
