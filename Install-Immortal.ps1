$ScriptPath = "C:\Users\ewebp\.gemini\Start-Hidden-Watchdog.vbs"
$TaskName = "AntigravityImmortalGuard"

Write-Host "Instalando Guardia Inmortal (Invisible)..."

# 1. Limpieza
Unregister-ScheduledTask -TaskName "AntigravityMemoryPurge" -Confirm:$false -ErrorAction SilentlyContinue
Unregister-ScheduledTask -TaskName "SystemMemoryGuardian" -Confirm:$false -ErrorAction SilentlyContinue

# 2. Registrar Tarea (Ejecuta wscript.exe con el .vbs)
$Action = New-ScheduledTaskAction -Execute "wscript.exe" -Argument "`"$ScriptPath`""
$Trigger = New-ScheduledTaskTrigger -AtLogOn
$Principal = New-ScheduledTaskPrincipal -UserId "$env:USERNAME" -LogonType Interactive -RunLevel Highest
$Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries

Register-ScheduledTask -TaskName $TaskName -Action $Action -Trigger $Trigger -Principal $Principal -Settings $Settings -Force

Write-Host "✅ Guardia Inmortal Instalado."
Start-ScheduledTask -TaskName $TaskName
Write-Host "✅ Iniciado."
