# Relatório de Estabilização e Fechamento - Sprint 4 Semana 8

## Objetivo
Estabilizar e fechar o projeto de automação de testes da API ServeRest, realizando ajustes não disruptivos e adicionando novos case tests para encontrar bugs.

## Mudanças Realizadas

### 1. Módulo LOGIN
**Novos Case Tests Adicionados:**
- **CT-05**: Validar comportamento com email muito longo
  - Objetivo: Encontrar bugs relacionados a validação de tamanho máximo de email
  - Tags: `login`, `data`, `errors`, `bug`
  - Keywords adicionadas:
    - `Tentar realizar login com email muito longo`
    - `Validar status code de email muito longo`

- **CT-06**: Validar sanitização com caracteres especiais no email (SQL injection)
  - Objetivo: Encontrar vulnerabilidades de segurança
  - Tags: `login`, `data`, `seguranca`, `bug`
  - Keywords adicionadas:
    - `Tentar realizar login com email contendo SQL injection`
    - `Validar status code de rejeicao de SQL injection`

**Arquivo modificado:** `ServerRest_testes_LOGIN.robot` e `ServerRest_Resources_login.robot`

---

### 2. Módulo USUARIOS
**Novos Case Tests Adicionados:**
- **CT-06**: Validar sanitização com nome muito longo no cadastro
  - Objetivo: Encontrar bugs relacionados a validação de tamanho máximo de nome
  - Tags: `usuarios`, `data`, `errors`, `bug`
  - Keywords adicionadas:
    - `Tentar cadastrar usuario com nome muito longo`
    - `Validar status code de nome muito longo`

- **CT-07**: Validar bloqueio de duplicidade ao editar usuário com email existente
  - Objetivo: Encontrar bugs na validação de unicidade durante edição
  - Tags: `usuarios`, `business_rule`, `data`, `bug`
  - Keywords adicionadas:
    - `Tentar editar usuario com email duplicado`
    - `Validar status code 400 e mensagem de email duplicado na edicao`

**Arquivo modificado:** `ServerRest_testes_USUARIOS.robot` e `ServerRest_Resources_usuarios.robot`

---

### 3. Módulo PRODUTOS
**Novos Case Tests Adicionados:**
- **CT-07**: Validar sanitização de dados com quantidade negativa
  - Objetivo: Encontrar bugs relacionados a validação de quantidade
  - Tags: `produto`, `data`, `errors`, `bug`
  - Keywords adicionadas:
    - `Criar Payload de Produto com quantidade negativa`
    - `Tentar cadastrar produto com quantidade negativa`
    - `Validar status code 400 e mensagem de erro de quantidade invalida`

- **CT-08**: Validar bloqueio de duplicidade ao editar produto com nome existente
  - Objetivo: Encontrar bugs na validação de unicidade durante edição
  - Tags: `produto`, `business_rule`, `data`, `bug`
  - Keywords adicionadas:
    - `Tentar editar produto com nome duplicado`
    - `Validar status code 400 e mensagem de produto duplicado na edicao`

**Arquivo modificado:** `ServerRest_testes_PRODUTOS.robot` e `ServerRest_Resources_produtos.robot`

---

### 4. Módulo CARRINHO
**Novos Case Tests Adicionados:**
- **CT-07**: Validar sanitização com quantidade zero no carrinho
  - Objetivo: Encontrar bugs relacionados a validação de quantidade mínima
  - Tags: `carrinho`, `data`, `errors`, `bug`
  - Keywords adicionadas:
    - `Tentar cadastrar carrinho com quantidade zero`
    - `Validar status code 400 e mensagem de quantidade invalida`

- **CT-08**: Validar sanitização com lista de produtos vazia
  - Objetivo: Encontrar bugs na validação de estrutura do carrinho
  - Tags: `carrinho`, `data`, `errors`, `bug`
  - Keywords adicionadas:
    - `Tentar cadastrar carrinho com lista de produtos vazia`
    - `Validar status code 400 e mensagem de carrinho vazio`

**Arquivo modificado:** `ServerRest_testes_CARRINHO.robot` e `ServerRest_Resources_carrinho.robot`

---

## Resumo de Mudanças

| Módulo | Novos CTs | Total CTs | Foco |
|--------|-----------|-----------|------|
| LOGIN | 2 | 6 | Email muito longo, SQL injection |
| USUARIOS | 2 | 7 | Nome muito longo, Email duplicado na edição |
| PRODUTOS | 2 | 8 | Quantidade negativa, Nome duplicado na edição |
| CARRINHO | 2 | 8 | Quantidade zero, Lista vazia |
| **TOTAL** | **8** | **29** | **Encontrar bugs** |

---

## Princípios Aplicados

✅ **Não disruptivo**: Todos os testes existentes mantêm seu comportamento original
✅ **Foco em bugs**: Novos testes exploram edge cases e validações de segurança
✅ **Padrão consistente**: Seguem as guidelines de nomenclatura e estrutura
✅ **Documentação clara**: Cada teste possui `[Documentation]` e `[Tags]` apropriadas
✅ **Keywords reutilizáveis**: Novas keywords seguem o padrão DRY

---

## Próximos Passos

1. Executar a suite completa para validar estabilidade
2. Analisar resultados dos novos case tests
3. Documentar bugs encontrados em `Bug_Encontrados/`
4. Gerar relatórios finais (report.html, log.html)

---

## Arquivos Modificados

- `ServerRest_testes_LOGIN.robot`
- `ServerRest_testes_USUARIOS.robot`
- `ServerRest_testes_PRODUTOS.robot`
- `ServerRest_testes_CARRINHO.robot`
- `resources/ServerRest_Resources_login.robot`
- `resources/ServerRest_Resources_usuarios.robot`
- `resources/ServerRest_Resources_produtos.robot`
- `resources/ServerRest_Resources_carrinho.robot`

---

**Data:** Sprint 4 - Semana 8
**Status:** ✅ Concluído
