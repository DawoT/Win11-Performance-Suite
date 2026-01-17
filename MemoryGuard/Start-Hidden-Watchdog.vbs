Set WshShell = CreateObject("WScript.Shell") 
Set FSO = CreateObject("Scripting.FileSystemObject")
CurrentDir = FSO.GetParentFolderName(WScript.ScriptFullName)
WshShell.Run chr(34) & CurrentDir & "\Antigravity-Watchdog.bat" & Chr(34), 0
Set WshShell = Nothing
