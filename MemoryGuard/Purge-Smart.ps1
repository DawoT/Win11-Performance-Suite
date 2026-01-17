<#
.SYNOPSIS
    Smart Adaptive Memory Purge
    Logic:
    1. Always purge known LEAKY processes (Antigravity).
    2. GREEN ZONE (>4GB Free): Do nothing else. Relax.
    3. YELLOW ZONE (<4GB Free): Purge Background browsers/electron. PROTECT Active Window.
    4. RED ZONE (<2GB Free): Emergency Purge EVERYTHING except Active Window.
#>

$ErrorActionPreference = "SilentlyContinue"

# NATIVE CODE (Memory + Window Focus)
$Source = @"
using System;
using System.Runtime.InteropServices;
public class SysOps {
    [DllImport("psapi.dll")] public static extern int EmptyWorkingSet(IntPtr hwProc);
    [DllImport("user32.dll")] public static extern IntPtr GetForegroundWindow();
    [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr hWnd, out uint lpdwProcessId);
}
"@
if (-not ([System.Management.Automation.PSTypeName]'SysOps').Type) { Add-Type -TypeDefinition $Source }

# --- STATE DETECTION ---

# 1. Get Free RAM
$OS = Get-CimInstance Win32_OperatingSystem
$FreeMB = [math]::Round($OS.FreePhysicalMemory / 1024, 0)

# 2. Get Active User Window PID
$ActiveHwnd = [SysOps]::GetForegroundWindow()
$ActivePID = 0
[SysOps]::GetWindowThreadProcessId($ActiveHwnd, [ref]$ActivePID) | Out-Null
# (ActivePID is the app the user is looking at RIGHT NOW. NEVER TOUCH IT.)

# --- RULES ENGINE ---

# RULE 1: THE LEAKER (Always Purge Antigravity if > 250MB)
$Leaker = Get-Process -Name "language_server_windows_x64" -ErrorAction SilentlyContinue
if ($Leaker -and ($Leaker.WorkingSet64/1MB -gt 250)) {
    [SysOps]::EmptyWorkingSet($Leaker.Handle) | Out-Null
}

# RULE 2: ADAPTIVE ZONES
if ($FreeMB -gt 4000) {
    # GREEN ZONE: System is fine. Do nothing extra. No lags.
    exit
}

# Define targets for Yellow Zone (Browsers, Electron)
$BackgroundTargets = @("chrome", "msedge", "Code", "Discord", "Slack", "teams", "node", "java", "python")

if ($FreeMB -gt 2000) {
    # YELLOW ZONE (Between 2GB and 4GB)
    # Purge heavy background apps, but SKIP the active one.
    foreach ($name in $BackgroundTargets) {
        Get-Process -Name $name -ErrorAction SilentlyContinue | ForEach-Object {
            if (($_.Id -ne $ActivePID) -and ($_.WorkingSet64/1MB -gt 300)) {
                [SysOps]::EmptyWorkingSet($_.Handle) | Out-Null
            }
        }
    }
    exit
}

# RED ZONE (< 2GB Free)
# EMERGENCY: Purge everything eligible except Active Window and Drivers
Get-Process | Where-Object { 
    $_.Id -ne $ActivePID -and $_.Id -gt 4 -and
    $_.ProcessName -notmatch "csrss|lsass|wininit|smss|System" -and
    $_.WorkingSet64/1MB -gt 50
} | ForEach-Object {
    try { [SysOps]::EmptyWorkingSet($_.Handle) | Out-Null } catch {}
}
