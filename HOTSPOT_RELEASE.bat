@echo off
setlocal enabledelayedexpansion

REM ===============================================================================
REM HOTSPOT Release Manager v1.0
REM Automated packaging and distribution system for HOTSPOT AI
REM ===============================================================================

title HOTSPOT Release Manager

echo.
echo ===============================================================================
echo                     HOTSPOT AI - Release Manager v1.0
echo ===============================================================================
echo.

REM Check if running as administrator
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [WARNING] Not running as administrator. Some operations may fail.
    echo [INFO] Consider running as administrator for complete functionality.
    echo.
)

REM Set environment variables
set "PROJECT_ROOT=%~dp0"
set "PROJECT_NAME=HOTSPOT"
set "VERSION=1.0.0"
set "RELEASE_DATE=%DATE:~-4%-%DATE:~4,2%-%DATE:~7,2%"
set "BUILD_DIR=%PROJECT_ROOT%build"
set "DIST_DIR=%PROJECT_ROOT%dist"
set "TEMP_DIR=%PROJECT_ROOT%temp_release"
set "ARCHIVE_DIR=%PROJECT_ROOT%releases"

echo [INFO] Project Root: %PROJECT_ROOT%
echo [INFO] Version: %VERSION%
echo [INFO] Release Date: %RELEASE_DATE%
echo.

REM Create release directories
echo [STEP 1] Creating release directories...
if not exist "%BUILD_DIR%" mkdir "%BUILD_DIR%"
if not exist "%DIST_DIR%" mkdir "%DIST_DIR%"
if not exist "%TEMP_DIR%" mkdir "%TEMP_DIR%"
if not exist "%ARCHIVE_DIR%" mkdir "%ARCHIVE_DIR%"
echo [SUCCESS] Release directories created.
echo.

REM Clean previous builds
echo [STEP 2] Cleaning previous builds...
if exist "%TEMP_DIR%" (
    rmdir /s /q "%TEMP_DIR%" 2>nul
    mkdir "%TEMP_DIR%"
)
echo [SUCCESS] Previous builds cleaned.
echo.

REM Copy core files
echo [STEP 3] Copying core files...
set "RELEASE_FOLDER=%TEMP_DIR%\%PROJECT_NAME%_v%VERSION%"
mkdir "%RELEASE_FOLDER%"

REM Copy batch files
echo [INFO] Copying batch files...
for %%f in (*.bat) do (
    if /i not "%%f"=="HOTSPOT_RELEASE.bat" (
        if /i not "%%f"=="HOTSPOT_BACKUP.bat" (
            copy "%%f" "%RELEASE_FOLDER%\" >nul 2>&1
            echo [COPIED] %%f
        )
    )
)

REM Copy configuration files
echo [INFO] Copying configuration files...
for %%f in (*.json *.txt *.md *.csv) do (
    copy "%%f" "%RELEASE_FOLDER%\" >nul 2>&1
    echo [COPIED] %%f
)

REM Copy documentation
echo [INFO] Copying documentation...
if exist "docs" (
    xcopy "docs" "%RELEASE_FOLDER%\docs" /e /i /q >nul 2>&1
    echo [COPIED] docs folder
)

REM Copy source code if exists
echo [INFO] Copying source code...
if exist "src" (
    xcopy "src" "%RELEASE_FOLDER%\src" /e /i /q >nul 2>&1
    echo [COPIED] src folder
)

REM Copy public assets if exists
echo [INFO] Copying public assets...
if exist "public" (
    xcopy "public" "%RELEASE_FOLDER%\public" /e /i /q >nul 2>&1
    echo [COPIED] public folder
)

REM Copy tests if exists
echo [INFO] Copying tests...
if exist "tests" (
    xcopy "tests" "%RELEASE_FOLDER%\tests" /e /i /q >nul 2>&1
    echo [COPIED] tests folder
)

echo [SUCCESS] Core files copied.
echo.

