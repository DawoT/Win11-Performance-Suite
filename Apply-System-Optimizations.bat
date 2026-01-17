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

echo [1/5] Cleaning Startup & Background...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0System\Cleanup-Startup.ps1"

echo.
echo [2/5] Removing Bloatware (Xbox, Phone, MiniTool)...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0System\Optimize-Bloat.ps1"

echo.
echo [3/5] Optimizing Network (TCP/IP)...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0System\Optimize-Network.ps1"

echo.
echo [4/5] Optimizing Disk (TRIM/FSUtil)...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0System\Optimize-IO.ps1"

echo.
echo [5/5] Optimizing UI...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0System\Optimize-UI.ps1"

echo.
echo ===================================================
echo    OPTIMIZATION COMPLETED SUCCESSFULLY
echo ===================================================
echo.
echo You can close this window.
pause
