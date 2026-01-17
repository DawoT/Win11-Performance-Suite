<#
.SYNOPSIS
    Optimize Network Stack via NetTCPSetting
#>
Write-Host "=== OPTIMIZANDO RED Y LATENCIA ===" -ForegroundColor Cyan

# 1. TCP Autotuning (Critical for download speed)
# 'Normal' allows scale up. 'Disabled' kills speed.
Write-Host "Configurando TCP Autotuning a 'Normal'..."
Set-NetTCPSetting -SettingName InternetCustom -AutoTuningLevelLocal Normal -ErrorAction SilentlyContinue
Set-NetTCPSetting -SettingName Internet -AutoTuningLevelLocal Normal -ErrorAction SilentlyContinue

# 2. Congestion Provider (CTCP is better for mixed networks)
Write-Host "Configurando Algoritmo de Congestión (CUBIC/CTCP)..."
Set-NetTCPSetting -SettingName InternetCustom -CongestionProvider CUBIC -ErrorAction SilentlyContinue

# 3. DNS Cache optimization
Write-Host "Optimizando Caché DNS..."
Clear-DnsClientCache
Set-DnsClientCache -MaxTtl 86400 -MaxNegativeTtl 5 -ErrorAction SilentlyContinue

Write-Host "✅ Red Optimizada." -ForegroundColor Green
