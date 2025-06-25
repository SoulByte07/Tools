@echo off
setlocal EnableDelayedExpansion

:: === SET PATHS ===
set "ADB_PATH=<example= C:\adb> "
set "APK_DIR=<eample= C:\Users\username\Backups\Split_APKs> "
set "LOG_DIR=<eample= C:\Logs> "

:: === CREATE LOG FILE ===
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%"

for /f "tokens=1-3 delims=/ " %%a in ("%date%") do set "DATE=%%c-%%a-%%b"
for /f "tokens=1-2 delims=: " %%a in ("%time%") do set "TIME=%%a-%%b"

set "LOG_FILE=%LOG_DIR%\Split_APK_Installs_%DATE%_%TIME%.txt"
echo [INFO] Starting split APK installation... > "%LOG_FILE%"
echo =============================================== >> "%LOG_FILE%"

:: Add adb to PATH temporarily because you may get an error message like 'adb doesnt recoginsed as internal and external command'
set "PATH=%ADB_PATH%;%PATH%"

:: === MOVE TO APK DIRECTORY ===
pushd "%APK_DIR%"

:: === FIND AND INSTALL BASE APKs ===
for %%F in (*.apk) do (
    echo %%~nF | findstr /i "_split_" >nul
    if errorlevel 1 (
        call :install_apk_bundle "%%~nF"
    )
)

goto :summary

:: === FUNCTION: INSTALL APK BUNDLE ===
:install_apk_bundle
set "base=%~1"
set "install_cmd=adb install-multiple"
set "found=0"

for %%A in ("%base%*.apk") do (
    set "install_cmd=!install_cmd! "%%A""
    set "found=1"
)

if "!found!"=="1" (
    echo Installing: %base%
    echo Installing: !install_cmd! >> "%LOG_FILE%"
    !install_cmd! >> "%LOG_FILE%" 2>&1

    if !errorlevel! equ 0 (
        echo SUCCESS: %base% >> "%LOG_FILE%"
    ) else (
        echo ERROR: Failed to install %base% >> "%LOG_FILE%"
        echo %base% >> "%LOG_FILE%_fail.txt"
    )
    echo. >> "%LOG_FILE%"
)
exit /b

:: === SUMMARY SECTION ===
:summary
popd

echo. >> "%LOG_FILE%"
echo [SUMMARY] Failed Installs: >> "%LOG_FILE%"
if exist "%LOG_FILE%_fail.txt" (
    type "%LOG_FILE%_fail.txt" >> "%LOG_FILE%"
    del "%LOG_FILE%_fail.txt"
) else (
    echo None. All split APK bundles installed successfully. >> "%LOG_FILE%"
)

echo [DONE] All bundles attempted. >> "%LOG_FILE%"
echo Log saved at: "%LOG_FILE%"
echo Press any key to exit...
pause >nul
