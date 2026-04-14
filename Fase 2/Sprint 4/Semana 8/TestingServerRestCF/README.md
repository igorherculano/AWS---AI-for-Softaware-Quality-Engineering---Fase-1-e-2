# TestingServerRestCF - Automação de Testes API ServeRest

## 📋 Descrição

Suite de testes automatizados para a API ServeRest (`https://compassuol.serverest.dev/`) desenvolvida com **Robot Framework** e **RequestsLibrary**. Projeto de estabilização e fechamento com foco em encontrar bugs através de novos case tests.

---

## 🎯 Objetivo

Validar a API ServeRest através de testes automatizados cobrindo:
- ✅ Happy Path (fluxos de sucesso)
- ✅ Sad Path (fluxos de erro)
- ✅ Edge Cases (casos extremos)
- ✅ Security (validações de segurança)
- ✅ Business Rules (regras de negócio)

---

## 📊 Cobertura de Testes

### Módulos Testados
| Módulo | CTs | Foco |
|--------|-----|------|
| **LOGIN** | 6 | Autenticação, validação de email, SQL injection |
| **USUARIOS** | 7 | CRUD, validação de email, nome muito longo |
| **PRODUTOS** | 8 | CRUD, controle de acesso, quantidade negativa |
| **CARRINHO** | 8 | Regras de negócio, quantidade zero, lista vazia |
| **TOTAL** | **29** | **Encontrar bugs e validar funcionalidades** |

### Categorias de Teste
- **Data Validation**: 10 testes
- **Security**: 6 testes
- **Business Rules**: 8 testes
- **Lifecycle (CRUD)**: 3 testes
- **Edge Cases**: 2 testes

---

## 🚀 Início Rápido

### Pré-requisitos
```bash
# Python 3.8+
python --version

# Instalar dependências
pip install -r requirements.txt
```

### Executar Testes
```bash
# Executar todos os testes
robot .

# Executar módulo específico
robot ServerRest_testes_LOGIN.robot

# Executar apenas novos testes (que encontram bugs)
robot --include bug .

# Executar apenas testes de segurança
robot --include seguranca .
```

### Visualizar Resultados
```bash
# Abrir relatório (Windows)
start results\report.html

# Abrir relatório (Linux/Mac)
open results/report.html
```

---

## 📁 Estrutura do Projeto

```
TestingServerRestCF/
├── ServerRest_testes_1HP.robot              # Happy Path completo
├── ServerRest_testes_LOGIN.robot            # Testes de autenticação (6 CTs)
├── ServerRest_testes_USUARIOS.robot         # Testes de usuários (7 CTs)
├── ServerRest_testes_PRODUTOS.robot         # Testes de produtos (8 CTs)
├── ServerRest_testes_CARRINHO.robot         # Testes de carrinho (8 CTs)
├── resources/
│   ├── ServerRest_Resources.robot           # Keywords compartilhadas
│   ├── ServerRest_Resources_login.robot     # Keywords de LOGIN
│   ├── ServerRest_Resources_usuarios.robot  # Keywords de USUARIOS
│   ├── ServerRest_Resources_produtos.robot  # Keywords de PRODUTOS
│   └── ServerRest_Resources_carrinho.robot  # Keywords de CARRINHO
├── requirements.txt                         # Dependências Python
└── results/                                 # Resultados de execução
    ├── report.html
    ├── log.html
    └── output.xml
```

---

## 🧪 Novos Case Tests (Sprint 4 - Semana 8)

### LOGIN
- **CT-05**: Email muito longo - Validar limite de tamanho
- **CT-06**: SQL Injection - Validar proteção de segurança

### USUARIOS
- **CT-06**: Nome muito longo - Validar limite de tamanho
- **CT-07**: Email duplicado na edição - Validar unicidade

### PRODUTOS
- **CT-07**: Quantidade negativa - Validar sanitização
- **CT-08**: Nome duplicado na edição - Validar unicidade

### CARRINHO
- **CT-07**: Quantidade zero - Validar limite mínimo
- **CT-08**: Lista vazia - Validar estrutura

---

## 🏷️ Tags Disponíveis

### Por Módulo
```bash
robot --include login .          # Apenas testes de LOGIN
robot --include usuarios .       # Apenas testes de USUARIOS
robot --include produto .        # Apenas testes de PRODUTOS
robot --include carrinho .       # Apenas testes de CARRINHO
```

### Por Tipo
```bash
robot --include data .           # Validação de dados
robot --include seguranca .      # Testes de segurança
robot --include authorization .  # Autenticação/Autorização
robot --include business_rule .  # Regras de negócio
robot --include bug .            # Testes que encontram bugs
```

---

## 📈 Métricas de Sucesso

### Critérios de Saída (Definition of Done)
- ✅ 100% dos 29 case tests executados
- ✅ Taxa mínima de 95% de aprovação
- ✅ 100% de aprovação em Happy Path
- ✅ Zero bugs de severidade "Crítica"
- ✅ Todos os bugs documentados em `Bug_Encontrados/`

---

## 🔍 Interpretação de Resultados

