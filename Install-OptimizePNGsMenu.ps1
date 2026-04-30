# Install-OptimizePNGsMenu.ps1
# Run as Administrator

$principal = New-Object Security.Principal.WindowsPrincipal(
    [Security.Principal.WindowsIdentity]::GetCurrent()
)
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Please run PowerShell as Administrator and try again." -ForegroundColor Yellow
    pause
    exit
}

# Auto-detect oxipng
$oxipngExe = (where.exe oxipng 2>$null | Select-Object -First 1)
if (-not $oxipngExe) {
    Write-Host "oxipng not found in PATH." -ForegroundColor Red
    Write-Host "Install from: https://github.com/oxipng/oxipng/releases" -ForegroundColor Yellow
    Write-Host "Then add it to your PATH and re-run this script." -ForegroundColor Yellow
    pause
    exit
}

$scriptPath = Join-Path $PSScriptRoot "Optimize-PNGs.ps1"

# Right-click ON folder
$folderKey = "Registry::HKEY_CLASSES_ROOT\Directory\shell\OptimizePNGs"
New-Item -Path $folderKey -Force | Out-Null
Set-ItemProperty -Path $folderKey -Name "(Default)" -Value "Optimize PNGs (oxipng)"
Set-ItemProperty -Path $folderKey -Name "Icon" -Value $oxipngExe

$folderCmd = "$folderKey\command"
New-Item -Path $folderCmd -Force | Out-Null
Set-ItemProperty -Path $folderCmd -Name "(Default)" -Value "powershell.exe -NoExit -ExecutionPolicy Bypass -Command `"& '$scriptPath' -Path '%V'`""

# Right-click INSIDE folder (background)
$bgKey = "Registry::HKEY_CLASSES_ROOT\Directory\Background\shell\OptimizePNGs"
New-Item -Path $bgKey -Force | Out-Null
Set-ItemProperty -Path $bgKey -Name "(Default)" -Value "Optimize PNGs Here (oxipng)"
Set-ItemProperty -Path $bgKey -Name "Icon" -Value $oxipngExe

$bgCmd = "$bgKey\command"
New-Item -Path $bgCmd -Force | Out-Null
Set-ItemProperty -Path $bgCmd -Name "(Default)" -Value "powershell.exe -NoExit -ExecutionPolicy Bypass -Command `"& '$scriptPath' -Path '%V'`""

Write-Host ""
Write-Host "✓ Context menu installed!" -ForegroundColor Green
Write-Host "  Right-click any folder or inside a folder to see 'Optimize PNGs'." -ForegroundColor Green
Write-Host "  oxipng found at: $oxipngExe" -ForegroundColor DarkGray
pause
