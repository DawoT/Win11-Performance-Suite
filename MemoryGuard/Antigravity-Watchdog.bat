@echo off
TITLE Antigravity Immortal Watchdog
COLOR 0B

:LOOP
:: Execute quick purge (hidden, stateless)
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Purge-Now.ps1" >nul 2>&1

:: Wait 2 seconds (ping is the most compatible sleep in legacy cmd)
ping 127.0.0.1 -n 3 >nul

:: Repeat forever
GOTO LOOP
