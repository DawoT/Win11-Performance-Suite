$ScriptPath = "C:\Users\ewebp\Win11-Performance-Suite\Start-Hidden-Watchdog.vbs"
$TaskName = "AntigravityImmortalGuard"

Write-Host "Installing Immortal Guard (Invisible)..."

# 1. Cleanup
Unregister-ScheduledTask -TaskName "AntigravityMemoryPurge" -Confirm:$false -ErrorAction SilentlyContinue
Unregister-ScheduledTask -TaskName "SystemMemoryGuardian" -Confirm:$false -ErrorAction SilentlyContinue

# 2. Register Task (Executes wscript.exe with the .vbs)
$Action = New-ScheduledTaskAction -Execute "wscript.exe" -Argument "`"$ScriptPath`""
$Trigger = New-ScheduledTaskTrigger -AtLogOn
$Principal = New-ScheduledTaskPrincipal -UserId "$env:USERNAME" -LogonType Interactive -RunLevel Highest
$Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries

Register-ScheduledTask -TaskName $TaskName -Action $Action -Trigger $Trigger -Principal $Principal -Settings $Settings -Force

Write-Host "✅ Immortal Guard Installed."
Start-ScheduledTask -TaskName $TaskName
Write-Host "✅ Started."
