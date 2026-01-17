@echo off
TITLE Antigravity Immortal Watchdog
COLOR 0B

:LOOP
:: Execute SMART Adaptive Purge (Intelligent logic)
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Purge-Smart.ps1" >nul 2>&1

:: Wait 2 seconds (High frequency check, but script exits fast if Green Zone)
ping 127.0.0.1 -n 3 >nul

:: Repeat forever
GOTO LOOP
