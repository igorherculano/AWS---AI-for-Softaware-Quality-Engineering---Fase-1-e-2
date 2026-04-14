# Índice de Referência Rápida - Sprint 4 Semana 8

## 📚 Documentação

| Documento | Propósito | Quando Consultar |
|-----------|-----------|-----------------|
| `RESUMO_EXECUTIVO.md` | Visão geral do projeto | Início do trabalho |
| `RELATORIO_ESTABILIZACAO.md` | Detalhes das mudanças | Entender o que foi feito |
| `GUIA_EXECUCAO.md` | Como executar testes | Antes de rodar os testes |
| `CHECKLIST_VALIDACAO.md` | Validação de qualidade | Verificar se tudo está OK |
| `INDICE_REFERENCIA.md` | Este arquivo | Navegação rápida |

---

## 🧪 Testes por Módulo

### LOGIN (6 CTs)
| CT | Nome | Tipo | Tags | Novo |
|----|------|------|------|------|
| CT-01 | Bloqueio de verbos HTTP | Security | login, seguranca, verbs | ❌ |
| CT-02 | Sanitização de email | Data | bug, login, data, errors | ❌ |
| CT-03 | Credenciais inválidas | Security | login, authorization, errors | ❌ |
| CT-04 | Payload vazio | Data | login, data, errors | ❌ |
| **CT-05** | **Email muito longo** | **Data** | **login, data, errors, bug** | **✅** |
| **CT-06** | **SQL Injection** | **Security** | **login, data, seguranca, bug** | **✅** |

**Arquivo:** `ServerRest_testes_LOGIN.robot`
**Resources:** `resources/ServerRest_Resources_login.robot`

---

### USUARIOS (7 CTs)
| CT | Nome | Tipo | Tags | Novo |
|----|------|------|------|------|
| CT-01 | Bloqueio de duplicidade | Business | usuarios, business_rule, data | ❌ |
| CT-02 | Sanitização de email | Data | usuarios, data, errors | ❌ |
| CT-03 | Obrigatoriedade de senha | Data | usuarios, data, errors | ❌ |
| CT-04 | Campos em branco | Data | bug, usuarios, data, errors | ❌ |
| CT-05 | CRUD completo | Lifecycle | usuarios, lifecycle, funcional | ❌ |
| **CT-06** | **Nome muito longo** | **Data** | **usuarios, data, errors, bug** | **✅** |
| **CT-07** | **Email duplicado na edição** | **Business** | **usuarios, business_rule, data, bug** | **✅** |

**Arquivo:** `ServerRest_testes_USUARIOS.robot`
**Resources:** `resources/ServerRest_Resources_usuarios.robot`

---

### PRODUTOS (8 CTs)
| CT | Nome | Tipo | Tags | Novo |
|----|------|------|------|------|
| CT-01 | Controle de acesso RBAC | Security | produto, authorization, rbac | ❌ |
| CT-02 | Bloqueio de duplicidade | Business | produto, business_rule, data | ❌ |
| CT-03 | Preço negativo | Data | produto, data, errors | ❌ |
| CT-04 | Token ausente | Security | produto, authorization, seguranca | ❌ |
| CT-05 | CRUD completo | Lifecycle | produto, lifecycle, funcional | ❌ |
| CT-06 | Produto em carrinho | Business | produto, carrinho, business_rule, errors | ❌ |
| **CT-07** | **Quantidade negativa** | **Data** | **produto, data, errors, bug** | **✅** |
| **CT-08** | **Nome duplicado na edição** | **Business** | **produto, business_rule, data, bug** | **✅** |

**Arquivo:** `ServerRest_testes_PRODUTOS.robot`
**Resources:** `resources/ServerRest_Resources_produtos.robot`

---

### CARRINHO (8 CTs)
| CT | Nome | Tipo | Tags | Novo |
|----|------|------|------|------|
| CT-01 | Limite de 1 carrinho | Business | carrinho, business_rule, errors | ❌ |
| CT-02 | Estoque insuficiente | Business | carrinho, business_rule, data | ❌ |
| CT-03 | Produtos duplicados | Business | carrinho, business_rule, data | ❌ |
| CT-04 | Barreira de autenticação | Security | carrinho, authorization, errors | ❌ |
| CT-05 | Conclusão de compra | Lifecycle | carrinho, lifecycle, delete | ❌ |
| CT-06 | Cancelamento de compra | Lifecycle | carrinho, lifecycle, delete | ❌ |
| **CT-07** | **Quantidade zero** | **Data** | **carrinho, data, errors, bug** | **✅** |
| **CT-08** | **Lista vazia** | **Data** | **carrinho, data, errors, bug** | **✅** |

**Arquivo:** `ServerRest_testes_CARRINHO.robot`
**Resources:** `resources/ServerRest_Resources_carrinho.robot`

---

## 🔑 Keywords Adicionadas

### LOGIN (4 keywords)
```robot
Tentar realizar login com email muito longo
Validar status code de email muito longo
Tentar realizar login com email contendo SQL injection
Validar status code de rejeicao de SQL injection
```

