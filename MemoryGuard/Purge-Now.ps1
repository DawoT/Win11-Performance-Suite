<#
.SYNOPSIS
    Singular Purge (Stateless)
    Execute, Clean, and Exit.
    Now supports MULTIPLE aggressive targets.
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

# TARGET LIST (Processes known to eat RAM)
# Add your targets here. Regex supported.
$Targets = @(
    "language_server_windows_x64", # Antigravity (The Main Villain)
    "chrome",                      # Google Chrome
    "msedge",                      # Microsoft Edge
    "Code",                        # VS Code (Electron)
    "Discord",                     # Discord (Electron)
    "Slack",                       # Slack (Electron)
    "teams",                       # MS Teams
    "java",                        # Minecraft/Servers
    "python",                      # AI Scripts
    "node",                        # Node.js
    "bun",                         # Bun Runtime
    "deno"                         # Deno Runtime
)

# PURGE LOOP
foreach ($Name in $Targets) {
    $processes = Get-Process -Name $Name -ErrorAction SilentlyContinue
    if ($processes) {
        foreach ($p in $processes) {
            # Only purge if consuming > 200MB to save CPU cycles
            if (($p.WorkingSet64 / 1MB) -gt 200) {
               [SysMem]::EmptyWorkingSet($p.Handle) | Out-Null
            }
        }
    }
}
