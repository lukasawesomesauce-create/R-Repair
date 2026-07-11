@echo off
setlocal EnableDelayedExpansion
title Repair Tool

:: ============================================
::  Admin check / confirmation
:: ============================================
net session >nul 2>&1
if "%errorlevel%"=="0" goto MENU

echo ==============================================
echo   This script REQUIRES ADMINISTRATOR privileges
echo ==============================================
echo.
set /p "ans=Do you want to continue and elevate to admin? (Y/N): "

if /i "%ans%"=="Y" (
    echo.
    echo Requesting administrator access...
    powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    if errorlevel 1 (
        echo.
        echo Elevation failed or was cancelled.
        pause
    )
    exit /b 0
)

echo.
echo Cancelled by user. Exiting...
pause
exit /b 0

:: ============================================
::  Menu ^(only reached when already running as admin^)
:: ============================================
:MENU
cls
echo ==============================================
echo               REPAIR TOOL MENU
echo ==============================================
echo.
echo  1. General Fix        ^(sfc /scannow^)
echo  2. File Explorer Fix  ^(restart explorer.exe^)
echo  3. Soon
echo  0. Exit
echo.
set /p "choice=Select an option: "

if "%choice%"=="1" goto GENERAL_FIX
if "%choice%"=="2" goto EXPLORER_FIX
if "%choice%"=="3" goto SOON
if "%choice%"=="0" goto END

echo Invalid selection.
pause
goto MENU

:GENERAL_FIX
cls
echo Running General Fix: sfc /scannow
echo This may take several minutes...
echo.
sfc /scannow
echo.
echo Done. Press any key to return to the menu.
pause >nul
goto MENU

:EXPLORER_FIX
cls
echo Running File Explorer Fix: restarting explorer.exe
taskkill /f /im explorer.exe
timeout /t 2 >nul
start explorer.exe
echo.
echo Done. Press any key to return to the menu.
pause >nul
goto MENU

:SOON
cls
echo This fix is coming soon.
echo.
pause >nul
goto MENU

:END
echo.
echo Exiting Repair Tool.
pause
exit /b 0
