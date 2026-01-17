# Determine script location for robustness
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$TargetVbs = Join-Path $ScriptDir "Start-Hidden-Watchdog.vbs"
$TaskName = "AntigravityImmortalGuard"

Write-Host "Installing Immortal Guard (Invisible)..."
Write-Host "Target: $TargetVbs"

# 1. Cleanup
Unregister-ScheduledTask -TaskName "AntigravityMemoryPurge" -Confirm:$false -ErrorAction SilentlyContinue
Unregister-ScheduledTask -TaskName "SystemMemoryGuardian" -Confirm:$false -ErrorAction SilentlyContinue

# 2. Register Task (Executes wscript.exe with the .vbs)
if (Test-Path $TargetVbs) {
    $Action = New-ScheduledTaskAction -Execute "wscript.exe" -Argument "`"$TargetVbs`""
    $Trigger = New-ScheduledTaskTrigger -AtLogOn
    $Principal = New-ScheduledTaskPrincipal -UserId "$env:USERNAME" -LogonType Interactive -RunLevel Highest
    $Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries

    Register-ScheduledTask -TaskName $TaskName -Action $Action -Trigger $Trigger -Principal $Principal -Settings $Settings -Force

    Write-Host "✅ Immortal Guard Installed."
    Start-ScheduledTask -TaskName $TaskName
    Write-Host "✅ Started."
} else {
    Write-Host "❌ Error: Could not find Start-Hidden-Watchdog.vbs in $ScriptDir" -ForegroundColor Red
}