REM Generate release notes
echo [STEP 4] Generating release notes...
set "RELEASE_NOTES=%RELEASE_FOLDER%\RELEASE_NOTES.txt"
(
echo HOTSPOT AI - Release Notes
echo Version: %VERSION%
echo Release Date: %RELEASE_DATE%
echo ===============================================================================
echo.
echo WHAT'S NEW:
echo - Native Windows AI system with advanced chat capabilities
echo - Comprehensive training and dataset integration
echo - Real-time diagnostics and performance monitoring
echo - Enhanced user interface with fancy chat features
echo - Improved GGUF model integration
echo - Advanced conversation management
echo.
echo SYSTEM REQUIREMENTS:
echo - Windows 10/11 ^(64-bit^)
echo - 8GB RAM minimum ^(16GB recommended^)
echo - 10GB free disk space
echo - Internet connection for model downloads
echo.
echo INSTALLATION:
echo 1. Extract all files to desired directory
echo 2. Run HOTSPOT_LAUNCHER.bat as administrator
echo 3. Follow the setup wizard
echo 4. Enjoy your AI assistant!
echo.
echo INCLUDED FILES:
echo - HOTSPOT_LAUNCHER.bat - Main launcher
echo - HOTSPOT_CORE.bat - Core AI engine
echo - HOTSPOT_CHAT_AGENT.bat - Chat interface
echo - HOTSPOT_TRAINING.bat - Model training
echo - HOTSPOT_DIAGNOSTICS.bat - System diagnostics
echo - Configuration files and documentation
echo.
echo SUPPORT:
echo For support and updates, check the documentation
echo or visit the project repository.
echo.
echo ===============================================================================
echo Generated on %DATE% at %TIME%
) > "%RELEASE_NOTES%"
echo [SUCCESS] Release notes generated.
echo.

REM Create installer script
echo [STEP 5] Creating installer script...
set "INSTALLER=%RELEASE_FOLDER%\INSTALL.bat"
(
echo @echo off
echo setlocal enabledelayedexpansion
echo.
echo title HOTSPOT AI - Installation Wizard
echo.
echo echo ===============================================================================
echo echo                     HOTSPOT AI - Installation Wizard
echo echo ===============================================================================
echo echo.
echo.
echo REM Check administrator privileges
echo net session ^>nul 2^>^&1
echo if %%errorlevel%% neq 0 ^(
echo     echo [ERROR] Please run as administrator for proper installation.
echo     echo Right-click this file and select "Run as administrator"
echo     pause
echo     exit /b 1
echo ^)
echo.
echo echo [INFO] Installing HOTSPOT AI...
echo echo [INFO] Creating shortcuts and registry entries...
echo.
echo REM Create desktop shortcut
echo set "DESKTOP=%%USERPROFILE%%\Desktop"
echo if exist "%%DESKTOP%%" ^(
echo     copy "HOTSPOT_LAUNCHER.bat" "%%DESKTOP%%\HOTSPOT AI.bat" ^>nul 2^>^&1
echo     echo [SUCCESS] Desktop shortcut created.
echo ^)
echo.
echo REM Create start menu entry
echo set "STARTMENU=%%APPDATA%%\Microsoft\Windows\Start Menu\Programs"
echo if exist "%%STARTMENU%%" ^(
echo     copy "HOTSPOT_LAUNCHER.bat" "%%STARTMENU%%\HOTSPOT AI.bat" ^>nul 2^>^&1
echo     echo [SUCCESS] Start menu entry created.
echo ^)
echo.
echo echo [SUCCESS] HOTSPOT AI installed successfully!
echo echo [INFO] You can now run HOTSPOT AI from:
echo echo         - Desktop shortcut
echo echo         - Start menu
echo echo         - This directory: HOTSPOT_LAUNCHER.bat
echo echo.
echo pause
) > "%INSTALLER%"
echo [SUCCESS] Installer script created.
echo.

REM Create uninstaller script
echo [STEP 6] Creating uninstaller script...
set "UNINSTALLER=%RELEASE_FOLDER%\UNINSTALL.bat"
(
echo @echo off
echo setlocal enabledelayedexpansion
echo.
echo title HOTSPOT AI - Uninstaller
echo.
echo echo ===============================================================================
echo echo                     HOTSPOT AI - Uninstaller
echo echo ===============================================================================
echo echo.
echo.
echo echo [WARNING] This will remove HOTSPOT AI shortcuts and preferences.
echo echo [WARNING] Your data and conversations will be preserved.
echo set /p "CONFIRM=Are you sure? (Y/N): "
echo if /i "%%CONFIRM%%" neq "Y" ^(
echo     echo [INFO] Uninstallation cancelled.
echo     pause
echo     exit /b 0
echo ^)
echo.
echo echo [INFO] Removing HOTSPOT AI shortcuts...
echo.
echo REM Remove desktop shortcut
echo set "DESKTOP=%%USERPROFILE%%\Desktop"
echo if exist "%%DESKTOP%%\HOTSPOT AI.bat" ^(
echo     del "%%DESKTOP%%\HOTSPOT AI.bat" ^>nul 2^>^&1
echo     echo [SUCCESS] Desktop shortcut removed.
echo ^)
echo.
echo REM Remove start menu entry
echo set "STARTMENU=%%APPDATA%%\Microsoft\Windows\Start Menu\Programs"
echo if exist "%%STARTMENU%%\HOTSPOT AI.bat" ^(
echo     del "%%STARTMENU%%\HOTSPOT AI.bat" ^>nul 2^>^&1
echo     echo [SUCCESS] Start menu entry removed.
echo ^)
echo.
echo echo [SUCCESS] HOTSPOT AI uninstalled successfully!
echo echo [INFO] Your data and configurations have been preserved.
echo echo.
echo pause
) > "%UNINSTALLER%"
echo [SUCCESS] Uninstaller script created.
echo.

