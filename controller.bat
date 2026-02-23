@echo off
title DIAGNOSE - CONTROLLER

:menu
cls
echo ============================
echo   SYSTEM DIAGNOSE TOOL
echo ============================
echo 1 - Komplettdiagnose
echo 2 - Nur RAM-Check
echo 3 - Nur Sicherheit
echo 4 - Beenden
echo.

set /p choice=Auswahl:

if "%choice%"=="1" goto full
if "%choice%"=="2" goto ram
if "%choice%"=="3" goto sec
if "%choice%"=="4" exit

goto menu

:full
echo START FULL > status\command.txt
goto wait

:ram
echo START RAM > status\command.txt
goto wait

:sec
echo START SECURITY > status\command.txt
goto wait

:wait
echo Befehl gesendet...
timeout /t 2 >nul
goto menu