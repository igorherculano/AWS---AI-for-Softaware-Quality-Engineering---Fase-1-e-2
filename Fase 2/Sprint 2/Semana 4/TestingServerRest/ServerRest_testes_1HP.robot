*** Settings ***
Documentation    Essa suite testa o site compassuol.serverest.dev
Resource    ../TestingServerRest/resources/ServerRest_Resources.robot
    

*** Test Cases ***
## HAPPY PATH ###
HP - Happy Path ADM
    [Documentation]    Realizar um happy path para testar todas as funcionalidades baiscas da API.
    ...                Resultado esperado: 200 | 201.
    [Tags]    bug  adm        put  post  get  delete        login  produto  usuarios  carrinho

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
    Excluir Carrinho     #Bug encontrado na documentação ou no message de resposta.
    Excluir Usuario
