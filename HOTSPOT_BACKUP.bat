@echo off
setlocal enabledelayedexpansion

REM ===============================================================================
REM HOTSPOT Backup Manager v1.0
REM Automated backup and recovery system for HOTSPOT AI
REM ===============================================================================

title HOTSPOT Backup Manager

echo.
echo ===============================================================================
echo                     HOTSPOT AI - Backup Manager v1.0
echo ===============================================================================
echo.

REM Check if running as administrator
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [WARNING] Not running as administrator. Some backup operations may fail.
    echo [INFO] Consider running as administrator for complete functionality.
    echo.
)

REM Set environment variables
set "PROJECT_ROOT=%~dp0"
set "PROJECT_NAME=HOTSPOT"
set "BACKUP_DATE=%DATE:~-4%-%DATE:~4,2%-%DATE:~7,2%"
set "BACKUP_TIME=%TIME:~0,2%-%TIME:~3,2%-%TIME:~6,2%"
set "BACKUP_TIMESTAMP=%BACKUP_DATE%_%BACKUP_TIME%"
set "BACKUP_BASE_DIR=%PROJECT_ROOT%backups"
set "BACKUP_DIR=%BACKUP_BASE_DIR%\backup_%BACKUP_TIMESTAMP%"
set "CONFIG_DIR=%PROJECT_ROOT%config"
set "LOGS_DIR=%PROJECT_ROOT%logs"

REM Clean timestamp (remove spaces)
set "BACKUP_TIMESTAMP=%BACKUP_TIMESTAMP: =0%"
set "BACKUP_DIR=%BACKUP_BASE_DIR%\backup_%BACKUP_TIMESTAMP%"

echo [INFO] Project Root: %PROJECT_ROOT%
echo [INFO] Backup Timestamp: %BACKUP_TIMESTAMP%
echo [INFO] Backup Directory: %BACKUP_DIR%
echo.

REM Display backup options menu
:BACKUP_MENU
echo ===============================================================================
echo                              BACKUP OPTIONS
echo ===============================================================================
echo.
echo 1. Quick Backup (Essential files only)
echo 2. Full Backup (All project files)
echo 3. Configuration Backup (Settings and configs only)
echo 4. Data Backup (Conversations and training data)
echo 5. System Backup (Complete system state)
echo 6. Restore from Backup
echo 7. List Available Backups
echo 8. Cleanup Old Backups
echo 9. Exit
echo.
set /p "BACKUP_CHOICE=Select backup option (1-9): "

if "%BACKUP_CHOICE%"=="1" goto QUICK_BACKUP
if "%BACKUP_CHOICE%"=="2" goto FULL_BACKUP
if "%BACKUP_CHOICE%"=="3" goto CONFIG_BACKUP
if "%BACKUP_CHOICE%"=="4" goto DATA_BACKUP
if "%BACKUP_CHOICE%"=="5" goto SYSTEM_BACKUP
if "%BACKUP_CHOICE%"=="6" goto RESTORE_BACKUP
if "%BACKUP_CHOICE%"=="7" goto LIST_BACKUPS
if "%BACKUP_CHOICE%"=="8" goto CLEANUP_BACKUPS
if "%BACKUP_CHOICE%"=="9" goto EXIT_SCRIPT

echo [ERROR] Invalid choice. Please select 1-9.
echo.
goto BACKUP_MENU

:QUICK_BACKUP
echo.
echo ===============================================================================
echo                              QUICK BACKUP
echo ===============================================================================
echo.

REM Create backup directory
echo [STEP 1] Creating backup directory...
if not exist "%BACKUP_BASE_DIR%" mkdir "%BACKUP_BASE_DIR%"
mkdir "%BACKUP_DIR%"
echo [SUCCESS] Backup directory created.
echo.

REM Backup essential files
echo [STEP 2] Backing up essential files...

REM Backup batch scripts
echo [INFO] Backing up batch scripts...
mkdir "%BACKUP_DIR%\scripts"
for %%f in (*.bat) do (
    copy "%%f" "%BACKUP_DIR%\scripts\" >nul 2>&1
    echo [BACKED UP] %%f
)

REM Backup configuration files
echo [INFO] Backing up configuration files...
mkdir "%BACKUP_DIR%\config"
for %%f in (*.json *.txt *.csv) do (
    copy "%%f" "%BACKUP_DIR%\config\" >nul 2>&1
    echo [BACKED UP] %%f
)

REM Backup documentation
echo [INFO] Backing up documentation...
for %%f in (*.md README* LICENSE* CHANGELOG*) do (
    if exist "%%f" (
        copy "%%f" "%BACKUP_DIR%\" >nul 2>&1
        echo [BACKED UP] %%f
    )
)

