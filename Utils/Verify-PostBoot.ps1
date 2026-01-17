Write-Host "=== POST-BOOT SYSTEM DIAGNOSTIC ===" -ForegroundColor Cyan

# 1. CHECK WATCHDOG STATUS
Write-Host "`n[1] IMMORTAL WATCHDOG STATUS" -ForegroundColor Yellow
$Task = Get-ScheduledTask -TaskName "AntigravityImmortalGuard" -ErrorAction SilentlyContinue
if ($Task) {
    if ($Task.State -eq 'Running') {
        Write-Host "   Task State: $($Task.State)" -ForegroundColor Green
    } else {
        Write-Host "   Task State: $($Task.State)" -ForegroundColor Red
    }
} else {
    Write-Host "   Task NOT FOUND (Did you run Install-Immortal.ps1?)" -ForegroundColor Red
}

# Check for the actual process invisible chain (wscript -> cmd -> ping/powershell)
$Wscript = Get-Process wscript -ErrorAction SilentlyContinue
if ($Wscript) {
    Write-Host "   Background Host (wscript.exe): RUNNING" -ForegroundColor Green
} else {
    Write-Host "   Background Host: NOT RUNNING" -ForegroundColor Yellow
}

# 2. CHECK ANTIGRAVITY RAM
Write-Host "`n[2] ANTIGRAVITY MEMORY" -ForegroundColor Yellow
$LangServer = Get-Process "language_server_windows_x64" -ErrorAction SilentlyContinue
if ($LangServer) {
    $MB = [math]::Round($LangServer.WorkingSet64 / 1MB, 1)
    
    if ($MB -lt 300) {
        Write-Host "   PID: $($LangServer.Id)"
        Write-Host "   RAM Usage: $MB MB" -ForegroundColor Green
    } else {
        Write-Host "   PID: $($LangServer.Id)"
        Write-Host "   RAM Usage: $MB MB" -ForegroundColor Red
        Write-Host "   [!] WARNING: Watchdog might not be purging correct process." -ForegroundColor Red
    }
} else {
    Write-Host "   Process not found (Start VSCode/Antigravity to test)." -ForegroundColor Gray
}

# 3. CHECK BLOATWARE SERVICES
Write-Host "`n[3] BLOATWARE STATUS" -ForegroundColor Yellow
$Services = @("PhoneSvc", "MapsBroker", "RetailDemo", "XblAuthManager")
foreach ($s in $Services) {
    $svc = Get-Service -Name $s -ErrorAction SilentlyContinue
    if ($svc) {
        if ($svc.Status -eq 'Stopped') {
            Write-Host "   $s : $($svc.Status)" -ForegroundColor Green
        } else {
            Write-Host "   $s : $($svc.Status)" -ForegroundColor Red
        }
    }
}

# 4. CHECK NETWORK OPTIMIZATIONS
Write-Host "`n[4] NETWORK TUNING" -ForegroundColor Yellow
try {
    $Tcp = Get-NetTCPSetting -SettingName InternetCustom -ErrorAction SilentlyContinue
    if ($Tcp) {
        Write-Host "   AutoTuning: $($Tcp.AutoTuningLevelLocal)"
        Write-Host "   Congestion: $($Tcp.CongestionProvider)"
    } else {
        Write-Host "   Settings not found (Did you run Optimize-Network?)" -ForegroundColor Yellow
    }
} catch { Write-Host "   Error checking network: $_" }
