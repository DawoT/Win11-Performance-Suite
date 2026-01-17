@echo off
TITLE Applying Final Optimizations (Admin)
COLOR 0A

:: Check for Admin rights
net session >nul 2>&1
if %errorLevel% == 0 (
    echo [Admin Rights Verified]
) else (
    echo Requesting Administrator privileges...
    powershell -Command "Start-Process '%~0' -Verb RunAs"
    exit
)

echo.
echo ===================================================
echo    SYSTEM OPTIMIZATION - APPLYING CHANGES
echo ===================================================
echo.

echo [1/4] Cleaning Startup & Background...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0System\Cleanup-Startup.ps1"

echo.
echo [2/4] Optimizing Network (TCP/IP)...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0System\Optimize-Network.ps1"

echo.
echo [3/4] Optimizing Disk (TRIM/FSUtil)...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0System\Optimize-IO.ps1"

echo.
echo [4/4] Optimizing UI...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0System\Optimize-UI.ps1"

echo.
echo ===================================================
echo    OPTIMIZATION COMPLETED SUCCESSFULLY
echo ===================================================
echo.
echo You can close this window.
pause
