<#
.SYNOPSIS
    Global System Purge (Wise Optimizer Clone)
    Trims Working Set of ALL eligible user processes.
    WARNING: May cause temporary lag while apps page back in.
#>

$ErrorActionPreference = "SilentlyContinue"

# NATIVE CODE
$Source = @"
using System;
using System.Runtime.InteropServices;
using System.Diagnostics;
public class SysMem {
    [DllImport("psapi.dll")] public static extern int EmptyWorkingSet(IntPtr hwProc);
}
"@
# Only compile if not exists
if (-not ([System.Management.Automation.PSTypeName]'SysMem').Type) {
    Add-Type -TypeDefinition $Source
}

Write-Host "=== INITIATING GLOBAL RAM PURGE ===" -ForegroundColor Cyan
$Before = (Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory
Write-Host "Free RAM (Before): $([math]::Round($Before/1KB, 0)) MB" -ForegroundColor Yellow

# 1. GET ALL PROCESSES EXCEPT CRITICAL SYSTEM
# We avoid PID 0, 4, and typical drivers to prevent instability
$Processes = Get-Process | Where-Object { 
    $_.Id -gt 4 -and 
    $_.ProcessName -notmatch "csrss|lsass|wininit|smss|Memory Compression|System"
}

$Count = 0
foreach ($p in $Processes) {
    try {
        # Only purge if it has > 10MB to be worth it
        if ($p.WorkingSet64 -gt 10MB) {
            [SysMem]::EmptyWorkingSet($p.Handle) | Out-Null
            $Count++
        }
    } catch {
        # Access denied is expected for System/Admin processes if not running as Admin
    }
}

$After = (Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory
$Freed = [math]::Round(($After - $Before)/1KB, 0)

Write-Host "✅ Purged $Count processes." -ForegroundColor Green
Write-Host "🎉 RAM Recovered: $Freed MB" -ForegroundColor Green
Write-Host "Free RAM (Now):    $([math]::Round($After/1KB, 0)) MB" -ForegroundColor Cyan
