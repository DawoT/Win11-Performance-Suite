<#
.SYNOPSIS
    Singular Purge (Stateless)
    Execute, Clean, and Exit. Ideal for being called by Batch.
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
# Only compile if not exists (for speed)
if (-not ([System.Management.Automation.PSTypeName]'SysMem').Type) {
    Add-Type -TypeDefinition $Source
}

# QUICK LOGIC
$ls = Get-Process -Name "language_server_windows_x64"
if ($ls) {
    foreach ($p in $ls) {
        if (($p.WorkingSet64 / 1MB) -gt 350) {
            # Write-Host "Purging PID $($p.Id)..."
            [SysMem]::EmptyWorkingSet($p.Handle) | Out-Null
        }
    }
}
