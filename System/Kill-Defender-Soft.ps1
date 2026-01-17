<#
.SYNOPSIS
    Soft-Kill Windows Defender (Minimize Footprint)
    Note: Completely removing Defender requires Safe Mode or external tools.
    This script disables all aux features to reduce CPU/RAM usage to minimum.
#>
Write-Host "=== MINIMIZING DEFENDER FOOTPRINT ===" -ForegroundColor Cyan

# 1. Disable AntiSpyware (Group Policy Override)
$DefPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender"
if (!(Test-Path $DefPath)) { New-Item -Path $DefPath -Force | Out-Null }
Set-ItemProperty -Path $DefPath -Name "DisableAntiSpyware" -Value 1 -Type DWord -ErrorAction SilentlyContinue

# 2. Disable Real-Time Protection (Policy)
$RealTimePath = "$DefPath\Real-Time Protection"
if (!(Test-Path $RealTimePath)) { New-Item -Path $RealTimePath -Force | Out-Null }
Set-ItemProperty -Path $RealTimePath -Name "DisableRealtimeMonitoring" -Value 1 -Type DWord -ErrorAction SilentlyContinue

# 3. Disable SpyNet (Cloud Reporting)
$SpyNetPath = "$DefPath\Spynet"
if (!(Test-Path $SpyNetPath)) { New-Item -Path $SpyNetPath -Force | Out-Null }
Set-ItemProperty -Path $SpyNetPath -Name "SpyNetReporting" -Value 0 -Type DWord -ErrorAction SilentlyContinue
Set-ItemProperty -Path $SpyNetPath -Name "SubmitSamplesConsent" -Value 2 -Type DWord -ErrorAction SilentlyContinue

# 4. Disable SmartScreen (Reduces web filters)
$SmartScreenPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
if (!(Test-Path $SmartScreenPath)) { New-Item -Path $SmartScreenPath -Force | Out-Null }
Set-ItemProperty -Path $SmartScreenPath -Name "EnableSmartScreen" -Value 0 -Type DWord -ErrorAction SilentlyContinue

# 5. Stop Satellite Services (Network Inspection, Sense)
$SatelliteServices = @("WdNisSvc", "Sense", "WdBoot", "WdFilter")
foreach ($svc in $SatelliteServices) {
    if (Get-Service -Name $svc -ErrorAction SilentlyContinue) {
        Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
        Set-Service -Name $svc -StartupType Disabled -ErrorAction SilentlyContinue
        Write-Host "[-] Service '$svc' disabled." -ForegroundColor Yellow
    }
}

Write-Host "[+] Defender minimized. (Full removal requires Safe Mode/External Tools)" -ForegroundColor Green
Write-Host "[!] Please REBOOT to apply Policy changes." -ForegroundColor Cyan