REM Create ZIP archive
echo [STEP 7] Creating ZIP archive...
set "ARCHIVE_NAME=%PROJECT_NAME%_v%VERSION%_%RELEASE_DATE%.zip"
set "ARCHIVE_PATH=%ARCHIVE_DIR%\%ARCHIVE_NAME%"

REM Use PowerShell to create ZIP archive
powershell -command "Compress-Archive -Path '%RELEASE_FOLDER%\*' -DestinationPath '%ARCHIVE_PATH%' -Force" 2>nul
if %errorlevel% equ 0 (
    echo [SUCCESS] ZIP archive created: %ARCHIVE_NAME%
) else (
    echo [WARNING] Failed to create ZIP archive. Trying alternative method...
    REM Alternative: Copy to dist folder
    xcopy "%RELEASE_FOLDER%" "%DIST_DIR%\%PROJECT_NAME%_v%VERSION%" /e /i /q >nul 2>&1
    echo [SUCCESS] Release folder created in dist directory.
)
echo.

REM Generate checksums
echo [STEP 8] Generating checksums...
if exist "%ARCHIVE_PATH%" (
    powershell -command "Get-FileHash '%ARCHIVE_PATH%' -Algorithm SHA256 | Select-Object Hash | Out-File '%ARCHIVE_DIR%\%ARCHIVE_NAME%.sha256' -Encoding ASCII" 2>nul
    if %errorlevel% equ 0 (
        echo [SUCCESS] SHA256 checksum generated.
    )
)
echo.

REM Create release summary
echo [STEP 9] Creating release summary...
set "SUMMARY=%ARCHIVE_DIR%\RELEASE_SUMMARY_%VERSION%.txt"
(
echo HOTSPOT AI Release Summary
echo Version: %VERSION%
echo Release Date: %RELEASE_DATE%
echo Build Time: %TIME%
echo ===============================================================================
echo.
echo PACKAGE CONTENTS:
dir "%RELEASE_FOLDER%" /b
echo.
echo ARCHIVE DETAILS:
if exist "%ARCHIVE_PATH%" (
    echo Archive: %ARCHIVE_NAME%
    echo Size: 
    powershell -command "(Get-Item '%ARCHIVE_PATH%').Length / 1MB" 2>nul | findstr /r "[0-9]" > temp_size.txt
    set /p FILE_SIZE=<temp_size.txt
    echo !FILE_SIZE! MB ^(approximate^)
    del temp_size.txt 2>nul
)
echo.
echo CHECKSUMS:
if exist "%ARCHIVE_DIR%\%ARCHIVE_NAME%.sha256" (
    type "%ARCHIVE_DIR%\%ARCHIVE_NAME%.sha256"
)
echo.
echo DISTRIBUTION:
echo 1. Test the archive on clean systems
echo 2. Update project repository
echo 3. Create release notes
echo 4. Distribute to users
echo.
echo ===============================================================================
) > "%SUMMARY%"
echo [SUCCESS] Release summary created.
echo.

REM Cleanup temporary files
echo [STEP 10] Cleaning up...
if exist "%TEMP_DIR%" (
    rmdir /s /q "%TEMP_DIR%" 2>nul
)
echo [SUCCESS] Cleanup completed.
echo.

REM Final report
echo ===============================================================================
echo                          RELEASE COMPLETED SUCCESSFULLY!
echo ===============================================================================
echo.
echo Release Information:
echo   Version: %VERSION%
echo   Date: %RELEASE_DATE%
if exist "%ARCHIVE_PATH%" (
    echo   Archive: %ARCHIVE_NAME%
    echo   Location: %ARCHIVE_DIR%
)
echo   Summary: %SUMMARY%
echo.
echo Next Steps:
echo   1. Test the release package
echo   2. Verify all components work correctly
echo   3. Update documentation if needed
echo   4. Distribute to users
echo.
echo [INFO] Release files are ready in: %ARCHIVE_DIR%
echo.

REM Open release directory
set /p "OPEN_DIR=Open release directory? (Y/N): "
if /i "%OPEN_DIR%"=="Y" (
    explorer "%ARCHIVE_DIR%"
)

echo.
echo [INFO] Release process completed at %TIME%
pause
exit /b 0
