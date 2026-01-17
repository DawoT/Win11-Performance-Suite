<#
.SYNOPSIS
    Optimize UI Responsiveness
#>
Write-Host "=== OPTIMIZING UI RESPONSIVENESS ===" -ForegroundColor Cyan

# 1. MenuShowDelay (The classic registry tweak)
Write-Host "Removing Menu Delay (0ms)..."
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "MenuShowDelay" -Value "0" -Type String

# 2. MouseHoverTime (Faster tooltips)
Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseHoverTime" -Value "8" -Type String

# 3. Disable common animation delays via SystemParametersInfo (via Optimizer helper if available, or Registry)
# Doing registry approach for portability
$VisualPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"
if (!(Test-Path $VisualPath)) { New-Item -Path $VisualPath -Force | Out-Null }
Set-ItemProperty -Path $VisualPath -Name "VisualFXSetting" -Value 2 -Type DWord # 2 = Adjust for best performance (Custom)

Write-Host "✅ UI Optimized. (Requires Explorer restart or Logoff related to take full effect)" -ForegroundColor Green
