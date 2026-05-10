# Adaptações Necessárias — [NOME DO PROJETO]

> Analisado em: [DATA]
> Stack: [STACK]
> Gerado por: Claude Code + agents ativos

---

## Resumo Executivo

| Prioridade | Qtd | Esforço total estimado |
|------------|-----|----------------------|
| Crítico    | N   | [horas/dias]          |
| Médio      | N   | [horas/dias]          |
| Baixo      | N   | [horas/dias]          |

> **O que NÃO está neste arquivo:** o projeto já faz X, Y e Z corretamente —
> esses pontos foram descartados da análise por não gerarem valor real se alterados.

---

## Crítico — Resolver antes de evoluir o projeto

> Problemas com risco real: segurança, perda de dados, performance crítica ou bugs latentes.

---

### [C1] Título do problema

**Onde:** `caminho/do/arquivo.cs` (linha aproximada)

**Problema:**
[Descrição objetiva do que está errado e qual o risco concreto]

**Impacto:**
[O que pode acontecer se não for corrigido — seja específico]

**Sugestão:**
```csharp
// Antes
[trecho atual problemático]

// Depois
[como deve ficar]
```

**Esforço:** Baixo / Médio / Alto

---

## Médio — Resolver na próxima sprint ou refactor planejado

> Débito arquitetural ou inconsistências que dificultam manutenção e evolução.

---

### [M1] Título do problema

**Onde:** `caminho/do/arquivo` (padrão recorrente em N arquivos)

**Problema:**
[Descrição objetiva]

**Impacto:**
[Por que isso gera retrabalho ou dificulta onboarding]

**Sugestão:**
[O que fazer — pode ser uma mudança de padrão, não necessariamente código]

**Esforço:** Baixo / Médio / Alto

---

## Baixo — Melhoria incremental, sem urgência

> Divergências de padrão com impacto menor. Atacar quando o contexto permitir.

---

### [B1] Título do problema

**Onde:** [arquivo ou padrão]

**Problema:** [descrição breve]

**Sugestão:** [ação objetiva]

**Esforço:** Baixo

---

## O que está bem — não alterar

> Registrar explicitamente o que o projeto já faz corretamente para evitar
> que futuras análises ou desenvolvedores tentem "melhorar" o que não precisa.

- [Padrão X]: já implementado corretamente em toda a base
- [Padrão Y]: consistente e funcional — manter como está
- [Decisão Z]: diferente do padrão sugerido pelos agents, mas justificada pelo contexto do projeto

---

## Ordem sugerida de execução

1. [C1] — crítico, baixo esforço → atacar primeiro
2. [C2] — crítico, médio esforço → sprint atual
3. [M1] — médio, alto esforço → sprint planejada
4. [M2] — médio, baixo esforço → aproveitar quando tocar o módulo
5. [B1] e [B2] — baixo → backlog, sem data definida
