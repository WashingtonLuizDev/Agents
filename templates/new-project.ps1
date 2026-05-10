# new-project.ps1
# Cria a estrutura inicial de um novo projeto com agents e CLAUDE.md
#
# Uso:
#   .\new-project.ps1
#   .\new-project.ps1 -ProjectName "MeuProjeto" -Stack "fullstack" -Agents "tony,wall-ui"

param(
    [string]$ProjectName = "",
    [string]$Stack = "",
    [string]$Agents = "",
    [string]$OutputPath = ""
)

$AgentsRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$AgentsSource = Join-Path $AgentsRoot "..\Desenvolvimento de Software"
$TemplateFile = Join-Path $AgentsRoot "CLAUDE.md"

# --- Coleta interativa se parâmetros não foram passados ---

if (-not $ProjectName) {
    $ProjectName = Read-Host "Nome do projeto"
}

if (-not $Stack) {
    Write-Host ""
    Write-Host "Stack do projeto:"
    Write-Host "  1) Full Stack (.NET + Angular)"
    Write-Host "  2) So Back-end (.NET)"
    Write-Host "  3) So Front-end (Angular)"
    Write-Host "  4) Outro (estrutura basica)"
    $stackChoice = Read-Host "Escolha [1-4]"
    $Stack = switch ($stackChoice) {
        "1" { "fullstack" }
        "2" { "backend" }
        "3" { "frontend" }
        default { "basic" }
    }
}

if (-not $Agents) {
    Write-Host ""
    Write-Host "Agents necessarios (separar por virgula):"
    Write-Host "  tony         - Tony Stack (Dev Full Stack)"
    Write-Host "  scope        - Dr. Strange-Scope (Gerente de Projetos)"
    Write-Host "  wall         - Wall-UI (UX/UI + Angular)"
    Write-Host "  all          - Todos os agents"
    $Agents = Read-Host "Agents [ex: tony,wall ou all]"
}

if (-not $OutputPath) {
    $parent = Split-Path -Parent $AgentsRoot
    $OutputPath = Join-Path $parent $ProjectName
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

# --- Criar estrutura de pastas ---
Write-Host ""
Write-Host "Criando projeto '$ProjectName' em: $OutputPath"

New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
New-Item -ItemType Directory -Path "$OutputPath\agents" -Force | Out-Null
New-Item -ItemType Directory -Path "$OutputPath\docs" -Force | Out-Null

switch ($Stack) {
    "fullstack" {
        $dirs = @(
            "src\backend\$ProjectName.Domain",
            "src\backend\$ProjectName.Application",
            "src\backend\$ProjectName.Infrastructure",
            "src\backend\$ProjectName.Api",
            "src\frontend\$($ProjectName.ToLower())-app",
            "tests\$ProjectName.Unit.Tests",
            "tests\$ProjectName.Integration.Tests"
        )
    }
    "backend" {
        $dirs = @(
            "src\$ProjectName.Domain",
            "src\$ProjectName.Application",
            "src\$ProjectName.Infrastructure",
            "src\$ProjectName.Api",
            "tests\$ProjectName.Unit.Tests",
            "tests\$ProjectName.Integration.Tests"
        )
    }
    "frontend" {
        $dirs = @(
            "src\app\core",
            "src\app\shared",
            "src\app\layout",
            "src\app\features",
            "src\app\domain",
            "src\styles"
        )
    }
    default {
        $dirs = @("src", "tests", "docs")
    }
}

foreach ($dir in $dirs) {
    New-Item -ItemType Directory -Path "$OutputPath\$dir" -Force | Out-Null
}

# --- Copiar agents selecionados ---
foreach ($agent in $selectedAgents) {
    $src = Join-Path $AgentsSource $agent
    $dst = Join-Path "$OutputPath\agents" $agent
    if (Test-Path $src) {
        Copy-Item -Path $src -Destination $dst -Recurse -Force
        Write-Host "  [OK] Agent copiado: $agent"
    } else {
        Write-Warning "  Agent nao encontrado em: $src"
    }
}

# --- Copiar e personalizar CLAUDE.md ---
$claudeContent = Get-Content $TemplateFile -Raw

$claudeContent = $claudeContent -replace "\[NOME DO PROJETO\]", $ProjectName
$claudeContent = $claudeContent -replace "\[DATA\]", (Get-Date -Format "yyyy-MM-dd")

$stackLabel = switch ($Stack) {
    "fullstack" { "Full Stack (.NET + Angular)" }
    "backend"   { "Back-end .NET" }
    "frontend"  { "Front-end Angular" }
    default     { "A definir" }
}
$claudeContent = $claudeContent -replace "\[Full Stack / Back-end \.NET / Front-end Angular\]", $stackLabel

# Descomentar as linhas @ dos agents selecionados
foreach ($agent in $selectedAgents) {
    $claudeContent = $claudeContent -replace "<!-- @agents/$agent/agent\.md -->", "@agents/$agent/agent.md"
}

$claudeContent | Set-Content "$OutputPath\CLAUDE.md" -Encoding UTF8

# --- Criar docs/project-scope.md vazio ---
@"
# Escopo — $ProjectName

> Gerado em: $(Get-Date -Format "yyyy-MM-dd")
> Preencher após rodar o Dr. Strange-Scope para definição de escopo.

## Objetivo

## Escopo Incluído (MVP)

## Escopo Excluído

## Próximas Releases
"@ | Set-Content "$OutputPath\docs\project-scope.md" -Encoding UTF8

# --- Resumo ---
Write-Host ""
Write-Host "Projeto criado com sucesso!"
Write-Host "  Pasta:   $OutputPath"
Write-Host "  Stack:   $stackLabel"
Write-Host "  Agents:  $($selectedAgents -join ', ')"
Write-Host ""
Write-Host "Proximo passo:"
Write-Host "  cd '$OutputPath'"
Write-Host "  claude  # abrir Claude Code e dizer 'iniciar projeto'"
