<#
.SYNOPSIS
    Optimize Disk I/O & Filesystem
#>
Write-Host "=== OPTIMIZING DISK & FILESYSTEM ===" -ForegroundColor Cyan

# 1. Force TRIM (SSD Maintenance)
Write-Host "Executing TRIM on Drive C:..."
Optimize-Volume -DriveLetter C -ReTrim -Verbose

# 2. Disable 8.3 Name Creation (Legacy DOS compatibility, slows down NTFS)
Write-Host "Disabling 8.3 Names (Legacy)..."
fsutil behavior set disable8dot3 1

# 3. Disable Last Access Update (Reduces write overhead)
Write-Host "Disabling 'Last Access Time' updates..."
fsutil behavior set disablelastaccess 1

Write-Host "✅ Disk Optimized." -ForegroundColor Green
