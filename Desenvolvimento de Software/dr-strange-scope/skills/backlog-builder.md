# Skill: Construção de Backlog

## Hierarquia

```
Épico
└── Feature
    └── História de Usuário
        └── Tarefa Técnica (quando necessário)
```

## Template de Backlog

```markdown
## Backlog — [Nome do Projeto]

---

### 🟣 Épico 1: [Nome]
> [Descrição de alto nível do valor de negócio]

#### 🔵 Feature 1.1: [Nome]
- [ ] US-001 — Como [usuário], quero [ação] para [valor] `[S/M/L/XL]`
- [ ] US-002 — Como [usuário], quero [ação] para [valor] `[S/M/L/XL]`

#### 🔵 Feature 1.2: [Nome]
- [ ] US-003 — ...

---

### 🟣 Épico 2: [Nome]
...
```

## Priorização

### MoSCoW
| Categoria | Critério |
|-----------|---------|
| **Must Have** | Sem isso o MVP não funciona |
| **Should Have** | Importante, mas pode vir na próxima sprint |
| **Could Have** | Desejável, sem impacto crítico |
| **Won't Have** | Fora do escopo desta release |

### WSJF (Weighted Shortest Job First)
```
WSJF = (Valor + Urgência + Redução de Risco) / Tamanho
```
Usar WSJF quando há muitos itens competindo por prioridade no mesmo épico.

Justificar sempre qual técnica foi usada e por quê.

## Sizing (Story Points)

| Tamanho | Pontos | Referência |
|---------|--------|-----------|
| XS | 1 | CRUD simples, sem regra |
| S | 2-3 | Lógica pequena, 1 entidade |
| M | 5 | Lógica média, integração simples |
| L | 8 | Múltiplas entidades, integração externa |
| XL | 13+ | Refatorar, dividir em histórias menores |

> Histórias com mais de 8 pontos devem ser quebradas.

## Separação Back-end / Front-end

Quando uma história envolve ambas as camadas, criar duas histórias separadas:

```
US-010-BE — [Mesma história, perspectiva back-end] `[pontos]`
US-010-FE — [Mesma história, perspectiva front-end] `[pontos]`
```
