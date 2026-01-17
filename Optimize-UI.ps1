<#
.SYNOPSIS
    Optimize UI Responsiveness
#>
Write-Host "=== OPTIMIZANDO RESPUESTA VISUAL (UI) ===" -ForegroundColor Cyan

# 1. MenuShowDelay (The classic registry tweak)
Write-Host "Eliminando retraso de menús (0ms)..."
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "MenuShowDelay" -Value "0" -Type String

# 2. MouseHoverTime (Faster tooltips)
Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseHoverTime" -Value "8" -Type String

# 3. Disable common animation delays via SystemParametersInfo (via Optimizer helper if available, or Registry)
# Doing registry approach for portability
$VisualPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"
if (!(Test-Path $VisualPath)) { New-Item -Path $VisualPath -Force | Out-Null }
Set-ItemProperty -Path $VisualPath -Name "VisualFXSetting" -Value 2 -Type DWord # 2 = Adjust for best performance (Custom)

Write-Host "✅ UI Optimizada. (Requiere reinicio de Explorer o Logoff para efecto total)" -ForegroundColor Green
