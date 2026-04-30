param(
    [string]$Path = ".",
    [switch]$Recursive
)

$files = if ($Recursive) {
    Get-ChildItem -Path $Path -Filter *.png -Recurse
} else {
    Get-ChildItem -Path $Path -Filter *.png
}

if ($files.Count -eq 0) {
    Write-Host "No PNG files found in $Path" -ForegroundColor Yellow
    exit
}

Write-Host "`n================================================" -ForegroundColor Cyan
Write-Host "PNG Optimizer - oxipng (lossless)" -ForegroundColor Cyan
Write-Host "================================================`n" -ForegroundColor Cyan

$totalSaved = 0
$optimized = 0
$skipped = 0

foreach ($file in $files) {
    $sizeBefore = $file.Length
    Write-Host "[$($optimized + $skipped + 1)/$($files.Count)] $($file.Name)" -NoNewline
    
    # Run oxipng
    $result = & oxipng -o max -Z -a --strip safe $file.FullName 2>&1
    
    $sizeAfter = (Get-Item $file.FullName).Length
    $saved = $sizeBefore - $sizeAfter
    
    if ($saved -gt 0) {
        $savedKB = [math]::Round($saved / 1KB, 2)
        $percent = [math]::Round(($saved / $sizeBefore) * 100, 1)
        Write-Host " → Saved $savedKB KB ($percent%)" -ForegroundColor Green
        $totalSaved += $saved
        $optimized++
    } else {
        Write-Host " → Already optimal (skipped)" -ForegroundColor DarkGray
        $skipped++
    }
}

Write-Host "`n================================================" -ForegroundColor Cyan
Write-Host "Optimized: $optimized | Skipped: $skipped | Total saved: $([math]::Round($totalSaved / 1MB, 2)) MB" -ForegroundColor Green
Write-Host "================================================`n" -ForegroundColor Cyan
