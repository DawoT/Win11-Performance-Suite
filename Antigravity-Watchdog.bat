@echo off
TITLE Antigravity Immortal Watchdog
COLOR 0B

:LOOP
:: Ejecutar purga rápida (oculta, sin perfilado)
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Purge-Now.ps1" >nul 2>&1

:: Esperar 2 segundos (ping es el comando sleep más compatible y ligero en legacy cmd)
ping 127.0.0.1 -n 3 >nul

:: Repetir eternamente
GOTO LOOP
