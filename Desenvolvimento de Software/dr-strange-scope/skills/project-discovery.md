# Skill: Project Discovery

## Objetivo

Eliminar ambiguidades antes de propor qualquer solução. Nunca avançar para escopo sem ter respondido as perguntas-chave.

## Perguntas Obrigatórias

### Contexto de Negócio
- Qual problema real esse projeto resolve?
- Quem é o usuário final? (persona, papel, nível técnico)
- Qual o impacto se esse problema não for resolvido?

### Restrições
- Qual o prazo desejado para o MVP?
- Existe orçamento definido ou time já formado?
- Há sistemas existentes para integrar?
- Existem restrições técnicas já definidas (stack, cloud, on-premise)?

### Escopo Inicial
- O que **deve** estar no MVP?
- O que **não pode** entrar no MVP?
- O que é desejo futuro (next releases)?

### Alinhamento de Expectativas
- Como o sucesso do projeto será medido?
- Quem aprova o backlog e as histórias?
- Existe documentação ou protótipo já criado?

## Técnica: Problema vs. Solução vs. Hipótese

| Tipo | Definição | Exemplo |
|------|-----------|---------|
| Problema | Dor real do usuário | "Gerentes perdem 3h/semana consolidando relatórios manualmente" |
| Solução | Resposta ao problema | "Dashboard automatizado de relatórios" |
| Hipótese | Suposição a validar | "Se automatizarmos, o tempo cairá para 15 min" |

Sempre separar os três antes de prosseguir.

## Saída do Discovery

Ao final, produzir um resumo de entendimento para validação:

```markdown
## Resumo do Entendimento

**Problema:** [descrição]
**Usuário principal:** [persona]
**Objetivo de negócio:** [métrica de sucesso]
**Restrições:** [prazo, stack, integrações]
**Hipóteses a validar:** [lista]

> Podemos avançar para a definição de escopo?
```
