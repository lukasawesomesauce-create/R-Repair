@echo off
setlocal EnableDelayedExpansion
title Repair Tool

:: ============================================
::  Admin check / confirmation
:: ============================================
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ==============================================
    echo   This script REQUIRES ADMINISTRATOR privileges
    echo ==============================================
    echo.
    choice /C YN /M "Do you want to continue and elevate to admin"
    if errorlevel 2 (
        echo.
        echo Cancelled by user. Exiting...
        timeout /t 2 >nul
        exit /b 0
    )
    if errorlevel 1 (
        echo.
        echo Requesting administrator access...
        powershell -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
        exit /b 0
    )
)

:: If we reach here, we ARE running as admin
:MENU
cls
echo ==============================================
echo               REPAIR TOOL MENU
echo ==============================================
echo.
echo  1. General Fix        (sfc /scannow)
echo  2. File Explorer Fix  (restart explorer.exe)
echo  3. Soon
echo  0. Exit
echo.
set /p choice="Select an option: "

if "%choice%"=="1" goto GENERAL_FIX
if "%choice%"=="2" goto EXPLORER_FIX
if "%choice%"=="3" goto SOON
if "%choice%"=="0" goto END
echo Invalid selection.
timeout /t 2 >nul
goto MENU

:GENERAL_FIX
cls
echo Running General Fix: sfc /scannow
echo This may take several minutes...
echo.
sfc /scannow
echo.
pause
goto MENU

:EXPLORER_FIX
cls
echo Running File Explorer Fix: restarting explorer.exe
taskkill /f /im explorer.exe
start explorer.exe
echo.
echo Done.
pause
goto MENU

:SOON
cls
echo This fix is coming soon.
echo.
pause
goto MENU

:END
echo.
echo Exiting Repair Tool.
timeout /t 2 >nul
exit /b 0
