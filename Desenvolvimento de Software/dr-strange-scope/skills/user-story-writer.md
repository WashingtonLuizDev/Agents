# Skill: Escrita de Histórias de Usuário

## Formato Obrigatório

```markdown
### US-[número] — [Título descritivo]

**Story Points:** [1 / 2 / 3 / 5 / 8 / 13]
**Prioridade:** Must Have / Should Have / Could Have
**Camada:** Back-end / Front-end / Full Stack

---

**Como** [tipo de usuário]
**Quero** [ação ou funcionalidade]
**Para** [benefício ou valor gerado]

---

#### Critérios de Aceite

- **Cenário 1 — [Nome]:**
  - Dado que [contexto]
  - Quando [ação]
  - Então [resultado esperado]

- **Cenário 2 — [Nome]:**
  - Dado que [contexto]
  - Quando [ação]
  - Então [resultado esperado]

- **Regras de Negócio:**
  - [regra 1]
  - [regra 2]

- **Exceções:**
  - [comportamento em caso de erro ou fluxo alternativo]

---

#### Definição de Pronto (DoD)

- [ ] Código revisado (PR aprovado)
- [ ] Testes unitários implementados
- [ ] Todos os critérios de aceite atendidos
- [ ] Documentação atualizada (se aplicável)
- [ ] Deploy em ambiente de homologação
```

## Checklist de Qualidade da História

- [ ] Escrita em linguagem de negócio (sem jargão técnico na história principal)
- [ ] Critérios testáveis (podem ser verificados sem ambiguidade)
- [ ] Independente — pode ser desenvolvida sem depender de outra história não concluída
- [ ] Estimável — time consegue dar pontos sem precisar de mais informação
- [ ] Pequena o suficiente para caber em uma sprint
- [ ] Valiosa — gera valor por si só ao ser entregue

## Exemplo Preenchido

```markdown
### US-012-BE — Criar endpoint de cadastro de usuário

**Story Points:** 3
**Prioridade:** Must Have
**Camada:** Back-end

---

**Como** administrador do sistema
**Quero** um endpoint REST para cadastrar novos usuários
**Para** que o time de suporte possa provisionar acessos sem intervenção técnica

---

#### Critérios de Aceite

- **Cenário 1 — Cadastro com sucesso:**
  - Dado que os dados são válidos (nome, email único, senha com 8+ chars)
  - Quando POST /api/users é chamado
  - Então retorna 201 Created com o Id do usuário criado

- **Cenário 2 — Email duplicado:**
  - Dado que o email já existe na base
  - Quando POST /api/users é chamado
  - Então retorna 409 Conflict com mensagem "Email já cadastrado"

- **Regras de Negócio:**
  - Senha deve ser armazenada com hash (bcrypt)
  - Email deve ser normalizado para lowercase

- **Exceções:**
  - Campos obrigatórios ausentes → 400 Bad Request com lista de erros

---

#### Definição de Pronto (DoD)

- [ ] Código revisado
- [ ] Testes unitários para validação e hash de senha
- [ ] Critérios atendidos
- [ ] Swagger atualizado
```
