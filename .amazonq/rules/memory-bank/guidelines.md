# Development Guidelines

## Robot Framework Patterns

### File Organization
- **Test files** contain only `*** Settings ***` and `*** Test Cases ***` — never define keywords in test files
- **Resource files** contain `*** Settings ***`, `*** Variables ***`, and `*** Keywords ***`
- One resource file per API module (login, usuarios, produtos, carrinho) + one shared base resource
- Test files import their module-specific resource: `Resource    ../TestingServerRest/resources/ServerRest_Resources_<module>.robot`

### Test Case Structure
```robot
CT-01 Validar <behavior> de <subject>
    [Documentation]    <What is being tested>.
    ...                Resultado esperado: Status <code> <reason>.
    [Tags]    <module>    <category>    <type>

    Criar Sessão na ServerRest
    <Setup keyword>
    <Action keyword>
    <Validation keyword>
```

- Test case names follow: `CT-NN Validar <behavior> de/no/na <subject>`
- `[Documentation]` always includes "Resultado esperado:" with expected HTTP status
- Tags use lowercase, no spaces: `login`, `usuarios`, `bug`, `seguranca`, `data`, `errors`, `verbs`, `authorization`, `business_rule`
- Tag `bug` marks tests that document known bugs
- Each test starts with `Criar Sessão na ServerRest` (when session is needed per test)

### Keyword Naming
- Use natural Portuguese language: `Cadastrar Usuario ADM`, `Tentar realizar login com metodo GET`
- Validation keywords: `Validar status code <N> e mensagem de <context>`
- "Tentar" prefix for negative/error path actions: `Tentar cadastrar usuario com email ja existente`
- "Criar" prefix for setup/data generation: `Criar Sessão na ServerRest`, `Criar Usuario Novo Aleatorio`

### Variables
```robot
*** Variables ***
${URL}              https://compassuol.serverest.dev/
${EMAIL_TESTE}      ${EMPTY}
${TOKEN}            ${EMPTY}
${ID_USUARIO}       ${EMPTY}
```
- All variables initialized to `${EMPTY}` or a known default
- Use `Set Test Variable` for test-scoped state, `Set Suite Variable` for suite-scoped (e.g., `${ID_USUARIO}`)
- Authorization header: `Create Dictionary    Authorization=${TOKEN}` (no "Bearer" prefix — API-specific)

### HTTP Requests Pattern
```robot
${resposta}    POST On Session    alias=CompassServerRest    url=<endpoint>    json=${body}
${resposta}    POST On Session    alias=CompassServerRest    url=<endpoint>    json=${body}    headers=${headers}
```
- Session alias is always `CompassServerRest`
- URLs are relative (no leading slash): `url=usuarios`, `url=login`, `url=produtos/${ID_PRODUTO}`
- Response stored in local variable, then validated immediately

### Assertions
```robot
Dictionary Should Contain Item    ${resposta.json()}    message    Cadastro realizado com sucesso
Dictionary Should Contain Key     ${resposta.json()}    _id
```
- Always assert on `.json()` response body
- Use `Run Keyword And Continue On Failure` when a known bug may cause assertion failure

### Bug Documentation
```robot
Excluir Carrinho     #Bug encontrado na documentação ou no message de resposta.
Run Keyword And Continue On Failure    Dictionary Should Contain Item    ...
##^Necessario sempre que tem um bug#######
```
- Inline comments document bugs directly in the keyword
- Tests with bugs get the `bug` tag

---

## Python / TDD Patterns

### Class Structure
```python
class ClasseCalculadora:
    @staticmethod
    def operation(param1, param2):
        ClasseCalculadora._validar_input(param1, param2)
        return <result>

    @staticmethod
    def _validar_input(*args):
        for arg in args:
            if not isinstance(arg, (int, float)):
                raise TypeError(f"Entrada inválida: {arg}. Apenas números são aceitos.")
```
- All methods are `@staticmethod` — no instance state
- Every public method calls `_validar_input` first (guard clause pattern)
- Private helpers prefixed with `_`

### Test Structure (pytest)
```python
@pytest.mark.parametrize("param1,param2,expected", [
    (value1, value2, result),   ## descriptive inline comment
])
def test_<operation>(param1, param2, expected):
    assert ClasseCalculadora.<operation>(param1, param2) == pytest.approx(expected)
```
- Use `pytest.approx()` for all float comparisons
- Parametrize covers: normal case, zero, negatives, floats, large numbers, edge cases
- Each parametrize tuple has an inline comment explaining the edge case
- Separate non-parametrized tests for exception cases:
```python
def test_divisao_por_zero():
    with pytest.raises(ZeroDivisionError):
        ClasseCalculadora.divisao(10, 0)
```

### Naming Conventions (Python)
- Test functions: `test_<operation>` and `test_<operation>_<edge_case>`
- Parameters use domain-specific Portuguese names: `parcela1`, `minuendo`, `dividendo`, `multiplicando`
- Class name: PascalCase with "Classe" prefix (`ClasseCalculadora`)

---

## General Conventions

### Comments
- Portuguese throughout (code, comments, documentation)
- Section separators in Robot: `############  SECTION  ############`
- Inline comments explain the "why" of edge cases, not the "what"

### Documentation
- Every test suite has `Documentation` in `*** Settings ***`
- Every test case has `[Documentation]` with expected result
- README per project with: description, prerequisites, installation, usage instructions

### Bug Tracking
- Bugs found during testing are documented in `Bug_Encontrados/` with Jira links
- Bugs in automation are marked with `[Tags]    bug` and inline comments
- `Run Keyword And Continue On Failure` used to keep suite running despite known bugs