### Status dos Testes
| Status | Significado |
|--------|------------|
| ✅ PASS | Teste passou conforme esperado |
| ❌ FAIL | Teste falhou - possível bug encontrado |
| ⚠️ SKIP | Teste foi pulado |

### Testes com Bugs Conhecidos
Testes marcados com `[Tags] bug` podem falhar devido a bugs na API:
- CT-02 (LOGIN): Aceita emojis no email
- CT-04 (USUARIOS): Aceita campos em branco
- CT-05 (USUARIOS): Pode aceitar nome muito longo
- CT-07 (USUARIOS): Pode não validar email duplicado
- CT-07 (PRODUTOS): Pode aceitar quantidade negativa
- CT-08 (PRODUTOS): Pode não validar nome duplicado
- CT-07 (CARRINHO): Pode aceitar quantidade zero
- CT-08 (CARRINHO): Pode aceitar lista vazia

---

## 🛠️ Troubleshooting

### Erro: "Connection refused"
```
Solução: Verificar se API está online
URL: https://compassuol.serverest.dev/
```

### Erro: "Token de acesso ausente"
```
Solução: Verificar se login foi realizado corretamente
Validade do token: 600 segundos (10 minutos)
```

### Erro: "Email já está sendo usado"
```
Solução: Usar emails aleatórios (FakerLibrary gera automaticamente)
```

---

## 📚 Documentação

| Documento | Propósito |
|-----------|-----------|
| `RESUMO_EXECUTIVO.md` | Visão geral do projeto |
| `RELATORIO_ESTABILIZACAO.md` | Detalhes das mudanças |
| `GUIA_EXECUCAO.md` | Instruções de execução |
| `CHECKLIST_VALIDACAO.md` | Validação de qualidade |
| `INDICE_REFERENCIA.md` | Referência rápida |
| `README.md` | Este arquivo |

---

## 🔗 Referências

### Documentação da API
- **Swagger**: `.amazonq/rules/Swagger.md`
- **Abordagem de Testes**: `.amazonq/rules/Aborgadem_de_Testes.md`
- **Guidelines**: `.amazonq/rules/memory-bank/guidelines.md`

### Endpoints Testados
- `POST /login` - Autenticação
- `GET/POST/PUT/DELETE /usuarios` - Gerenciamento de usuários
- `GET/POST/PUT/DELETE /produtos` - Gerenciamento de produtos
- `GET/POST/DELETE /carrinhos` - Gerenciamento de carrinhos

---

## 📝 Padrões de Desenvolvimento

### Nomenclatura de Testes
```robot
CT-NN Validar <behavior> de/no/na <subject>
```

### Estrutura de Teste
```robot
[Documentation]    <What is being tested>.
...                Resultado esperado: Status <code> <reason>.
[Tags]    <module>    <category>    <type>

Criar Sessão na ServerRest
<Setup keyword>
<Action keyword>
<Validation keyword>
```

### Keywords
- Prefixo "Tentar" para ações negativas
- Prefixo "Criar" para setup/dados
- Prefixo "Validar" para assertions

---

## 🎓 Aprendizados

### Princípios Aplicados
- ✅ DRY (Don't Repeat Yourself) - Keywords reutilizáveis
- ✅ Separação de Concerns - Testes vs Resources
- ✅ Nomenclatura Consistente - Português, padrão claro
- ✅ Documentação Integrada - Cada teste auto-explicativo

### Boas Práticas
- ✅ `Run Keyword And Continue On Failure` para bugs conhecidos
- ✅ `expected_status=any` para capturar erros
- ✅ Mensagens de erro descritivas
- ✅ Testes independentes

---

## 🚀 Próximas Etapas

1. **Executar suite completa**
   ```bash
   robot .
   ```

2. **Analisar resultados**
   - Abrir `results/report.html`
   - Revisar testes que falharam

3. **Documentar bugs**
   - Criar pasta em `Bug_Encontrados/`
   - Adicionar screenshot e link Jira

4. **Validar métricas**
   - Taxa de aprovação >= 95%
   - 100% em Happy Path
   - Zero bugs críticos

---

## 📞 Suporte

Para dúvidas sobre:
- **Execução**: Consultar `GUIA_EXECUCAO.md`
- **Padrões**: Consultar `.amazonq/rules/memory-bank/guidelines.md`
- **API**: Consultar `.amazonq/rules/Swagger.md`
- **Estratégia**: Consultar `.amazonq/rules/Aborgadem_de_Testes.md`

---

## ✅ Status do Projeto

| Aspecto | Status |
|---------|--------|
| Estrutura | ✅ Concluído |
| Testes | ✅ 29 CTs implementados |
| Keywords | ✅ 50+ keywords |
| Documentação | ✅ 5 documentos |
| Pronto para Execução | ✅ SIM |

---

**Projeto:** AWS & AI for Software Quality Engineering - Fase 2
**Sprint:** 4 - Semana 8
**Status:** ✅ ESTABILIZADO E FECHADO
**Última atualização:** Sprint 4 - Semana 8
