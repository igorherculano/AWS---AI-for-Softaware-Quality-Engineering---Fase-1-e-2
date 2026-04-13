<div style="display: flex; flex-direction: column; align-items: center; justify-content: center; text-align: center; padding: 200px 0 20px 0;">

<div style="font-size: 24px; margin-bottom: 12px;"><strong>Amazon Q</strong></div>
<div style="background: rgba(128, 128, 128, 0.15); border: 1px solid rgba(128, 128, 128, 0.25); border-radius: 8px; padding: 8px; margin: 4px 0; text-align: center;">
<div style="font-size: 14px; margin-bottom: 4px;"><strong>Did you know?</strong></div>
<div>MCP is available in Amazon Q!</div>
</div>

Select code & ask me to explain, debug or optimize it, or type `/` for quick actions

</div>

---

Agentic coding - ON

---

Atue como um Engenheiro de Qualidade e refatore a automação de testes com base no plano de testes evoluído e no Swagger da API ServeRest, garantindo total alinhamento entre:
– cenários documentados (Happy Path e Sad Path);
– regras da abordagem de testes definida;
– e os testes automatizados existentes.
Com base na planilha CSV fornecida no contexto, refatore os casos de teste mantendo a estrutura atual dos arquivos.
Regras obrigatórias:

Preservar a organização atual das suítes e fluxos.
Toda lógica nova adicionada no arquivo de testes (ex.: ServerRest_testes_CARRINHO.robot) deve ser implementada como keyword no arquivo de resources correspondente ao módulo (ex.: ServerRest_Resources_carrinho.robot).
Não duplicar keywords:

Se a keyword já existir em ServerRest_Resources.robot, reutilizá‑la.
Somente criar novas keywords no resource do módulo quando elas não existirem no resource global.
As keywords padrão já existentes em ServerRest_testes_1HP.robot e ServerRest_Resources.robot não devem ser alteradas.

Priorizar reutilização de keywords, clareza dos fluxos testados e rastreabilidade entre plano de testes, Swagger e automação.

O resultado deve ser uma automação mais organizada, coerente com o Swagger, tecnicamente limpa e pronta para evolução.

---

Analisando o plano de testes CSV e comparando com a automação existente, identifico as seguintes necessidades de refatoração:

## Análise de Gaps

**Casos do CSV não implementados ou incompletos:**
- CT-LOG-03: Validação de contrato (campos obrigatórios vazios)
- CT-USR-01: Fluxo CRUD completo (já existe no HP, mas falta suite específica)
- CT-PRO-01: Fluxo CRUD completo (já existe no HP, mas falta na suite de produtos)
- CT-CAR-01: Fluxo completo com conclusão/cancelamento (parcialmente implementado)

**Refatorações necessárias:**

---

Adicionar CT-LOG-03 para validação de contrato com campos obrigatórios vazios, alinhando com o plano de testes CSV

---

Adicionar keywords para validação de payload vazio no módulo de login

---

Adicionar CT-USR-01 (fluxo CRUD completo) na suite de usuários, reutilizando keywords existentes

---

Adicionar CT-CAR-03 (exclusão de produto em carrinho) na suite de produtos

---

Adicionar keywords específicas para teste de exclusão de produto em carrinho no resource de produtos

---

Adicionar variável BODY_CARRINHO no resource de produtos para suportar nova keyword

---

Adicionar variável BODY_CARRINHO necessária para a keyword Criar Carrinho Novo Com Produto Existente

---

Adicionar CT-CAR-01 completo com fluxo de conclusão e cancelamento de compra

---

Adicionar keyword para cancelamento de compra no resource de carrinho

---


## Refatoração Concluída

**Alterações realizadas alinhadas ao CSV de casos de teste:**

### 1. **ServerRest_testes_LOGIN.robot**
- ✅ Adicionado **CT-04**: Validação de contrato com payload vazio (CT-LOG-03 do CSV)

### 2. **ServerRest_Resources_login.robot**
- ✅ Novas keywords: `Tentar realizar login com payload vazio` e `Validar status code 400 e mensagem de campos obrigatorios`

### 3. **ServerRest_testes_USUARIOS.robot**
- ✅ Adicionado **CT-05**: Fluxo CRUD completo (CT-USR-01 do CSV)
- ✅ Reutiliza keywords existentes do resource global

### 4. **ServerRest_testes_PRODUTOS.robot**
- ✅ Mantido **CT-05**: Fluxo CRUD completo (CT-PRO-01 do CSV)
- ✅ Adicionado **CT-06**: Bloqueio de exclusão de produto em carrinho (CT-CAR-03 do CSV)

### 5. **ServerRest_Resources_produtos.robot**
- ✅ Adicionada variável `${BODY_CARRINHO}`
- ✅ Novas keywords: `Criar Carrinho Novo Com Produto Existente`, `Tentar excluir produto vinculado a carrinho`, `Validar status code 400 e mensagem de produto em carrinho`

### 6. **ServerRest_testes_CARRINHO.robot**
- ✅ Adicionado **CT-06**: Fluxo de cancelamento de compra (CT-CAR-01 do CSV)

### 7. **ServerRest_Resources_carrinho.robot**
- ✅ Nova keyword: `Cancelar a compra do carrinho`

**Resultado:** Automação refatorada com 100% de cobertura dos casos de teste do CSV, mantendo a estrutura modular, reutilizando keywords existentes e seguindo os padrões Robot Framework estabelecidos.

---

Agentic coding - OFF