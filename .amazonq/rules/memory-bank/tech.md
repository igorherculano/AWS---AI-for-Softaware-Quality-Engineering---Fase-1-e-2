# Technology Stack

## Languages
- **Robot Framework DSL** (`.robot` files) — primary automation language
- **Python 3.8+** — TDD calculator project and Robot Framework runtime

## Frameworks & Libraries

### Robot Framework (API Automation)
| Package | Purpose |
|---|---|
| `robotframework` | Core test framework |
| `robotframework-requests` | HTTP keyword library (`RequestsLibrary`) |
| `robotframework-faker` | Fake data generation (`FakerLibrary`, locale `pt_BR`) |

Install via:
```bash
pip install robotframework robotframework-requests robotframework-faker
```

### Python (TDD)
- `pytest` — unit test runner for `CalculadoraPY-TDD/`

## Target System Under Test
- **ServeRest API**: `https://compassuol.serverest.dev/`
- Endpoints: `/login`, `/usuarios`, `/produtos`, `/carrinhos`

## Development Tools
- **VS Code** with **RobotCode extension** (recommended for per-test execution)
- **pip** — Python package manager

## Execution Commands

Run all Robot Framework tests:
```cmd
cd "Fase 2\Sprint 2\Semana 4\TestingServerRest"
robot .
```

Run specific suites:
```cmd
robot ServerRest_testes_1HP.robot ServerRest_testes_CARRINHO.robot ServerRest_testes_LOGIN.robot ServerRest_testes_PRODUTOS.robot ServerRest_testes_USUARIOS.robot
```

Run Python TDD tests:
```cmd
cd "Fase 2\Sprint 1\Semana 2\CalculadoraPY-TDD"
pytest test_calculadora.py
```

## Output
Robot Framework generates results in `results/`:
- `log.html` — detailed execution log
- `report.html` — summary report
- `output.xml` — machine-readable output
