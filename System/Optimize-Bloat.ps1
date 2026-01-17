<#
.SYNOPSIS
    Deep Bloatware Cleanup (Services & Tasks)
    Targets: Xbox, Phone, Maps, RetailDemo, MiniTool
#>
Write-Host "=== DEEP SYSTEM CLEANUP (BLOATWARE) ===" -ForegroundColor Cyan

# 1. MiniTool Partition Wizard (Scheduled Task)
$MiniToolTask = Get-ScheduledTask -TaskName "MiniToolPartitionWizard" -ErrorAction SilentlyContinue
if ($MiniToolTask) {
    Unregister-ScheduledTask -TaskName "MiniToolPartitionWizard" -Confirm:$false -ErrorAction SilentlyContinue
    Write-Host "🗑️ Task 'MiniToolPartitionWizard' deleted." -ForegroundColor Yellow
}

# 2. Services to Disable (Based on User Choice: No Xbox, No Phone)
$ServicesToDisable = @(
    "PhoneSvc",             # Phone Link
    "MapsBroker",           # Downloaded Maps Manager
    "RetailDemo",           # Retail Demo Service
    "XblAuthManager",       # Xbox Live Auth Manager
    "XblGameSave",          # Xbox Live Game Save
    "XboxNetApiSvc",        # Xbox Live Networking Service
    "XboxGipSvc"            # Xbox Accessory Management
)

foreach ($Name in $ServicesToDisable) {
    if (Get-Service -Name $Name -ErrorAction SilentlyContinue) {
        Stop-Service -Name $Name -Force -ErrorAction SilentlyContinue
        Set-Service -Name $Name -StartupType Disabled -ErrorAction SilentlyContinue
        Write-Host "🚫 Service '$Name' disabled." -ForegroundColor Yellow
    }
}

# 3. Printer Spooler (Optimization: Manual Start)
# User uses it "occasionally", so Manual is better than Automatic.
if (Get-Service -Name "Spooler" -ErrorAction SilentlyContinue) {
    Set-Service -Name "Spooler" -StartupType Manual -ErrorAction SilentlyContinue
    Write-Host "🖨️ Printer Spooler set to MANUAL (Starts only when needed)." -ForegroundColor Green
}

Write-Host "✅ Bloatware cleanup completed." -ForegroundColor Green
