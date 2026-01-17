<#
.SYNOPSIS
    Singular Purge (Stateless)
    Se ejecuta, limpia y muere. Ideal para ser llamado por Batch.
#>

$ErrorActionPreference = "SilentlyContinue"

# CÓDIGO NATIVO
$Source = @"
using System;
using System.Runtime.InteropServices;
using System.Diagnostics;
public class SysMem {
    [DllImport("psapi.dll")] public static extern int EmptyWorkingSet(IntPtr hwProc);
}
"@
# Solo compilar si no existe (para velocidad)
if (-not ([System.Management.Automation.PSTypeName]'SysMem').Type) {
    Add-Type -TypeDefinition $Source
}

# LÓGICA RÁPIDA
$ls = Get-Process -Name "language_server_windows_x64"
if ($ls) {
    foreach ($p in $ls) {
        if (($p.WorkingSet64 / 1MB) -gt 350) {
            # Write-Host "Purgando PID $($p.Id)..."
            [SysMem]::EmptyWorkingSet($p.Handle) | Out-Null
        }
    }
}
