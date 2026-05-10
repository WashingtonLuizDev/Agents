# analyze-project.ps1
# Prepara um projeto EXISTENTE para análise com Claude Code
# Copia o CLAUDE-existing.md e os agents selecionados para o projeto
# Não cria nem altera estrutura de código — só adiciona o instrumental de análise
#
# Uso:
#   .\analyze-project.ps1
#   .\analyze-project.ps1 -ProjectPath "D:\Git\MeuProjeto" -Agents "tony,wall"

param(
    [string]$ProjectPath = "",
    [string]$Agents = ""
)

$AgentsRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$AgentsSource = Join-Path $AgentsRoot "..\Desenvolvimento de Software"
$TemplateFile = Join-Path $AgentsRoot "CLAUDE-existing.md"

# --- Coleta interativa ---

if (-not $ProjectPath) {
    $ProjectPath = Read-Host "Caminho do projeto existente"
    $ProjectPath = $ProjectPath.Trim('"')
}

if (-not (Test-Path $ProjectPath)) {
    Write-Error "Pasta nao encontrada: $ProjectPath"
    exit 1
}

$ProjectName = Split-Path -Leaf $ProjectPath

# Detectar stack automaticamente
$hasBackend  = (Get-ChildItem $ProjectPath -Recurse -Filter "*.csproj" -ErrorAction SilentlyContinue | Select-Object -First 1) -ne $null
$hasFrontend = (Get-ChildItem $ProjectPath -Recurse -Filter "angular.json" -ErrorAction SilentlyContinue | Select-Object -First 1) -ne $null
$hasSQL      = (Get-ChildItem $ProjectPath -Recurse -Include "*.sql","*.edmx" -ErrorAction SilentlyContinue | Select-Object -First 1) -ne $null

$detectedStack = if ($hasBackend -and $hasFrontend) { "Full Stack (.NET + Angular)" }
                 elseif ($hasBackend) { "Back-end .NET" }
                 elseif ($hasFrontend) { "Front-end Angular" }
                 else { "Nao identificado automaticamente" }

Write-Host ""
Write-Host "Projeto: $ProjectName"
Write-Host "Stack detectada: $detectedStack"

# Sugerir agents com base na deteccao
$suggestedAgents = @()
if ($hasBackend -or $hasFrontend) { $suggestedAgents += "tony" }
if ($hasFrontend)                  { $suggestedAgents += "wall" }
$suggestion = $suggestedAgents -join ","
if (-not $suggestion) { $suggestion = "tony" }

if (-not $Agents) {
    Write-Host ""
    Write-Host "Agents para analise (separar por virgula):"
    Write-Host "  tony         - Tony Stack (Dev Full Stack)"
    Write-Host "  scope        - Dr. Strange-Scope (Gerente de Projetos)"
    Write-Host "  wall         - Wall-UI (UX/UI + Angular)"
    Write-Host "  all          - Todos os agents"
    $Agents = Read-Host "Agents [sugerido: $suggestion]"
    if (-not $Agents) { $Agents = $suggestion }
}

# --- Mapa de agents ---
$agentMap = @{
    "tony"  = "tony-stack"
    "scope" = "dr-strange-scope"
    "wall"  = "wall-ui"
}

$selectedAgents = @()
if ($Agents -eq "all") {
    $selectedAgents = $agentMap.Values
} else {
    foreach ($a in ($Agents -split ",")) {
        $key = $a.Trim().ToLower()
        if ($agentMap.ContainsKey($key)) {
            $selectedAgents += $agentMap[$key]
        } else {
            Write-Warning "Agent '$key' nao reconhecido, ignorando."
        }
    }
}

# --- Verificar se ja existe CLAUDE.md no projeto ---
$existingClaude = Join-Path $ProjectPath "CLAUDE.md"
if (Test-Path $existingClaude) {
    Write-Host ""
    Write-Warning "CLAUDE.md ja existe no projeto."
    $overwrite = Read-Host "Sobrescrever? [s/N]"
    if ($overwrite.ToLower() -ne "s") {
        Write-Host "CLAUDE.md mantido sem alteracao."
        $skipClaude = $true
    }
}

# --- Criar pasta agents se nao existir ---
$agentsDir = Join-Path $ProjectPath "agents"
New-Item -ItemType Directory -Path $agentsDir -Force | Out-Null

# --- Copiar agents selecionados ---
foreach ($agent in $selectedAgents) {
    $src = Join-Path $AgentsSource $agent
    $dst = Join-Path $agentsDir $agent
    if (Test-Path $src) {
        Copy-Item -Path $src -Destination $dst -Recurse -Force
        Write-Host "  [OK] Agent copiado: $agent"
    } else {
        Write-Warning "  Agent nao encontrado em: $src"
    }
}

# --- Copiar e personalizar CLAUDE-existing.md ---
if (-not $skipClaude) {
    $claudeContent = Get-Content $TemplateFile -Raw

    $claudeContent = $claudeContent -replace "\[NOME DO PROJETO\]", $ProjectName
    $claudeContent = $claudeContent -replace "\[DATA\]", (Get-Date -Format "yyyy-MM-dd")
    $claudeContent = $claudeContent -replace "\[Full Stack / Back-end \.NET / Front-end Angular\]", $detectedStack

    # Descomentar @ dos agents selecionados
    foreach ($agent in $selectedAgents) {
        $claudeContent = $claudeContent -replace "<!-- @agents/$agent/agent\.md -->", "@agents/$agent/agent.md"
    }

    $claudeContent | Set-Content $existingClaude -Encoding UTF8
    Write-Host "  [OK] CLAUDE.md criado"
}

# --- Adicionar adaptações_necessarias.md como placeholder ---
$adaptFile = Join-Path $ProjectPath "adaptacoes_necessarias.md"
if (-not (Test-Path $adaptFile)) {
    @"
# Adaptações Necessárias — $ProjectName

> Gerado automaticamente em: $(Get-Date -Format "yyyy-MM-dd")
> Este arquivo será preenchido pelo Claude após análise do projeto.
> Para iniciar: abra o Claude Code neste projeto e diga **"analisar projeto"**.

---

*Análise pendente.*
"@ | Set-Content $adaptFile -Encoding UTF8
    Write-Host "  [OK] adaptacoes_necessarias.md criado (placeholder)"
}

# --- Resumo ---
Write-Host ""
Write-Host "Pronto! O projeto esta preparado para analise."
Write-Host "  Projeto:  $ProjectPath"
Write-Host "  Stack:    $detectedStack"
Write-Host "  Agents:   $($selectedAgents -join ', ')"
Write-Host ""
Write-Host "Proximo passo:"
Write-Host "  cd '$ProjectPath'"
Write-Host "  claude  # abrir Claude Code e dizer 'analisar projeto'"
