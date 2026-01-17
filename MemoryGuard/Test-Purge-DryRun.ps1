Write-Host "=== PURGE LOGIC DRY RUN ===" -ForegroundColor Cyan

# TARGET LIST (Same as Purge-Now.ps1)
$Targets = @(
    "language_server_windows_x64", 
    "chrome", "msedge", 
    "Code", "Discord", "Slack", "teams", 
    "java", "python", "node", "bun", "deno"
)

Write-Host "Scanning for: $Targets" -ForegroundColor Yellow

foreach ($Name in $Targets) {
    $processes = Get-Process -Name $Name -ErrorAction SilentlyContinue
    if ($processes) {
        foreach ($p in $processes) {
            $MB = [math]::Round($p.WorkingSet64 / 1MB, 2)
            $Action = if ($MB -gt 200) { "PURGE TARGETED 🎯" } else { "Skipped (<200MB)" }
            $Color = if ($MB -gt 200) { "Red" } else { "Green" }
            
            Write-Host "   Found: $($p.ProcessName) (PID: $($p.Id)) | RAM: $MB MB | Status: $Action" -ForegroundColor $Color
        }
    }
}
Write-Host "=== TEST COMPLETE ===" -ForegroundColor Cyan
