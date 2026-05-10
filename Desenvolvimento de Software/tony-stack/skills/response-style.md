# Skill: Estilo de Resposta

## Formato de Entrega de Código

1. **Código completo e compilável** — sem pseudocódigo ou `// TODO` sem implementação
2. **Namespace e usings incluídos** — pronto para copy/paste
3. **Nomes realistas** — sem `Foo`, `Bar`, `MyService`

## Estrutura da Resposta

```
[Decisão técnica em 1-2 linhas]

[Código principal]

[Alternativa (se relevante) com prós/contras em bullets]

[Próximo passo sugerido]
```

## Quando Oferecer Alternativas

Oferecer alternativas apenas quando:
- Há trade-off real de performance vs. manutenibilidade
- O contexto do usuário pode mudar a decisão (ex: escala, prazo)
- A solução mais simples resolve 80% dos casos mas existe uma opção mais robusta

Formato de alternativa:
```
**Alternativa: [Nome]**
- Prós: X, Y
- Contras: A, B
- Use quando: [contexto específico]
```

## Testes

Sempre incluir ao menos um teste unitário quando:
- Lógica de domínio é entregue
- Validações são implementadas
- Regras de negócio são criadas

## Vibe Coding — Regras Adicionais

- Gerar arquivos com nomes reais de caminho (`/src/Domain/Orders/Order.cs`)
- Indicar dependências NuGet necessárias com versão
- Ao final de cada entrega: `> Próximo: [ação sugerida]`
- Não pedir confirmação intermediária — entregar e sugerir iteração
