# Guia de Execução - Testes Estabilizados

## Pré-requisitos

1. **Python 3.8+** instalado
2. **Dependências instaladas:**
   ```bash
   cd "Fase 2\Sprint 4\Semana 8\TestingServerRestCF"
   pip install -r requirements.txt
   ```

3. **API ServeRest disponível:**
   - URL: `https://compassuol.serverest.dev/`
   - Verificar status: Acessar a URL no navegador

---

## Execução Completa

### Executar todos os testes
```bash
cd "Fase 2\Sprint 4\Semana 8\TestingServerRestCF"
robot .
```

### Executar por módulo

**Apenas LOGIN:**
```bash
robot ServerRest_testes_LOGIN.robot
```

**Apenas USUARIOS:**
```bash
robot ServerRest_testes_USUARIOS.robot
```

**Apenas PRODUTOS:**
```bash
robot ServerRest_testes_PRODUTOS.robot
```

**Apenas CARRINHO:**
```bash
robot ServerRest_testes_CARRINHO.robot
```

**Apenas Happy Path:**
```bash
robot ServerRest_testes_1HP.robot
```

---

## Execução Seletiva (por tags)

### Executar apenas novos case tests (CT-05+)
```bash
robot --include bug .
```

### Executar apenas testes de segurança
```bash
robot --include seguranca .
```

### Executar apenas testes de dados
```bash
robot --include data .
```

### Executar apenas testes de negócio
```bash
robot --include business_rule .
```

---

## Resultados

Após a execução, os seguintes arquivos serão gerados em `results/`:

- **report.html** - Relatório visual com resumo de execução
- **log.html** - Log detalhado de cada teste
- **output.xml** - Saída em formato XML para integração

### Abrir relatório
```bash
# Windows
start results\report.html

# Linux/Mac
open results/report.html
```

---

## Interpretação de Resultados

### Status dos Testes

| Status | Significado |
|--------|------------|
| ✅ PASS | Teste passou conforme esperado |
| ❌ FAIL | Teste falhou - possível bug encontrado |
| ⚠️ SKIP | Teste foi pulado (não executado) |

### Testes com Bug Documentado

Testes marcados com `[Tags]    bug` podem falhar devido a bugs conhecidos na API:

- **CT-02 (LOGIN)**: Aceita emojis no email (deveria rejeitar)
- **CT-04 (USUARIOS)**: Aceita campos em branco (deveria rejeitar)
- **CT-05 (USUARIOS)**: Pode aceitar nome muito longo
- **CT-07 (USUARIOS)**: Pode não validar email duplicado na edição
- **CT-07 (PRODUTOS)**: Pode aceitar quantidade negativa
- **CT-08 (PRODUTOS)**: Pode não validar nome duplicado na edição
- **CT-07 (CARRINHO)**: Pode aceitar quantidade zero
- **CT-08 (CARRINHO)**: Pode aceitar lista vazia

---

## Troubleshooting

### Erro: "Connection refused"
- Verificar se a API está online: `https://compassuol.serverest.dev/`
- Aguardar alguns segundos e tentar novamente

### Erro: "Token de acesso ausente"
- Verificar se o login foi realizado corretamente
- Verificar se o token não expirou (validade: 600 segundos)

### Erro: "Email já está sendo usado"
- Limpar dados de teste anteriores
- Usar emails aleatórios (FakerLibrary gera automaticamente)

### Erro: "Produto não encontrado"
- Verificar se o produto foi criado antes de adicionar ao carrinho
- Verificar se o ID do produto está correto

---

## Métricas de Sucesso

✅ **Critério de Saída (Definition of Done):**
- 100% dos 29 case tests executados
- Taxa mínima de 95% de aprovação
- 100% de aprovação em Happy Path (CT-05 de cada módulo)
- Zero bugs de severidade "Crítica" abertos

---

## Documentação de Bugs Encontrados

Ao encontrar um bug, criar arquivo em `Bug_Encontrados/`:

```
Bug_Encontrados/
├── bug-01/
│   ├── screenshot.png
│   └── jira-link.txt
├── bug-02/
│   ├── screenshot.png
│   └── jira-link.txt
```

**Formato do arquivo jira-link.txt:**
```
Título: [Descrição do bug]
Jira: [Link do ticket]
CT Relacionado: [CT-XX]
Módulo: [LOGIN|USUARIOS|PRODUTOS|CARRINHO]
Severidade: [Crítica|Alta|Média|Baixa]
```

---

## Contato e Suporte

Para dúvidas sobre execução ou interpretação de resultados, consultar:
- Guidelines: `.amazonq/rules/memory-bank/guidelines.md`
- Swagger: `.amazonq/rules/Swagger.md`
- Abordagem de Testes: `.amazonq/rules/Aborgadem_de_Testes.md`

---

**Última atualização:** Sprint 4 - Semana 8
**Status:** ✅ Pronto para execução