goto BACKUP_COMPLETE

:FULL_BACKUP
echo.
echo ===============================================================================
echo                              FULL BACKUP
echo ===============================================================================
echo.

REM Create backup directory
echo [STEP 1] Creating backup directory...
if not exist "%BACKUP_BASE_DIR%" mkdir "%BACKUP_BASE_DIR%"
mkdir "%BACKUP_DIR%"
echo [SUCCESS] Backup directory created.
echo.

REM Backup all files
echo [STEP 2] Backing up all project files...

REM Backup batch scripts
echo [INFO] Backing up batch scripts...
mkdir "%BACKUP_DIR%\scripts"
for %%f in (*.bat) do (
    copy "%%f" "%BACKUP_DIR%\scripts\" >nul 2>&1
    echo [BACKED UP] %%f
)

REM Backup configuration files
echo [INFO] Backing up configuration files...
mkdir "%BACKUP_DIR%\config"
for %%f in (*.json *.txt *.csv *.xml *.ini *.cfg) do (
    copy "%%f" "%BACKUP_DIR%\config\" >nul 2>&1
    echo [BACKED UP] %%f
)

REM Backup documentation and text files
echo [INFO] Backing up documentation...
for %%f in (*.md *.rst *.doc *.docx *.pdf) do (
    if exist "%%f" (
        copy "%%f" "%BACKUP_DIR%\" >nul 2>&1
        echo [BACKED UP] %%f
    )
)

REM Backup directories
echo [INFO] Backing up directories...
if exist "src" (
    xcopy "src" "%BACKUP_DIR%\src" /e /i /q >nul 2>&1
    echo [BACKED UP] src folder
)

if exist "docs" (
    xcopy "docs" "%BACKUP_DIR%\docs" /e /i /q >nul 2>&1
    echo [BACKED UP] docs folder
)

if exist "public" (
    xcopy "public" "%BACKUP_DIR%\public" /e /i /q >nul 2>&1
    echo [BACKED UP] public folder
)

if exist "tests" (
    xcopy "tests" "%BACKUP_DIR%\tests" /e /i /q >nul 2>&1
    echo [BACKED UP] tests folder
)

if exist "data" (
    xcopy "data" "%BACKUP_DIR%\data" /e /i /q >nul 2>&1
    echo [BACKED UP] data folder
)

if exist "models" (
    xcopy "models" "%BACKUP_DIR%\models" /e /i /q >nul 2>&1
    echo [BACKED UP] models folder
)

if exist "logs" (
    xcopy "logs" "%BACKUP_DIR%\logs" /e /i /q >nul 2>&1
    echo [BACKED UP] logs folder
)

goto BACKUP_COMPLETE

:CONFIG_BACKUP
echo.
echo ===============================================================================
echo                           CONFIGURATION BACKUP
echo ===============================================================================
echo.

REM Create backup directory
echo [STEP 1] Creating backup directory...
if not exist "%BACKUP_BASE_DIR%" mkdir "%BACKUP_BASE_DIR%"
mkdir "%BACKUP_DIR%"
echo [SUCCESS] Backup directory created.
echo.

REM Backup configuration files
echo [STEP 2] Backing up configuration files...
mkdir "%BACKUP_DIR%\config"

for %%f in (*.json *.xml *.ini *.cfg *.config *.yaml *.yml) do (
    if exist "%%f" (
        copy "%%f" "%BACKUP_DIR%\config\" >nul 2>&1
        echo [BACKED UP] %%f
    )
)

if exist "config" (
    xcopy "config" "%BACKUP_DIR%\config\system" /e /i /q >nul 2>&1
    echo [BACKED UP] config folder
)

goto BACKUP_COMPLETE

:DATA_BACKUP
echo.
echo ===============================================================================
echo                              DATA BACKUP
echo ===============================================================================
echo.

REM Create backup directory
echo [STEP 1] Creating backup directory...
if not exist "%BACKUP_BASE_DIR%" mkdir "%BACKUP_BASE_DIR%"
mkdir "%BACKUP_DIR%"
echo [SUCCESS] Backup directory created.
echo.

REM Backup data files
echo [STEP 2] Backing up data files...

REM Backup conversation logs
if exist "HOTSPOT_CHAT_LOG.txt" (
    copy "HOTSPOT_CHAT_LOG.txt" "%BACKUP_DIR%\" >nul 2>&1
    echo [BACKED UP] HOTSPOT_CHAT_LOG.txt
)

