*** Settings ***
Documentation    Essa suite testa o site compassuol.serverest.dev
Resource    ServerRest_resources.robot
# Test Setup

*** Test Cases ***
HP-01 - Happy Path ADM
    [Documentation]    Realizar um happy path para testar todas as funcionalidades baiscas da API.
    ...                Resultado esperado: 200 | 201.
    [Tags]    put    post    get    delete        login    produto    usuarios    carrinho

HP-01 - Happy Path USER
    [Documentation]    Realizar um happy path para testar todas as funcionalidades baiscas da API.
    ...                Resultado esperado: 200 | 201 e 400 405 para ações exclusivas de ADM.
    [Tags]    put    post    get    delete        login    produto    usuarios    carrinho

CT-01 Enviar PUT na rota /login
    [Documentation]    Validar se a API bloqueia verbos não suportados.
    ...                Resultado esperado: Status 405 Method Not Allowed.
    [Tags]    put    login
CT-02 Enviar GET na rota /login
    [Documentation]    Verificar se credenciais trafegam via URL.
    ...                Resultado esperado: Status 405 Method Not Allowed ou 400.
    [Tags]    get    login

CT-03 Tentar cadastrar Produto sem enviar Header Authorization
    [Documentation]    Validar barreira de entrada.
    ...                Resultado esperado: Status 401 Unauthorized; Msg: "Token de acesso ausente".
    [Tags]    post   produto

CT-04 Tentar cadastrar Produto com Token de usuário comum 
    [Documentation]    Validar RBAC.
    ...                Status 403 Forbidden; Msg: "Rota exclusiva para administradores".
    [Tags]    post   produto

CT-05 Manipular Token e tentar POST /produtos
    [Documentation]    Verificar se credenciais trafegam via URL.
    ...                Resultado esperado: Status 405 Method Not Allowed ou 400.
    [Tags]     post   produto