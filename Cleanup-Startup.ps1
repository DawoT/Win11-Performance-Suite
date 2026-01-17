<#
.SYNOPSIS
    Cleanup Startup & Background Junk
#>
Write-Host "=== LIMPIEZA DE INICIO Y FONDO ===" -ForegroundColor Cyan

# 1. MiniTool Partition Wizard (Update Checker)
$MiniPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
if (Get-ItemProperty $MiniPath -Name "MTPWupdatechecker" -ErrorAction SilentlyContinue) {
    Remove-ItemProperty -Path $MiniPath -Name "MTPWupdatechecker" -ErrorAction SilentlyContinue
    Write-Host "🗑️ MiniTool Update Checker eliminado del inicio." -ForegroundColor Yellow
}

# 2. Edge Startup Boost & Background Extension
# Registry Policies for Edge
$EdgePath = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
if (!(Test-Path $EdgePath)) { New-Item -Path $EdgePath -Force | Out-Null }
Set-ItemProperty -Path $EdgePath -Name "StartupBoostEnabled" -Value 0 -Type DWord
Set-ItemProperty -Path $EdgePath -Name "BackgroundModeEnabled" -Value 0 -Type DWord
Write-Host "🚫 Edge Startup Boost & Background Mode desactivados." -ForegroundColor Yellow

# 3. Telemetry (DiagTrack)
Get-Service DiagTrack | Stop-Service -Force -ErrorAction SilentlyContinue
Set-Service DiagTrack -StartupType Disabled -ErrorAction SilentlyContinue
Write-Host "🕵️ Telemetría (DiagTrack) asegurada como Deshabilitada."

Write-Host "✅ Limpieza de Inicio completada." -ForegroundColor Green
