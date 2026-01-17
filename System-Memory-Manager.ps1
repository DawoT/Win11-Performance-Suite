<#
.SYNOPSIS
    System Memory Manager (Final Production Version)
    Based on Debug v3 - Proven to work.
#>

$CheckInterval = 2

# CÓDIGO NATIVO
$Source = @"
using System;
using System.Runtime.InteropServices;
using System.Diagnostics;

public class SysMem {
    [DllImport("psapi.dll", SetLastError=true)]
    public static extern int EmptyWorkingSet(IntPtr hwProc);
}
"@
# Silenciar output de Add-Type
Add-Type -TypeDefinition $Source -ErrorAction SilentlyContinue

# Prioridad Alta para asegurar ejecución
$curr = Get-Process -Id $PID
try { $curr.PriorityClass = [System.Diagnostics.ProcessPriorityClass]::High } catch {}

while ($true) {
    try {
        $ls = Get-Process -Name "language_server_windows_x64" -ErrorAction SilentlyContinue
        if ($ls) {
             foreach ($p in $ls) {
                # Umbral 250MB
                if (($p.WorkingSet64 / 1MB) -gt 250) {
                     [SysMem]::EmptyWorkingSet($p.Handle) | Out-Null
                }
             }
        }
    } catch {
        # Ignorar errores y seguir
    }
    
    Start-Sleep -Seconds $CheckInterval
}