### USUARIOS (4 keywords)
```robot
Tentar cadastrar usuario com nome muito longo
Validar status code de nome muito longo
Tentar editar usuario com email duplicado
Validar status code 400 e mensagem de email duplicado na edicao
```

### PRODUTOS (6 keywords)
```robot
Criar Payload de Produto com quantidade negativa
Tentar cadastrar produto com quantidade negativa
Validar status code 400 e mensagem de erro de quantidade invalida
Tentar editar produto com nome duplicado
Validar status code 400 e mensagem de produto duplicado na edicao
```

### CARRINHO (4 keywords)
```robot
Tentar cadastrar carrinho com quantidade zero
Validar status code 400 e mensagem de quantidade invalida
Tentar cadastrar carrinho com lista de produtos vazia
Validar status code 400 e mensagem de carrinho vazio
```

---

## 🏷️ Tags Disponíveis

### Por Módulo
- `login` - Testes do módulo LOGIN
- `usuarios` - Testes do módulo USUARIOS
- `produto` - Testes do módulo PRODUTOS
- `carrinho` - Testes do módulo CARRINHO

### Por Tipo
- `data` - Validação de dados
- `seguranca` - Testes de segurança
- `authorization` - Testes de autenticação/autorização
- `business_rule` - Testes de regra de negócio
- `lifecycle` - Testes de ciclo de vida (CRUD)
- `errors` - Testes de tratamento de erro
- `verbs` - Testes de verbos HTTP
- `rbac` - Testes de controle de acesso

### Especiais
- `bug` - Marca testes que documentam bugs conhecidos
- `funcional` - Testes funcionais completos

---

## 🎯 Executar por Objetivo

### Encontrar Bugs
```bash
robot --include bug .
```
Executa apenas os 8 novos case tests focados em encontrar bugs.

### Validar Segurança
```bash
robot --include seguranca .
```
Executa testes de SQL injection, token, etc.

### Validar Dados
```bash
robot --include data .
```
Executa testes de validação de entrada.

### Validar Negócio
```bash
robot --include business_rule .
```
Executa testes de regras de negócio.

### Validar Autenticação
```bash
robot --include authorization .
```
Executa testes de autenticação e autorização.

### Happy Path Completo
```bash
robot --include funcional .
```
Executa apenas os testes de ciclo de vida completo (CRUD).

---

## 📊 Estatísticas Rápidas

```
Total de Case Tests: 29
├── LOGIN: 6 (4 existentes + 2 novos)
├── USUARIOS: 7 (5 existentes + 2 novos)
├── PRODUTOS: 8 (6 existentes + 2 novos)
└── CARRINHO: 8 (6 existentes + 2 novos)

Total de Keywords: 50+
├── Compartilhadas: 10 (ServerRest_Resources.robot)
├── LOGIN: 14 (4 novas)
├── USUARIOS: 14 (4 novas)
├── PRODUTOS: 20 (6 novas)
└── CARRINHO: 18 (4 novas)

Categorias de Teste:
├── Data Validation: 10 testes
├── Security: 6 testes
├── Business Rules: 8 testes
├── Lifecycle: 3 testes
└── Edge Cases: 2 testes
```

---

## 🔗 Referências Rápidas

### Arquivos Principais
- Testes: `ServerRest_testes_*.robot`
- Resources: `resources/ServerRest_Resources_*.robot`
- Dependências: `requirements.txt`

### Documentação da API
- Swagger: `.amazonq/rules/Swagger.md`
- Abordagem: `.amazonq/rules/Aborgadem_de_Testes.md`
- Guidelines: `.amazonq/rules/memory-bank/guidelines.md`

### Resultados
- Report: `results/report.html`
- Log: `results/log.html`
- Output: `results/output.xml`

---

## ⚡ Comandos Úteis

```bash
# Executar tudo
robot .

# Executar módulo específico
robot ServerRest_testes_LOGIN.robot

# Executar com tag específica
robot --include bug .

# Executar excluindo tag
robot --exclude bug .

# Executar com output customizado
robot --outputdir results .

# Executar com log detalhado
robot --loglevel DEBUG .

# Executar em paralelo (requer pabot)
pabot --processes 4 .
```

---

## 📋 Checklist de Execução

- [ ] Verificar se API está online: `https://compassuol.serverest.dev/`
- [ ] Instalar dependências: `pip install -r requirements.txt`
- [ ] Executar testes: `robot .`
- [ ] Abrir relatório: `results/report.html`
- [ ] Documentar bugs encontrados
- [ ] Validar métricas de sucesso
- [ ] Atualizar `Bug_Encontrados/`

---

## 🎓 Próximas Etapas

1. **Execução**: Rodar suite completa
2. **Análise**: Revisar resultados em `report.html`
3. **Documentação**: Registrar bugs em `Bug_Encontrados/`
4. **Validação**: Confirmar métricas de sucesso
5. **Entrega**: Finalizar projeto

---

**Última atualização:** Sprint 4 - Semana 8
**Status:** ✅ Pronto para consulta
**Versão:** 1.0
