<#
.SYNOPSIS
    System Memory Manager (Final Production Version)
    Based on Debug v3 - Proven to work.
#>

$CheckInterval = 2

# NATIVE CODE
$Source = @"
using System;
using System.Runtime.InteropServices;
using System.Diagnostics;

public class SysMem {
    [DllImport("psapi.dll", SetLastError=true)]
    public static extern int EmptyWorkingSet(IntPtr hwProc);
}
"@
# Silencing Add-Type output
Add-Type -TypeDefinition $Source -ErrorAction SilentlyContinue

# High Priority to ensure execution
$curr = Get-Process -Id $PID
try { $curr.PriorityClass = [System.Diagnostics.ProcessPriorityClass]::High } catch {}

while ($true) {
    try {
        $ls = Get-Process -Name "language_server_windows_x64" -ErrorAction SilentlyContinue
        if ($ls) {
             foreach ($p in $ls) {
                # Threshold 250MB
                if (($p.WorkingSet64 / 1MB) -gt 250) {
                     [SysMem]::EmptyWorkingSet($p.Handle) | Out-Null
                }
             }
        }
    } catch {
        # Ignore errors and continue
    }
    
    Start-Sleep -Seconds $CheckInterval
}
