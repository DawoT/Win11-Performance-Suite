<#
.SYNOPSIS
    Optimize Disk I/O & Filesystem
#>
Write-Host "=== OPTIMIZANDO DISCO Y SISTEMA DE ARCHIVOS ===" -ForegroundColor Cyan

# 1. Force TRIM (SSD Maintenance)
Write-Host "Ejecutando TRIM en Disco C:..."
Optimize-Volume -DriveLetter C -ReTrim -Verbose

# 2. Disable 8.3 Name Creation (Legacy DOS compatibility, slows down NTFS)
Write-Host "Desactivando nombres 8.3 (Legacy)..."
fsutil behavior set disable8dot3 1

# 3. Disable Last Access Update (Reduces write overhead)
Write-Host "Desactivando actualización de 'Last Access Time'..."
fsutil behavior set disablelastaccess 1

Write-Host "✅ Disco Optimizado." -ForegroundColor Green
