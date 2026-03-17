*** Settings ***
Documentation    Essa suite testa o site compassuol.serverest.dev
Resource         ServerRest_resources.robot
# Test Setup

*** Test Cases ***
HP-01 - Happy Path ADM
    [Documentation]    Realizar um happy path para testar todas as funcionalidades baiscas da API.
    ...                Resultado esperado: 200 | 201.
    [Tags]    adm        put  post  get  delete        login  produto  usuarios  carrinho

    Criar Usuario Novo Aleatorio
    Cadastrar Usuario ADM

    Listar Usuario e verificar se deu certo
    Realizar Login
    Editar Usuario

    Criar Produto Novo
    Cadastrar Produto
    Listar Produto e verificar se deu certo
    Editar Produto
    Excluir Produto

    Criar Carrinho Novo
    Cadastrar Carrinho
    Listar Carrinho por ID e verificar se deu certo
    Excluir Carrinho 

    Excluir Usuario


HP-02 - Happy Path USER
    [Documentation]    Realizar um happy path para testar todas as funcionalidades baiscas da API.
    ...                Resultado esperado: 200 | 201 e 400 405 para ações exclusivas de ADM.
    [Tags]    user        put  post  get  delete        login  produto  usuarios  carrinho

    Cadastrar Usuario

    Listar Usuario
    Realizar Login
    Editar Usuario

    Cadastrar Produto
    Listar Produto
    Editar Produto
    Excluir Produto

    Cadastrar Carrinho
    Listar Carrinho por ID
    Excluir Carrinho 


CT-01 Enviar PUT na rota /login
    [Documentation]    Validar se a API bloqueia verbos não suportados.
    ...                Resultado esperado: Status 405 Method Not Allowed.
    [Tags]    put    login

    Tentar realizar login com metodo PUT
    Validar status code 405
    

CT-02 Enviar GET na rota /login
    [Documentation]    Verificar se credenciais trafegam via URL.
    ...                Resultado esperado: Status 405 Method Not Allowed ou 400.
    [Tags]    get    login

    Tentar realizar login com metodo GET
    Validar status code 405 ou 400


CT-03 Tentar cadastrar Produto sem enviar Header Authorization
    [Documentation]    Validar barreira de entrada.
    ...                Resultado esperado: Status 401 Unauthorized; Msg: "Token de acesso ausente".
    [Tags]    post   produto

    Criar Produto Novo
    Tentar cadastrar Produto sem Header Authorization
    Validar erro de Token de acesso ausente


CT-04 Tentar cadastrar Produto com Token de usuário comum 
    [Documentation]    Validar RBAC.
    ...                Status 403 Forbidden; Msg: "Rota exclusiva para administradores".
    [Tags]    post   produto

    Criar Usuario Novo Aleatorio
    Cadastrar Usuario
    Realizar Login
    Criar Produto Novo
    Tentar cadastrar Produto com usuario comum
    Validar erro de Rota exclusiva para administradores


CT-05 Manipular Token e tentar POST /produtos
    [Documentation]    Verificar se credenciais trafegam via URL.
    ...                Resultado esperado: Status 405 Method Not Allowed ou 400.
    [Tags]     post   produto

    Criar Usuario Novo Aleatorio
    Cadastrar Usuario ADM
    Realizar Login
    Criar Produto Novo
    Manipular Token de Autorizacao
    Tentar cadastrar Produto com Token manipulado
    Validar erro de credenciais invalidas