REM Backup session data
if exist "HOTSPOT_CHAT_SESSION.json" (
    copy "HOTSPOT_CHAT_SESSION.json" "%BACKUP_DIR%\" >nul 2>&1
    echo [BACKED UP] HOTSPOT_CHAT_SESSION.json
)

REM Backup training data
for %%f in (*TRAINING* *training* *.csv *.data) do (
    if exist "%%f" (
        copy "%%f" "%BACKUP_DIR%\" >nul 2>&1
        echo [BACKED UP] %%f
    )
)

REM Backup data directories
if exist "data" (
    xcopy "data" "%BACKUP_DIR%\data" /e /i /q >nul 2>&1
    echo [BACKED UP] data folder
)

if exist "conversations" (
    xcopy "conversations" "%BACKUP_DIR%\conversations" /e /i /q >nul 2>&1
    echo [BACKED UP] conversations folder
)

if exist "training" (
    xcopy "training" "%BACKUP_DIR%\training" /e /i /q >nul 2>&1
    echo [BACKED UP] training folder
)

goto BACKUP_COMPLETE

:SYSTEM_BACKUP
echo.
echo ===============================================================================
echo                             SYSTEM BACKUP
echo ===============================================================================
echo.
echo [WARNING] This will create a complete backup of the entire HOTSPOT system.
echo [WARNING] This may take several minutes and require significant disk space.
echo.
set /p "CONFIRM_SYSTEM=Continue with system backup? (Y/N): "
if /i "%CONFIRM_SYSTEM%" neq "Y" (
    echo [INFO] System backup cancelled.
    goto BACKUP_MENU
)

REM Create backup directory
echo [STEP 1] Creating backup directory...
if not exist "%BACKUP_BASE_DIR%" mkdir "%BACKUP_BASE_DIR%"
mkdir "%BACKUP_DIR%"
echo [SUCCESS] Backup directory created.
echo.

REM Backup entire project directory
echo [STEP 2] Creating complete system backup...
echo [INFO] This may take several minutes...

REM Exclude certain directories to avoid recursion and unnecessary files
echo [INFO] Backing up project files (excluding backups and temp files)...
xcopy "%PROJECT_ROOT%*" "%BACKUP_DIR%\" /e /i /q /exclude:%TEMP%\backup_exclude.txt >nul 2>&1

REM Create exclusion list for xcopy
(
echo backups\
echo temp\
echo .git\
echo node_modules\
echo __pycache__\
echo *.tmp
echo *.temp
echo *.log
) > "%TEMP%\backup_exclude.txt"

REM Manual copy with exclusions
robocopy "%PROJECT_ROOT%" "%BACKUP_DIR%" /E /XD "backups" "temp" ".git" "node_modules" "__pycache__" /XF "*.tmp" "*.temp" /NFL /NDL /NJH /NJS /nc /ns /np >nul 2>&1

echo [SUCCESS] System backup completed.

REM Clean up exclusion file
del "%TEMP%\backup_exclude.txt" 2>nul

goto BACKUP_COMPLETE

:RESTORE_BACKUP
echo.
echo ===============================================================================
echo                            RESTORE FROM BACKUP
echo ===============================================================================
echo.

REM List available backups
if not exist "%BACKUP_BASE_DIR%" (
    echo [ERROR] No backups directory found.
    echo [INFO] No backups available to restore.
    goto BACKUP_MENU
)

echo Available backups:
echo.
set "BACKUP_COUNT=0"
for /d %%d in ("%BACKUP_BASE_DIR%\backup_*") do (
    set /a BACKUP_COUNT+=1
    echo !BACKUP_COUNT!. %%~nd
)

if %BACKUP_COUNT% equ 0 (
    echo [INFO] No backups found.
    goto BACKUP_MENU
)

echo.
set /p "RESTORE_CHOICE=Select backup to restore (1-%BACKUP_COUNT%) or 0 to cancel: "

if "%RESTORE_CHOICE%"=="0" goto BACKUP_MENU

REM Get selected backup directory
set "SELECTED_BACKUP="
set "CURRENT_COUNT=0"
for /d %%d in ("%BACKUP_BASE_DIR%\backup_*") do (
    set /a CURRENT_COUNT+=1
    if !CURRENT_COUNT! equ %RESTORE_CHOICE% (
        set "SELECTED_BACKUP=%%d"
    )
)

if "%SELECTED_BACKUP%"=="" (
    echo [ERROR] Invalid backup selection.
    goto BACKUP_MENU
)

