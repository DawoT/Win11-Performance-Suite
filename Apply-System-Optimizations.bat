@echo off
TITLE Aplicando Optimizaciones Finales (Admin)
COLOR 0A

:: Check for Admin rights
net session >nul 2>&1
if %errorLevel% == 0 (
    echo [Admin Confirmado]
) else (
    echo Solicitando permisos de Administrador...
    powershell -Command "Start-Process '%~0' -Verb RunAs"
    exit
)

echo.
echo ===================================================
echo    OPTIMIZACION DE SISTEMA - APLICANDO CAMBIOS
echo ===================================================
echo.

echo [1/4] Limpiando Inicio y Fondo...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Cleanup-Startup.ps1"

echo.
echo [2/4] Optimizando Red (TCP/IP)...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Optimize-Network.ps1"

echo.
echo [3/4] Optimizando Disco (TRIM/FSUtil)...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Optimize-IO.ps1"

echo.
echo [4/4] Optimizando UI...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Optimize-UI.ps1"

echo.
echo ===================================================
echo    OPTIMIZACION COMPLETADA EXITOSAMENTE
echo ===================================================
echo.
echo Puedes cerrar esta ventana.
pause
