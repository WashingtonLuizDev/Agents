# [NOME DO PROJETO]

> Substitua este cabeçalho com o nome real do projeto após rodar a inicialização.

---

## Sobre este Projeto

- **Stack:** [Full Stack / Back-end .NET / Front-end Angular]
- **Banco de dados:** [SQL Server / PostgreSQL / Nenhum]
- **Metodologia:** [Scrum / Kanban / Híbrido]
- **Iniciado em:** [DATA]

---

## Agents Ativos

Descomente apenas os agents que este projeto usa.
O Claude Code injeta o conteúdo automaticamente via `@`.

<!-- AGENT: Desenvolvedor Full Stack (.NET + Angular + SQL Server) -->
<!-- @agents/tony-stack/agent.md -->

<!-- AGENT: Gerente de Projetos Ágil (escopo, backlog, histórias) -->
<!-- @agents/dr-strange-scope/agent.md -->

<!-- AGENT: UX/UI Architect (Angular Material + Tailwind + Clean Architecture) -->
<!-- @agents/wall-ui/agent.md -->

---

## Inicialização do Projeto

Quando o usuário disser **"iniciar projeto"** ou **"init"**, execute este fluxo:

### 1. Coletar informações (em uma única mensagem)

Perguntar:
- Nome do projeto
- Stack: Full Stack / Só Back-end (.NET) / Só Front-end (Angular) / Outro
- Banco de dados: SQL Server / PostgreSQL / MongoDB / Nenhum
- Agents necessários: Tony Stack / Dr. Strange-Scope / Wall-UI / Todos

### 2. Criar estrutura de pastas conforme a stack escolhida

**Full Stack (.NET + Angular):**
```
[projeto]/
├── CLAUDE.md
├── agents/
├── src/
│   ├── backend/
│   │   ├── [Projeto].Domain/
│   │   ├── [Projeto].Application/
│   │   ├── [Projeto].Infrastructure/
│   │   └── [Projeto].Api/
│   └── frontend/
│       └── [projeto]-app/
├── tests/
│   ├── [Projeto].Unit.Tests/
│   └── [Projeto].Integration.Tests/
└── docs/
    └── project-scope.md
```

**Só Back-end (.NET):**
```
[projeto]/
├── CLAUDE.md
├── agents/
├── src/
│   ├── [Projeto].Domain/
│   ├── [Projeto].Application/
│   ├── [Projeto].Infrastructure/
│   └── [Projeto].Api/
└── tests/
    ├── [Projeto].Unit.Tests/
    └── [Projeto].Integration.Tests/
```

**Só Front-end (Angular):**
```
[projeto]/
├── CLAUDE.md
├── agents/
└── src/
    └── app/
        ├── core/
        ├── shared/
        ├── layout/
        ├── features/
        └── domain/
```

### 3. Configurar agents

Copiar as pastas dos agents selecionados para `agents/` e descomentar as linhas `@` correspondentes neste CLAUDE.md.

### 4. Confirmar inicialização

Exibir um resumo do que foi criado e sugerir o próximo passo (ex: "Quer que eu ative o Dr. Strange-Scope para definir o escopo agora?").

---

## Convenções do Projeto

### Git

- Branch principal: `main`
- Feature branches: `feat/nome-da-feature`
- Fix branches: `fix/nome-do-fix`
- Commit: `feat: descrição`, `fix: descrição`, `chore: descrição`

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

### Código

- Idioma do código: inglês (nomes de classes, métodos, variáveis)
- Idioma dos comentários e docs: português
- Nunca gerar pseudocódigo — sempre código compilável e funcional
- Sempre incluir testes unitários ao entregar lógica de domínio

### Entregas

- Código entregue deve ser pronto para copy/paste ou scaffold
- Ao final de cada entrega: `> Próximo: [ação sugerida]`
- Não pedir confirmação intermediária — entregar e sugerir iteração

---

## Backlog e Escopo

Quando o backlog do projeto for definido, linkar aqui:

- Escopo: `docs/project-scope.md`
- Backlog: `docs/backlog.md`
- Sprint atual: `docs/sprint-atual.md`

---

## Comandos Úteis

```bash
# .NET — rodar a API
dotnet run --project src/backend/[Projeto].Api

# .NET — migrations
dotnet ef migrations add [Nome] --project src/backend/[Projeto].Infrastructure --startup-project src/backend/[Projeto].Api
dotnet ef database update --project src/backend/[Projeto].Infrastructure --startup-project src/backend/[Projeto].Api

# Angular — rodar o app
cd src/frontend/[projeto]-app && ng serve

# Angular — gerar componente
ng generate component features/[feature]/pages/[page] --standalone

# Testes
dotnet test
ng test
```
