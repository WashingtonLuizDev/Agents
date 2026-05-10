# [NOME DO PROJETO] — Projeto Existente

> Substitua este cabeçalho com o nome real do projeto.

---

## Sobre este Projeto

- **Stack:** [Full Stack / Back-end .NET / Front-end Angular]
- **Banco de dados:** [SQL Server / PostgreSQL / Nenhum]
- **Analisado em:** [DATA]

---

## Agents Ativos

Descomente apenas os agents relevantes para este projeto.

<!-- AGENT: Desenvolvedor Full Stack (.NET + Angular + SQL Server) -->
<!-- @agents/tony-stack/agent.md -->

<!-- AGENT: Gerente de Projetos Ágil (escopo, backlog, histórias) -->
<!-- @agents/dr-strange-scope/agent.md -->

<!-- AGENT: UX/UI Architect (Angular Material + Tailwind + Clean Architecture) -->
<!-- @agents/wall-ui/agent.md -->

---

## Análise do Projeto Existente

Quando o usuário disser **"analisar projeto"** ou **"analyze"**, execute este fluxo:

### 1. Leitura do projeto

Antes de qualquer análise, explorar o projeto:

- Ler a estrutura de pastas raiz e principais subdiretórios
- Ler os arquivos de configuração presentes: `.csproj`, `angular.json`, `package.json`, `appsettings.json`, `program.cs` ou equivalentes
- Ler entre 3 e 5 arquivos representativos de cada camada (controller, service, entidade, componente, etc.)
- Identificar a stack real em uso (não assumir pela extensão do projeto)
- Identificar padrões já adotados antes de sugerir qualquer mudança

### 2. Critério de análise — só reportar o que for relevante

Um item só entra no `adaptações_necessarias.md` se atender **pelo menos um** destes critérios:

| Critério | Descrição |
|----------|-----------|
| **Risco real** | Problema de segurança, performance crítica ou dado inconsistente |
| **Débito arquitetural** | Acoplamento que impede evolução ou causa retrabalho recorrente |
| **Divergência de padrão com impacto** | O padrão atual dificulta manutenção ou onboarding |
| **Inconsistência interna** | O próprio projeto tem partes que contradizem outras partes |

**Não reportar:**
- Diferenças de estilo sem impacto funcional
- Refatorações cosméticas (renomear variáveis, reorganizar imports)
- Sugestões de "seria melhor se" sem justificativa concreta
- Tudo que o projeto já faz corretamente — mesmo que diferente do padrão

### 3. Estrutura do arquivo gerado

Gerar o arquivo `adaptações_necessarias.md` na raiz do projeto com a estrutura abaixo.

Cada item deve ter:
- O problema concreto (o que está errado ou ausente)
- O impacto real (por que isso importa)
- A sugestão objetiva (o que fazer — não como reescrever tudo)
- O esforço estimado: Baixo / Médio / Alto

### 4. Confirmar antes de gerar

Antes de escrever o arquivo, apresentar um resumo da análise e perguntar:

```
Analisei o projeto. Encontrei [N] pontos relevantes:
- [N] críticos
- [N] de média prioridade
- [N] de baixa prioridade

Posso gerar o arquivo adaptações_necessarias.md?
```

---

## Convenções de Análise

### Para projetos .NET

Verificar especificamente:
- Lógica de negócio nos controllers (crítico)
- Chamadas diretas ao DbContext fora da Infrastructure (crítico)
- Ausência de tratamento de erros centralizado (médio)
- Queries N+1 identificáveis no código (médio)
- Ausência de validação de entrada (médio)
- DTOs misturados com entidades de domínio (médio)

### Para projetos Angular

Verificar especificamente:
- Subscribe sem cancelamento (memory leak) (crítico)
- Lógica de negócio em componentes (médio)
- Ausência de `ChangeDetectionStrategy.OnPush` (baixo — só reportar se lista grande)
- Chamadas HTTP diretas em componentes sem service (médio)
- Módulos sem lazy loading em features de rota (baixo)
- `any` excessivo no TypeScript (baixo — só reportar se sistêmico)

### Para banco de dados / queries

Verificar especificamente:
- FKs sem índice (médio)
- `SELECT *` em queries de produção (médio)
- Ausência de paginação em consultas de lista (médio)
- Transações abertas sem controle adequado (crítico)

---

## Convenções Git

**Regras obrigatórias para operações git destrutivas ou compartilhadas:**

- **Nunca executar `git commit` sem confirmação explícita do usuário**
- **Nunca executar `git push` sem confirmação explícita do usuário**
- **Nunca executar `git push --force` ou `git reset --hard` sob nenhuma circunstância sem confirmação explícita**
- Antes de qualquer commit ou push, exibir o resumo do que será commitado/enviado e aguardar aprovação
- Aprovação em uma situação não vale para situações futuras — confirmar sempre

Fluxo obrigatório antes de commit ou push:
```
Vou commitar as seguintes alterações:
- [lista de arquivos]
Mensagem sugerida: "[mensagem]"

Posso prosseguir?
```

---

## Comandos Úteis para Análise

```bash
# Ver estrutura de pastas (Claude Code)
# Use Glob para explorar padrões de arquivo
# Use Grep para buscar padrões problemáticos conhecidos

# Exemplos de busca por problemas comuns:
# Subscribe sem takeUntilDestroyed → grep "\.subscribe(" --include="*.ts"
# SELECT * → grep "SELECT \*" --include="*.cs" --include="*.sql"
# HttpClient em componente → grep "HttpClient" --include="*.component.ts"
```
