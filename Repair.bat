@echo off
setlocal EnableDelayedExpansion
title Repair Tool
color 0A

REM ================================================
REM  Step 1: Check if running as administrator
REM ================================================
whoami /groups | find "S-1-16-12288" >nul 2>&1
if %errorlevel% equ 0 goto :ADMIN_OK

cls
echo ==================================================
echo    THIS SCRIPT REQUIRES ADMINISTRATOR PRIVILEGES
echo ==================================================
echo.
set "userAns="
set /p userAns=Continue and elevate to admin? Type Y or N and press Enter: 

if /i "%userAns%"=="Y" goto :ELEVATE
if /i "%userAns%"=="YES" goto :ELEVATE

echo.
echo You chose not to continue. Closing in 3 seconds...
timeout /t 3 >nul
exit /b 0

:ELEVATE
echo.
echo Requesting administrator access, please approve the prompt...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
echo.
echo If a UAC prompt appeared, approve it in the new window.
echo This window will now close.
timeout /t 3 >nul
exit /b 0

:ADMIN_OK
REM ================================================
REM  Step 2: Main menu (already elevated)
REM ================================================
:MENU
cls
echo ==================================================
echo                  REPAIR TOOL
echo            (Running as Administrator)
echo ==================================================
echo.
echo   1. General Fix        - sfc /scannow
echo   2. File Explorer Fix  - restart explorer.exe
echo   3. Soon
echo   0. Exit
echo.
set "menuChoice="
set /p menuChoice=Enter a number and press Enter: 

if "%menuChoice%"=="1" goto :GENERAL_FIX
if "%menuChoice%"=="2" goto :EXPLORER_FIX
if "%menuChoice%"=="3" goto :SOON
if "%menuChoice%"=="0" goto :QUIT

echo.
echo That's not a valid option, try again.
timeout /t 2 >nul
goto :MENU

:GENERAL_FIX
cls
echo ==================================================
echo   GENERAL FIX
echo ==================================================
echo Running: sfc /scannow
echo This scans and repairs protected system files.
echo It can take several minutes, please be patient.
echo.
sfc /scannow
echo.
echo --------------------------------------------------
echo Finished. Press any key to return to the menu.
pause >nul
goto :MENU

:EXPLORER_FIX
cls
echo ==================================================
echo   FILE EXPLORER FIX
echo ==================================================
echo Restarting Windows Explorer...
taskkill /f /im explorer.exe >nul 2>&1
timeout /t 2 >nul
start explorer.exe
echo.
echo Explorer has been restarted.
echo --------------------------------------------------
echo Press any key to return to the menu.
pause >nul
goto :MENU

:SOON
cls
echo ==================================================
echo   COMING SOON
echo ==================================================
echo This fix is not available yet. Check back later.
echo.
pause >nul
goto :MENU

:QUIT
cls
echo Thanks for using Repair Tool. Goodbye.
timeout /t 2 >nul
exit /b 0