echo.
echo [WARNING] This will restore from: %SELECTED_BACKUP%
echo [WARNING] Current files may be overwritten.
set /p "CONFIRM_RESTORE=Continue with restore? (Y/N): "
if /i "%CONFIRM_RESTORE%" neq "Y" (
    echo [INFO] Restore cancelled.
    goto BACKUP_MENU
)

echo.
echo [INFO] Restoring from backup...
xcopy "%SELECTED_BACKUP%\*" "%PROJECT_ROOT%" /e /i /q /y >nul 2>&1
echo [SUCCESS] Restore completed.

goto BACKUP_MENU

:LIST_BACKUPS
echo.
echo ===============================================================================
echo                           AVAILABLE BACKUPS
echo ===============================================================================
echo.

if not exist "%BACKUP_BASE_DIR%" (
    echo [INFO] No backups directory found.
    goto BACKUP_MENU
)

echo Backup Directory: %BACKUP_BASE_DIR%
echo.

set "BACKUP_COUNT=0"
for /d %%d in ("%BACKUP_BASE_DIR%\backup_*") do (
    set /a BACKUP_COUNT+=1
    echo Backup !BACKUP_COUNT!:
    echo   Directory: %%~nd
    echo   Path: %%d
    if exist "%%d\backup_info.txt" (
        echo   Info:
        type "%%d\backup_info.txt" | findstr /r ".*" | for /l %%i in (1,1,3) do (
            set /p line=
            echo     !line!
        )
    )
    echo   Size: 
    powershell -command "(Get-ChildItem '%%d' -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB" 2>nul | findstr /r "[0-9]" > temp_size.txt
    set /p BACKUP_SIZE=<temp_size.txt
    echo     !BACKUP_SIZE! MB (approximate)
    del temp_size.txt 2>nul
    echo.
)

if %BACKUP_COUNT% equ 0 (
    echo [INFO] No backups found.
)

echo Total backups: %BACKUP_COUNT%
echo.
pause
goto BACKUP_MENU

:CLEANUP_BACKUPS
echo.
echo ===============================================================================
echo                           CLEANUP OLD BACKUPS
echo ===============================================================================
echo.

if not exist "%BACKUP_BASE_DIR%" (
    echo [INFO] No backups directory found.
    goto BACKUP_MENU
)

echo [INFO] Analyzing backup directory...
echo.

set "BACKUP_COUNT=0"
for /d %%d in ("%BACKUP_BASE_DIR%\backup_*") do (
    set /a BACKUP_COUNT+=1
)

echo Found %BACKUP_COUNT% backup(s).

if %BACKUP_COUNT% leq 5 (
    echo [INFO] 5 or fewer backups found. No cleanup needed.
    goto BACKUP_MENU
)

echo.
echo Cleanup options:
echo 1. Keep last 5 backups (delete older)
echo 2. Keep last 10 backups (delete older)
echo 3. Delete backups older than 30 days
echo 4. Delete all backups (DANGEROUS!)
echo 5. Cancel
echo.
set /p "CLEANUP_CHOICE=Select cleanup option (1-5): "

if "%CLEANUP_CHOICE%"=="5" goto BACKUP_MENU
if "%CLEANUP_CHOICE%"=="1" set "KEEP_COUNT=5" & goto CLEANUP_BY_COUNT
if "%CLEANUP_CHOICE%"=="2" set "KEEP_COUNT=10" & goto CLEANUP_BY_COUNT
if "%CLEANUP_CHOICE%"=="3" goto CLEANUP_BY_DATE
if "%CLEANUP_CHOICE%"=="4" goto CLEANUP_ALL

echo [ERROR] Invalid choice.
goto BACKUP_MENU

:CLEANUP_BY_COUNT
echo.
echo [WARNING] This will keep the %KEEP_COUNT% most recent backups and delete the rest.
set /p "CONFIRM_CLEANUP=Continue? (Y/N): "
if /i "%CONFIRM_CLEANUP%" neq "Y" goto BACKUP_MENU

echo [INFO] Keeping %KEEP_COUNT% most recent backups...
set "DELETE_COUNT=0"
set "CURRENT_COUNT=0"

REM Count total backups first
for /d %%d in ("%BACKUP_BASE_DIR%\backup_*") do (
    set /a CURRENT_COUNT+=1
)

REM Calculate how many to delete
set /a DELETE_COUNT=!CURRENT_COUNT!-!KEEP_COUNT!

if !DELETE_COUNT! leq 0 (
    echo [INFO] No backups need to be deleted.
    goto BACKUP_MENU
)

echo [INFO] Deleting !DELETE_COUNT! old backup(s)...

