<#
.SYNOPSIS
    Optimize Network Stack via NetTCPSetting
#>
Write-Host "=== OPTIMIZING NETWORK & LATENCY ===" -ForegroundColor Cyan

# 1. TCP Autotuning (Critical for download speed)
# 'Normal' allows scale up. 'Disabled' kills speed.
Write-Host "Setting TCP Autotuning to 'Normal'..."
Set-NetTCPSetting -SettingName InternetCustom -AutoTuningLevelLocal Normal -ErrorAction SilentlyContinue
Set-NetTCPSetting -SettingName Internet -AutoTuningLevelLocal Normal -ErrorAction SilentlyContinue

# 2. Congestion Provider (CTCP is better for mixed networks)
Write-Host "Setting Congestion Algorithm (CUBIC/CTCP)..."
Set-NetTCPSetting -SettingName InternetCustom -CongestionProvider CUBIC -ErrorAction SilentlyContinue

# 3. DNS Cache optimization
Write-Host "Optimizing DNS Cache..."
Clear-DnsClientCache
# Note: Set-DnsClientCache might not exist on all Win11 SKUs or requires module. Using registry fallback if fails.
try {
    Set-DnsClientCache -MaxTtl 86400 -MaxNegativeTtl 5 -ErrorAction Stop
} catch {
    # Registry fallback
    $DnsPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters"
    If (!(Test-Path $DnsPath)) { New-Item $DnsPath -Force | Out-Null }
    Set-ItemProperty -Path $DnsPath -Name "MaxCacheTtl" -Value 86400 -Type DWord
    Set-ItemProperty -Path $DnsPath -Name "MaxNegativeCacheTtl" -Value 5 -Type DWord
}

Write-Host "✅ Network Optimized." -ForegroundColor Green
