# Optimize PNG — Windows Context Menu

Adds a right-click "Optimize PNGs" option to folders in Windows Explorer, powered by [oxipng](https://github.com/oxipng/oxipng).

This repo is just the Windows shell integration and wrapper script — oxipng does the actual compression.

## What it does

- Right-click any folder → **Optimize PNGs** — runs lossless PNG optimization on all `.png` files in that folder
- Right-click inside a folder → **Optimize PNGs Here** — same, targets the current folder
- Shows per-file savings and total MB saved in a PowerShell window

## Prerequisites

**oxipng** must be installed and available in your `PATH`.

Install via winget:
```
winget install oxipng.oxipng
```

Or download a release binary from [github.com/oxipng/oxipng/releases](https://github.com/oxipng/oxipng/releases) and add it to your PATH manually.

## Install context menu

Run **as Administrator**:

```powershell
.\Install-OptimizePNGsMenu.ps1
```

The script auto-detects your oxipng location from PATH — no hardcoded paths.

## Manual use (no context menu)

```powershell
# Optimize PNGs in current folder
.\Optimize-PNGs.ps1

# Specific folder
.\Optimize-PNGs.ps1 -Path "C:\path\to\images"

# Recursive (all subfolders)
.\Optimize-PNGs.ps1 -Path "C:\path\to\images" -Recursive
```

## Uninstall

Delete these two registry keys:

```
HKEY_CLASSES_ROOT\Directory\shell\OptimizePNGs
HKEY_CLASSES_ROOT\Directory\Background\shell\OptimizePNGs
```

Or run in an elevated PowerShell:

```powershell
Remove-Item -Path "Registry::HKEY_CLASSES_ROOT\Directory\shell\OptimizePNGs" -Recurse -Force
Remove-Item -Path "Registry::HKEY_CLASSES_ROOT\Directory\Background\shell\OptimizePNGs" -Recurse -Force
```

## oxipng flags used

`oxipng -o max -Z -a --strip safe`

- `-o max` — maximum optimization level
- `-Z` — use zopfli for better compression (slower)
- `-a` — alpha channel optimization
- `--strip safe` — strip safe-to-remove metadata
