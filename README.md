# 📂 Repositório de Atividades e Artefatos - PB

[![AWS](https://img.shields.io/badge/AWS-Quality%20Engineering-FF9900?style=flat-square)](https://aws.amazon.com)
[![Robot Framework](https://img.shields.io/badge/Robot%20Framework-API%20Testing-41BDF5?style=flat-square)](https://robotframework.org)
[![Python](https://img.shields.io/badge/Python-3.8%2B-3776AB?style=flat-square)](https://www.python.org)

Bem-vindo ao repositório central de atividades do **Programa de Bolsas (PB) - AWS & AI for Software Quality Engineering**. Este projeto consolida todos os artefatos produzidos durante as Sprints, documentando a evolução prática em **Quality Assurance (QA)**, **Testes de Software** e **Automação de Testes**.

---

## 📋 Conteúdo do Repositório

- **Fase 1 (Sprints 3–6)**: Testes manuais, exploratórios e com Postman
  - **Sprint 2**: Versão inicial do projeto (base para evolução)
  - **Sprint 4**: Versão final com planos de teste consolidados
- **Fase 2 (Sprints 1–2)**: Automação com Robot Framework, TDD com Python e testes da API ServeRest
- **Documentação**: Planos de teste, mapas mentais, relatórios de bugs
- **Testes Automatizados**: Suite completa de testes de API (Happy Path, Negative, Security, Contract)

---

## 🚀 Estrutura do Repositório

```text
/
├── DOCUMENTS/                          # Fase 1: Artefatos das Sprints 3–6
│   ├── Sprint 2/Semana 4/              # [VERSÃO INICIAL] Bugs, Mapas Mentais
│   │                                   # Base do projeto - ponto de partida
│   ├── Sprint 3/Semana 5-6/            # Testes Exploratórios
│   ├── Sprint 4/Semana 7-8/            # [VERSÃO FINAL] Planos de Teste Consolidados
│   │                                   # Evolução completa com documentação refinada
│   ├── Sprint 5/Semana 9-10/           # Postman Collections
│   └── Sprint 6/Semana 11-12/          # Desafio Final
│
├── Fase 2/                             # Fase 2: Sprints 1–2
│   ├── Sprint 1/
│   │   ├── Semana 1/Historia-GIT/      # Histórico Git
│   │   └── Semana 2/CalculadoraPY-TDD/ # Calculadora com TDD (Python)
│   │
│   └── Sprint 2/
│       └── Semana 4/
│           ├── Bug_Encontrados/        # Bugs documentados com links Jira
│           ├── TestingServerRest/      # Suite Robot Framework
│           │   ├── resources/          # Keywords e variáveis
│           │   ├── *_testes_*.robot    # Casos de teste
│           │   └── requirements.txt    # Dependências
│           └── README.md
│
├── results/                            # Relatórios de execução Robot Framework
│   ├── log.html
│   ├── report.html
│   └── output.xml
│
├── .amazonq/rules/                     # Diretrizes de desenvolvimento
├── .gitignore
└── README.md                           # Este arquivo
```

---

## 📌 Evolução do Projeto: Sprint 2 → Sprint 4

### Sprint 2 (Versão Inicial)
- Primeiros artefatos de QA
- Identificação inicial de bugs
- Mapas mentais conceituais
- Base para evolução contínua

### Sprint 3
- Testes exploratórios aprofundados
- Refinamento de estratégias de teste

### Sprint 4 (Versão Final)
- **Planos de teste consolidados e finalizados**
- Documentação completa de casos de teste
- Integração de aprendizados das sprints anteriores
- Versão pronta para referência e replicação

---

## 🛠️ Tecnologias Utilizadas

| Tecnologia | Propósito |
|---|---|
| **Robot Framework** | Automação de testes de API |
| **RequestsLibrary** | Requisições HTTP em Robot Framework |
| **FakerLibrary** | Geração de dados fictícios |
| **Python 3.8+** | Implementação TDD (Calculadora) |
| **pytest** | Testes unitários Python |
| **Postman** | Testes manuais de API (Fase 1) |
| **ServeRest API** | API alvo para testes (`compassuol.serverest.dev`) |

---

## 📦 Instalação e Configuração

### Pré-requisitos
- Python 3.8 ou superior
- pip (gerenciador de pacotes Python)
- Git

### Instalação de Dependências

```bash
# Clonar o repositório
git clone <url-do-repositorio>
cd "AWS---AI-for-Softaware-Quality-Engineering---Fase-1---2"

# Instalar dependências Robot Framework
pip install -r "Fase 2/Sprint 2/Semana 4/TestingServerRest/requirements.txt"

# Ou instalar manualmente
pip install robotframework robotframework-requests robotframework-faker
```

---

## ▶️ Como Executar os Testes

### Testes Automatizados (Robot Framework)

```bash
# Navegar até a pasta de testes
cd "Fase 2/Sprint 2/Semana 4/TestingServerRest"

# Executar todos os testes
robot .

# Executar suite específica
robot ServerRest_testes_1HP.robot
robot ServerRest_testes_LOGIN.robot
robot ServerRest_testes_USUARIOS.robot
robot ServerRest_testes_PRODUTOS.robot
robot ServerRest_testes_CARRINHO.robot

# Executar com tags específicas
robot --include happy_path .
robot --include seguranca .
```

### Testes TDD (Python)

```bash
# Navegar até a pasta da Calculadora
cd "Fase 2/Sprint 1/Semana 2/CalculadoraPY-TDD"

# Executar testes com pytest
pytest test_calculadora.py -v
```

---

## 📊 Relatórios de Execução

Após executar os testes Robot Framework, os relatórios são gerados em `results/`:

- **`report.html`** – Resumo executivo dos testes
- **`log.html`** – Log detalhado de cada teste
- **`output.xml`** – Saída em formato XML (para integração CI/CD)

Abra `report.html` no navegador para visualizar os resultados.

---

## 📝 Documentação de Testes

### Abordagem de Teste

A automação segue a **Pirâmide de Testes**, focando na camada de API (Serviços) por oferecer melhor balanço entre velocidade, confiabilidade e custo de manutenção.

**Categorias de Teste:**
- **Happy Path**: Fluxos de sucesso com dados válidos (Status 200/201)
- **Negative Testing**: Dados inválidos e campos obrigatórios (Status 400)
- **Boundary Testing**: Limites das regras de negócio
- **Security Testing**: Acesso sem token, token expirado (Status 401/403)
- **Contract Testing**: Validação de estrutura JSON vs. Swagger

### Módulos Testados

| Módulo | Cobertura |
|---|---|
| `/login` | Autenticação, geração JWT, expiração de token |
| `/usuarios` | CRUD completo, validação de email único |
| `/produtos` | CRUD, regras de negócio (preço, estoque) |
| `/carrinhos` | Regra de 1 carrinho ativo por usuário, conclusão de compra |

---

## 🐛 Bugs Encontrados

Bugs documentados durante os testes estão em `Fase 2/Sprint 2/Semana 4/Bug_Encontrados/` com links para tickets Jira.

---

## 📚 Diretrizes de Desenvolvimento

Consulte `.amazonq/rules/` para:
- **Abordagem de Testes** (`Aborgadem_de_Testes.md`)
- **Padrões Robot Framework** (`memory-bank/guidelines.md`)
- **Estrutura do Projeto** (`memory-bank/structure.md`)
- **Stack Tecnológico** (`memory-bank/tech.md`)
- **Documentação da API ServeRest** (`Swagger.md`)

---

## 🎯 Critérios de Sucesso

✅ 100% dos casos de teste planejados executados  
✅ Taxa mínima de 95% de aprovação  
✅ 100% de aprovação em Happy Path e Sad Path  
✅ Zero bugs críticos/altos abertos  
✅ Relatórios finais gerados (report.html, log.html)

---

## 👥 Autores

Desenvolvido como parte do **Programa de Bolsas - AWS & AI for Software Quality Engineering**.

---

## 📄 Licença

Este repositório é destinado a fins educacionais.

---

## 📞 Suporte

Para dúvidas ou sugestões, consulte a documentação em `.amazonq/rules/` ou abra uma issue no repositório.
