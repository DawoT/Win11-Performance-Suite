Write-Host "=== HARDWARE ACCELERATION AUDIT ===" -ForegroundColor Cyan

# 1. GPU SCHEDULING (HAGS)
Write-Host "`n[1] GPU Hardware Scheduling (HAGS)" -ForegroundColor Yellow
$HagsPath = "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers"
$Hags = Get-ItemProperty $HagsPath -Name "HwSchMode" -ErrorAction SilentlyContinue
if ($Hags.HwSchMode -eq 2) {
    Write-Host "   STATUS: ON (Excellent)" -ForegroundColor Green
} else {
    Write-Host "   STATUS: OFF or Disabled" -ForegroundColor Red
}

# 2. MSI MODE (Message Signaled Interrupts)
Write-Host "`n[2] NVIDIA MSI Mode Check" -ForegroundColor Yellow
try {
    $Nvidia = Get-PnpDevice -Class Display | Where-Object { $_.FriendlyName -like "*RTX*" -or $_.FriendlyName -like "*NVIDIA*" } | Select-Object -First 1
    
    if ($Nvidia) {
        Write-Host "   GPU Found: $($Nvidia.FriendlyName)"
        $Id = $Nvidia.InstanceId
        Write-Host "   Instance: $Id"
        
        $RegPath = "HKLM:\SYSTEM\CurrentControlSet\Enum\$Id\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties"
        
        if (Test-Path $RegPath) {
            $Msi = Get-ItemProperty -Path $RegPath -Name "MSISupported" -ErrorAction SilentlyContinue
            if ($Msi.MSISupported -eq 1) {
                Write-Host "   MSI Supported: ENABLED in Registry" -ForegroundColor Green
            } else {
                Write-Host "   MSI Supported: DISABLED or Not Set" -ForegroundColor Yellow
            }
        } else {
             Write-Host "   MSI Key not found (Defaulting to Legacy IRQ)" -ForegroundColor Yellow
        }
    } else {
        Write-Host "   NVIDIA GPU Not Found." -ForegroundColor Red
    }
} catch {
    Write-Host "   Error checking MSI: $_" -ForegroundColor Red
}

# 3. HPET
Write-Host "`n[3] Platform Clock (HPET)" -ForegroundColor Yellow
$bcd = bcdedit /enum
if ($bcd -match "useplatformclock.*Yes") {
    Write-Host "   HPET: FORCED ON (Bad for latency)" -ForegroundColor Red
} else {
    Write-Host "   HPET: OFF/Default (Good)" -ForegroundColor Green
}
