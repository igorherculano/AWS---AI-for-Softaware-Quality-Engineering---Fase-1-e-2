*** Settings ***
Documentation    Essa suite testa o site compassuol.serverest.dev
Resource    ../TestingServerRest/resources/ServerRest_Resources_produtos.robot
    

*** Test Cases ***
CT-01 Validar controle de acesso (RBAC) bloqueando usuario comum no cadastro de produtos
    [Documentation]    Garantir que apenas Administradores possam acessar a rota de criação (POST /produtos).
    ...                Resultado esperado: Status 403 Forbidden.
    [Tags]    produto    authorization    rbac

    Criar Sessão na ServerRest
    Criar Usuario Novo Aleatorio
    Cadastrar Usuario Comum
    Realizar Login
    Criar Payload de Produto Valido
    Tentar cadastrar produto com usuario comum (nao administrador)
    Validar status code 403 e mensagem de rota exclusiva para administradores

CT-02 Validar bloqueio de duplicidade de nome no cadastro de produto
    [Documentation]    Verificar se a API impede a criação de dois produtos com o exato mesmo nome no banco de dados.
    ...                Resultado esperado: Status 400 Bad Request.
    [Tags]    produto    business_rule    data

    Criar Sessão na ServerRest
    Criar Usuario Novo Aleatorio
    Cadastrar Usuario ADM
    Realizar Login
    Criar Payload de Produto Valido
    Tentar cadastrar produto com nome ja existente
    Validar status code 400 e mensagem de produto duplicado

CT-03 Validar sanitizacao de dados com preco negativo
    [Documentation]    A API não deve permitir o cadastro de produtos com valor financeiro negativo ou inválido.
    ...                Resultado esperado: Status 400 Bad Request.
    [Tags]    produto    data    errors

    Criar Sessão na ServerRest
    Criar Usuario Novo Aleatorio
    Cadastrar Usuario ADM
    Realizar Login
    Criar Payload de Produto com preco negativo
    Tentar cadastrar produto com preco negativo
    Validar status code 400 e mensagem de erro de preco invalido

CT-04 Validar barreira de seguranca com Token ausente na rota de Produtos
    [Documentation]    Garantir que a rota exija autenticação válida para manipulação de dados.
    ...                Resultado esperado: Status 401 Unauthorized.
    [Tags]    produto    authorization    seguranca

    Criar Sessão na ServerRest
    Criar Payload de Produto Valido
    Tentar cadastrar produto sem enviar Token
    Validar status code 401 e mensagem de token ausente

CT-05 Validar fluxo funcional (CRUD) do modulo de Produtos
    [Documentation]    Realizar o ciclo de vida completo do Happy Path.
    ...                Resultado esperado: Status 201 e 200.
    [Tags]    produto    lifecycle    funcional

    Criar Sessão na ServerRest
    Criar Usuario Novo Aleatorio
    Cadastrar Usuario ADM
    Realizar Login
    Criar Produto Novo
    Cadastrar Produto
    Listar Produto e verificar se deu certo
    Editar Produto
    Excluir Produto