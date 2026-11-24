# Instala a status line do Claude Code (mesma configuração do PC de origem).
# Uso:  powershell -ExecutionPolicy Bypass -File .\install-statusline.ps1
#       (ou pwsh -File ./install-statusline.ps1 no Linux/macOS)

$ErrorActionPreference = 'Stop'

$claudeDir    = Join-Path $HOME '.claude'
$scriptPath   = Join-Path $claudeDir 'statusline-command.ps1'
$settingsPath = Join-Path $claudeDir 'settings.json'

New-Item -ItemType Directory -Force -Path $claudeDir | Out-Null

# ---------- 1. Script da status line ----------
$statusLineScript = @'
$raw = [Console]::In.ReadToEnd()
if (-not $raw -or $raw.Trim() -eq '') { exit 0 }

try {
    $json = $raw | ConvertFrom-Json
} catch {
    exit 0
}

$parts = @()

$model   = $json.model.display_name
$ctx     = $json.context_window.used_percentage
$five    = $json.rate_limits.five_hour.used_percentage
$week    = $json.rate_limits.seven_day.used_percentage
$cwd     = $json.workspace.current_dir
$vim     = $json.vim.mode
$effort  = $json.effort.level

# Current directory — show drive + last two segments to keep it readable
if ($cwd) {
    $segments = $cwd -replace '\\', '/' -split '/' | Where-Object { $_ -ne '' }
    if ($segments.Count -le 3) {
        $dir = $cwd
    } else {
        $drive = $segments[0]
        $tail  = ($segments[-2], $segments[-1]) -join "/"
        $dir   = "$drive/.../$tail"
    }
    $parts += $dir
}

# Model + optional effort level
if ($model) {
    $modelStr = $model
    if ($effort) { $modelStr += " [$effort]" }
    $parts += $modelStr
}

# Context window usage with a small visual bar (10 chars wide)
if ($null -ne $ctx) {
    $pct     = [math]::Round($ctx)
    $filled  = [math]::Round($pct / 10)
    $empty   = 10 - $filled
    $bar     = ('#' * $filled) + ('-' * $empty)
    $parts  += "ctx [$bar] $pct%"
}

# Rate limits (Claude.ai subscribers only — absent for API users)
if ($null -ne $five) { $parts += "5h $([math]::Round($five))%" }
if ($null -ne $week) { $parts += "7d $([math]::Round($week))%" }

# Vim mode when active
if ($vim) { $parts += "VIM:$vim" }

$parts -join "  |  "
'@

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[IO.File]::WriteAllText($scriptPath, $statusLineScript, $utf8NoBom)
Write-Host "Script gravado em: $scriptPath"

# ---------- 2. Comando (pwsh se existir, senão Windows PowerShell) ----------
$shell = if (Get-Command pwsh -ErrorAction SilentlyContinue) { 'pwsh' } else { 'powershell.exe' }
$command = "$shell -NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`""

# ---------- 3. Mescla no settings.json sem apagar o resto ----------
if (Test-Path $settingsPath) {
    Copy-Item $settingsPath "$settingsPath.bak" -Force
    $raw = Get-Content $settingsPath -Raw
    $settings = if ($raw -and $raw.Trim()) { $raw | ConvertFrom-Json } else { [pscustomobject]@{} }
    Write-Host "Backup criado: $settingsPath.bak"
} else {
    $settings = [pscustomobject]@{}
}

$statusLine = [pscustomobject]@{ type = 'command'; command = $command }
if ($settings.PSObject.Properties['statusLine']) {
    $settings.statusLine = $statusLine
} else {
    $settings | Add-Member -NotePropertyName statusLine -NotePropertyValue $statusLine
}

[IO.File]::WriteAllText($settingsPath, ($settings | ConvertTo-Json -Depth 20), $utf8NoBom)
Write-Host "settings.json atualizado: $settingsPath"
Write-Host "Pronto! Reinicie o Claude Code para ver a status line."
