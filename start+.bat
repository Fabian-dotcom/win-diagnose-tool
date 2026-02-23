@echo off
title DIAGNOSE - STARTER

mkdir reports 2>nul
mkdir status 2>nul

:: Monitor-Fenster starten
start "DIAGNOSE MONITOR" powershell -NoExit -ExecutionPolicy Bypass -File monitor.ps1

:: Kurze Pause, damit Monitor bereit ist
timeout /t 1 >nul

:: Controller starten
call controller.bat