REM Delete oldest backups
set "PROCESSED=0"
for /f "delims=" %%d in ('dir "%BACKUP_BASE_DIR%\backup_*" /b /ad /od') do (
    set /a PROCESSED+=1
    if !PROCESSED! leq !DELETE_COUNT! (
        echo [DELETING] %%d
        rmdir /s /q "%BACKUP_BASE_DIR%\%%d" 2>nul
    )
)

echo [SUCCESS] Cleanup completed.
goto BACKUP_MENU

:CLEANUP_BY_DATE
echo.
echo [WARNING] This will delete backups older than 30 days.
set /p "CONFIRM_DATE_CLEANUP=Continue? (Y/N): "
if /i "%CONFIRM_DATE_CLEANUP%" neq "Y" goto BACKUP_MENU

echo [INFO] Deleting backups older than 30 days...
forfiles /p "%BACKUP_BASE_DIR%" /m backup_* /d -30 /c "cmd /c echo [DELETING] @file && rmdir /s /q @path" 2>nul

echo [SUCCESS] Date-based cleanup completed.
goto BACKUP_MENU

:CLEANUP_ALL
echo.
echo [DANGER] This will DELETE ALL BACKUPS permanently!
echo [DANGER] This action cannot be undone!
set /p "CONFIRM_DELETE_ALL=Type 'DELETE ALL' to confirm: "
if /i "%CONFIRM_DELETE_ALL%" neq "DELETE ALL" (
    echo [INFO] Cleanup cancelled.
    goto BACKUP_MENU
)

echo [INFO] Deleting all backups...
rmdir /s /q "%BACKUP_BASE_DIR%" 2>nul
echo [SUCCESS] All backups deleted.
goto BACKUP_MENU

:BACKUP_COMPLETE
echo.
echo [STEP 3] Creating backup information...

REM Create backup info file
set "BACKUP_INFO=%BACKUP_DIR%\backup_info.txt"
(
echo HOTSPOT Backup Information
echo Backup Type: %BACKUP_CHOICE%
echo Backup Date: %BACKUP_DATE%
echo Backup Time: %BACKUP_TIME%
echo Project Root: %PROJECT_ROOT%
echo Backup Size: [Calculated at restore time]
echo.
echo Files Backed Up:
dir "%BACKUP_DIR%" /s /b | find /c /v "" > temp_count.txt
set /p FILE_COUNT=<temp_count.txt
echo   Total Files: !FILE_COUNT!
del temp_count.txt 2>nul
echo.
echo Backup completed successfully at %TIME%
) > "%BACKUP_INFO%"

echo [SUCCESS] Backup information file created.
echo.

REM Create ZIP archive of backup
echo [STEP 4] Creating backup archive...
set "ARCHIVE_NAME=backup_%BACKUP_TIMESTAMP%.zip"
set "ARCHIVE_PATH=%BACKUP_BASE_DIR%\%ARCHIVE_NAME%"

powershell -command "Compress-Archive -Path '%BACKUP_DIR%\*' -DestinationPath '%ARCHIVE_PATH%' -Force" 2>nul
if %errorlevel% equ 0 (
    echo [SUCCESS] Backup archive created: %ARCHIVE_NAME%
    
    REM Ask if user wants to delete uncompressed backup
    set /p "DELETE_UNCOMPRESSED=Delete uncompressed backup folder? (Y/N): "
    if /i "!DELETE_UNCOMPRESSED!"=="Y" (
        rmdir /s /q "%BACKUP_DIR%" 2>nul
        echo [INFO] Uncompressed backup folder deleted.
    )
) else (
    echo [WARNING] Failed to create backup archive. Backup folder preserved.
)

echo.
echo ===============================================================================
echo                          BACKUP COMPLETED SUCCESSFULLY!
echo ===============================================================================
echo.
echo Backup Information:
echo   Timestamp: %BACKUP_TIMESTAMP%
echo   Location: %BACKUP_DIR%
if exist "%ARCHIVE_PATH%" (
    echo   Archive: %ARCHIVE_NAME%
)
echo   Type: %BACKUP_CHOICE%
echo.
echo [INFO] Backup files are saved in: %BACKUP_BASE_DIR%
echo.

REM Ask if user wants to open backup directory
set /p "OPEN_BACKUP=Open backup directory? (Y/N): "
if /i "%OPEN_BACKUP%"=="Y" (
    explorer "%BACKUP_BASE_DIR%"
)

echo.
pause
goto BACKUP_MENU

:EXIT_SCRIPT
echo.
echo [INFO] HOTSPOT Backup Manager closing...
echo [INFO] All backup operations completed.
echo.
pause
exit /b 0
