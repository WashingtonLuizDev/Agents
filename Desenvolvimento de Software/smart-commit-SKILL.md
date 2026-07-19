---
name: smart-commit
description: USO OBRIGATÓRIO para QUALQUER operação de commit Git. SEMPRE consulte esta skill antes de executar git commit, git add ou gerar mensagens de commit — sem exceção. Dispara quando o usuário disser "gerar commit", "gera o commit", "criar commit", "commitar", "commita", "commit", "faz o commit", "prepara o commit", "salvar as alterações no git", "subir as alterações", mencionar mensagem de commit, ou qualquer variação em qualquer idioma — mesmo que o pedido pareça simples ou que você já saiba escrever a mensagem sozinho. NUNCA gere mensagem de commit ou execute git commit sem seguir o fluxo desta skill. O fluxo verifica arquivos pendentes, analisa as alterações, executa a skill /simplify ANTES de gerar a mensagem, gera a mensagem padronizada (título + lista de alterações + resumo), adiciona os arquivos ao stage e SÓ commita com autorização explícita do usuário.
---

# Smart Commit

Skill para padronizar a geração de commits. O fluxo é obrigatório e deve ser seguido **nesta ordem exata**:

## Fluxo obrigatório

### 1. Verificar arquivos pendentes

Execute para levantar tudo que está pendente de commit:

```bash
git status --porcelain
```

Se não houver nada pendente, informe o usuário e encerre o fluxo.

### 2. Analisar as alterações

Para cada arquivo modificado/novo, analise o conteúdo das mudanças:

```bash
git diff                # alterações não staged
git diff --staged       # alterações já staged
```

Para arquivos novos (untracked), leia o conteúdo do arquivo diretamente.

Entenda **o que** mudou e **por que** (correção, nova funcionalidade, refatoração, ajuste de query/procedure, etc.). Agrupe mudanças relacionadas mentalmente — isso vai alimentar a lista de alterações da mensagem.

### 3. Executar a skill /simplify (OBRIGATÓRIO antes da mensagem)

Antes de gerar qualquer mensagem de commit, invoque a skill `/simplify` sobre os arquivos alterados para que o código seja revisado, corrigido e simplificado.

- Aguarde a conclusão de todas as correções/ajustes propostos pelo simplify.
- Se o simplify alterar arquivos, refaça o `git diff` para que a análise reflita o estado final do código.
- **Nunca gere a mensagem de commit antes de o simplify ter terminado.** A mensagem deve descrever o código já corrigido/simplificado.

Se a skill `/simplify` não estiver disponível no ambiente, informe o usuário e pergunte se deseja prosseguir sem essa etapa.

### 4. Gerar a mensagem de commit

A mensagem DEVE seguir exatamente esta estrutura:

```
Título do commit

* Alteração 1;
* Alteração 2;
* Alteração n;

Resumo do commit.
```

Regras:
- **Título**: curto (até ~72 caracteres), no imperativo, descrevendo a mudança principal. Ex.: `Adiciona endpoint de consulta de pedidos`.
- **Lista de alterações**: um item por mudança relevante, iniciando com `* ` e terminando com `;`. Seja específico (arquivo/camada/funcionalidade afetada). Inclua também ajustes feitos pelo simplify, quando houver.
- **Resumo**: 1 a 3 frases explicando o contexto/objetivo geral das mudanças, terminando com ponto final.
- Escreva a mensagem no idioma que o usuário está usando na conversa (padrão: português).

Exemplo:

```
Adiciona validação de CPF no cadastro de clientes

* Cria classe CpfValidator em Domain/Validators;
* Adiciona validação no ClienteService antes da persistência;
* Inclui testes unitários para cenários válidos e inválidos;
* Simplifica método de formatação removendo duplicação;

Implementa a validação de CPF exigida pela regra de negócio RN-042, garantindo que cadastros inválidos sejam rejeitados na camada de serviço.
```

### 5. Adicionar os arquivos ao stage

Adicione os arquivos pendentes ao stage:

```bash
git add <arquivos analisados>
```

Prefira adicionar explicitamente os arquivos analisados em vez de `git add .`, para não incluir arquivos não relacionados por acidente.

### 6. Pedir autorização — NUNCA commitar sem ela

Apresente a mensagem de commit gerada ao usuário e **pergunte explicitamente** se ele autoriza o commit. Exemplo:

> Arquivos adicionados ao stage. Posso executar o commit com a mensagem acima?

- **Se o usuário autorizar** (ex.: "sim", "pode commitar", "autorizo"): execute

  ```bash
  git commit -m "Título do commit" -m "* Alteração 1;
  * Alteração n;

  Resumo do commit."
  ```

  e confirme o hash do commit gerado.

- **Se o usuário NÃO autorizar ou não responder claramente**: NÃO execute `git commit`. O estado final permitido é: arquivos staged + mensagem gerada e exibida. Nada além disso.

## Regras invioláveis

1. **Jamais execute `git commit` sem autorização explícita do usuário nesta conversa.** Autorização dada em commits anteriores não vale para o atual.
2. **Jamais execute `git push`**, mesmo que autorizado o commit, a menos que o usuário peça separadamente.
3. A skill `/simplify` roda **antes** da geração da mensagem, nunca depois.
4. A mensagem segue **exatamente** o formato: título, linha em branco, lista com `* ...;`, linha em branco, resumo.
5. Não inclua na mensagem assinaturas, co-authors ou referências a ferramentas de IA, salvo pedido do usuário.
