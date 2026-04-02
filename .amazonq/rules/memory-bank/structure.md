# Project Structure

## Directory Layout

```
/
├── DOCUMENTS/                          # Fase 1 artifacts (Sprints 2–6)
│   ├── Sprint 2/Semana 4/
│   │   ├── Atividade Bug/              # Jira bug report screenshots
│   │   └── Mapa mental/               # Mind maps (XMind, PDF, PNG)
│   ├── Sprint 3/Semana 6/             # Exploratory testing concepts (PDF)
│   ├── Sprint 4/
│   │   ├── Semana 7/                  # Exploratory test reports (PDF)
│   │   └── Semana 8 - Challenge 01/   # Test plan PDF
│   ├── Sprint 5/
│   │   ├── Semana 9/                  # Petstore activity (PDF)
│   │   └── Semana 10/                 # Postman collection (JSON)
│   └── Sprint 6/
│       ├── Semana 11/                 # Test plan PDF
│       └── Semana 12-Challenge Final/ # Final Postman collection + test plan
│
├── Fase 2/                            # Fase 2 artifacts (Sprints 1–2)
│   ├── Sprint 1/
│   │   ├── Semana 1/Historia-GIT/     # Git history link
│   │   └── Semana 2/CalculadoraPY-TDD/
│   │       ├── Calculadora.py         # Calculator implementation (Python/TDD)
│   │       ├── test_calculadora.py    # Unit tests (pytest)
│   │       └── README.md
│   └── Sprint 2/
│       ├── Semana 3/                  # No activities
│       └── Semana 4/
│           ├── Bug_Encontrados/       # Bug reports with Jira links
│           │   ├── bug-01/            # Link to Jira ticket
│           │   └── bug-02/            # Screenshot + Jira link
│           ├── TestingServerRest/     # Robot Framework test suite
│           │   ├── resources/         # Keyword libraries (Resource files)
│           │   │   ├── ServerRest_Resources.robot          # Shared keywords
│           │   │   ├── ServerRest_Resources_login.robot
│           │   │   ├── ServerRest_Resources_usuarios.robot
│           │   │   ├── ServerRest_Resources_produtos.robot
│           │   │   └── ServerRest_Resources_carrinho.robot
│           │   ├── ServerRest_testes_1HP.robot             # Happy Path suite
│           │   ├── ServerRest_testes_LOGIN.robot
│           │   ├── ServerRest_testes_USUARIOS.robot
│           │   ├── ServerRest_testes_PRODUTOS.robot
│           │   ├── ServerRest_testes_CARRINHO.robot
│           │   └── requirements.txt
│           └── README.md
│
├── results/                           # Robot Framework execution results
│   ├── log.html
│   ├── output.xml
│   └── report.html
│
├── .amazonq/rules/memory-bank/        # Amazon Q memory bank docs
├── .gitignore
└── README.md
```

## Core Components

### Robot Framework Test Suite (`TestingServerRest/`)
- **Test files** (`*_testes_*.robot`): Contain `*** Test Cases ***` only — no keywords defined here
- **Resource files** (`resources/*.robot`): Contain all `*** Keywords ***` and `*** Variables ***`
- **Separation of concerns**: Tests call keywords; keywords live in resources (DRY principle)
- **Target API**: `https://compassuol.serverest.dev/`

### Python TDD Project (`CalculadoraPY-TDD/`)
- `Calculadora.py`: Implementation class
- `test_calculadora.py`: pytest-based unit tests written before implementation (TDD)

## Architectural Patterns
- **Resource/Test separation** in Robot Framework (keywords abstracted into resource files)
- **Module-per-endpoint** resource files (login, usuarios, produtos, carrinho)
- **TDD cycle** for Python code (test first, then implement)
- **Sprint/Week folder hierarchy** for all deliverables
