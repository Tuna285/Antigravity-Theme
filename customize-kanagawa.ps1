<#
.SYNOPSIS
  Quickly customize Kanagawa wallpaper (or disable it), colors/preset, and both avatars, then hot-reload Antigravity.
  Tuy bien nhanh hinh nen (hoac tat hinh nen), bang mau/preset va ca 2 avatar cho Kanagawa theme roi hot-reload ngay.
#>
param(
    [string]$Preset,
    [string]$Wallpaper,
    [string]$WallpaperPosition,
    [string]$UserAvatar,
    [string]$AgentAvatar,
    [string]$DarkPrimary,
    [string]$DarkBlue,
    [string]$DarkAqua,
    [string]$DarkSurface,
    [string]$LightPrimary,
    [switch]$PickWallpaper,
    [switch]$NoWallpaper,
    [switch]$PickUserAvatar,
    [switch]$PickAgentAvatar,
    [switch]$Menu,
    [switch]$NoReload
)

$ErrorActionPreference = "Stop"
$RepoRoot = $PSScriptRoot
$ApplyScript = Join-Path $RepoRoot "scripts\apply_kanagawa_config.js"
$SwitchScript = Join-Path $RepoRoot "switch-theme.ps1"

function Pick-ImageFile {
    param([string]$Title)
    Add-Type -AssemblyName System.Windows.Forms
    $dlg = New-Object System.Windows.Forms.OpenFileDialog
    $dlg.Title = $Title
    $dlg.Filter = "Images (*.png;*.jpg;*.jpeg;*.webp;*.gif;*.svg;*.bmp)|*.png;*.jpg;*.jpeg;*.webp;*.gif;*.svg;*.bmp|All files (*.*)|*.*"
    if ($dlg.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        return $dlg.FileName
    }
    return $null
}

if ($PickWallpaper) {
    $picked = Pick-ImageFile "Choose Wallpaper / Chon hinh nen moi"
    if (-not $picked) { Write-Host "[kanagawa] Cancelled / Da huy."; exit 0 }
    $Wallpaper = $picked
}
if ($PickUserAvatar) {
    $picked = Pick-ImageFile "Choose User Avatar / Chon Avatar User"
    if (-not $picked) { Write-Host "[kanagawa] Cancelled / Da huy."; exit 0 }
    $UserAvatar = $picked
}
if ($PickAgentAvatar) {
    $picked = Pick-ImageFile "Choose Agent/Gemini Avatar / Chon Avatar Agent"
    if (-not $picked) { Write-Host "[kanagawa] Cancelled / Da huy."; exit 0 }
    $AgentAvatar = $picked
}

if ($Menu) {
    Write-Host ""
    Write-Host "=== Kanagawa Theme Customizer / Tuy bien theme ===" -ForegroundColor Cyan
    Write-Host "  [1] Doi hinh nen / Change Wallpaper (pick image)"
    Write-Host "  [2] Doi Avatar User / Change User Avatar (pick image)"
    Write-Host "  [3] Doi Avatar Agent / Change Agent Avatar (pick image)"
    Write-Host "  [4] Chon Preset mau / Choose Color Preset (12 themes)"
    Write-Host "  [5] Ap dung tu kanagawa.config.json / Apply from config & reload"
    Write-Host "  [6] Tat hinh nen / Disable Wallpaper (solid theme background)"
    Write-Host ""
    $choice = Read-Host "Select / Chon (1-6)"
    switch ($choice) {
        "1" {
            $Wallpaper = Pick-ImageFile "Choose Wallpaper / Chon hinh nen moi"
            if (-not $Wallpaper) { Write-Host "[kanagawa] Cancelled / Da huy."; exit 0 }
        }
        "2" {
            $UserAvatar = Pick-ImageFile "Choose User Avatar / Chon Avatar User"
            if (-not $UserAvatar) { Write-Host "[kanagawa] Cancelled / Da huy."; exit 0 }
        }
        "3" {
            $AgentAvatar = Pick-ImageFile "Choose Agent/Gemini Avatar / Chon Avatar Agent"
            if (-not $AgentAvatar) { Write-Host "[kanagawa] Cancelled / Da huy."; exit 0 }
        }
        "4" {
            $allPresets = @(
                "kanagawa-wave", "kanagawa-dragon", "sakura-dusk", "midnight-aqua",
                "catppuccin-mocha", "rose-pine", "tokyo-night", "nord-frost",
                "everforest", "gruvbox-warm", "vesper-minimal", "oxocarbon"
            )
            Write-Host ""
            for ($idx = 0; $idx -lt $allPresets.Count; $idx++) {
                Write-Host ("  [{0,2}] {1}" -f ($idx + 1), $allPresets[$idx])
            }
            Write-Host ""
            $pick = (Read-Host "Select number (1-$($allPresets.Count)) or preset name / Chon so hoac nhap ten").Trim()
            if (-not $pick) { Write-Host "[kanagawa] Cancelled / Da huy."; exit 0 }
            if ($pick -match '^\d+$' -and [int]$pick -ge 1 -and [int]$pick -le $allPresets.Count) {
                $Preset = $allPresets[[int]$pick - 1]
            } else {
                $Preset = $pick
            }
        }
        "5" { }
        "6" { $NoWallpaper = $true }
        default { Write-Host "Invalid choice / Lua chon khong hop le."; exit 1 }
    }
}

$nodeArgs = @($ApplyScript)
if ($Preset)            { $nodeArgs += @("--preset", $Preset) }
if ($NoWallpaper)       { $nodeArgs += "--no-wallpaper" }
elseif ($Wallpaper)     { $nodeArgs += @("--wallpaper", $Wallpaper) }
if ($WallpaperPosition) { $nodeArgs += @("--wallpaper-pos", $WallpaperPosition) }
if ($UserAvatar)        { $nodeArgs += @("--user-avatar", $UserAvatar) }
if ($AgentAvatar)       { $nodeArgs += @("--agent-avatar", $AgentAvatar) }
if ($DarkPrimary)       { $nodeArgs += @("--dark-primary", $DarkPrimary) }
if ($DarkBlue)          { $nodeArgs += @("--dark-blue", $DarkBlue) }
if ($DarkAqua)          { $nodeArgs += @("--dark-aqua", $DarkAqua) }
if ($DarkSurface)       { $nodeArgs += @("--dark-surface", $DarkSurface) }
if ($LightPrimary)      { $nodeArgs += @("--light-primary", $LightPrimary) }

& node @nodeArgs
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

if (-not $NoReload) {
    & $SwitchScript kanagawa
}
