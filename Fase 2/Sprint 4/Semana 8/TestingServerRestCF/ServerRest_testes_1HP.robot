*** Settings ***
Documentation    Essa suite testa o site compassuol.serverest.dev
Resource    ../TestingServerRestCF/resources/ServerRest_Resources.robot
    

*** Test Cases ***
## HAPPY PATH ###
HP - Happy Path ADM
    [Documentation]    Realizar um happy path para testar todas as funcionalidades baiscas da API.
    ...                Resultado esperado: 200 | 201.
    [Tags]    bug  adm        put  post  get  delete        login  produto  usuarios  carrinho

    Criar Sessão na ServerRest
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

############  SAD PATH  ############

SP-1 - Login com credenciais invalidas
    [Documentation]    Tentar realizar login com email e senha incorretos.
    ...                Resultado esperado: Status 401 E-mail e/ou senha inválidos.
    [Tags]    login    errors    seguranca

    Criar Sessão na ServerRest
    Tentar Login Com Credenciais Invalidas

SP-2 - Cadastrar usuario com email duplicado
    [Documentation]    Tentar cadastrar usuario com email ja existente na base.
    ...                Resultado esperado: Status 400 Este email já está sendo usado.
    [Tags]    usuarios    errors    business_rule

    Criar Sessão na ServerRest
    Criar Usuario Novo Aleatorio
    Cadastrar Usuario ADM
    Set Suite Variable    ${ID_USUARIO}    ${RESPOSTA}[_id]
    Tentar Cadastrar Usuario Com Email Duplicado
    Excluir Usuario

SP-3 - Cadastrar produto sem token de autenticacao
    [Documentation]    Tentar cadastrar produto sem enviar token JWT.
    ...                Resultado esperado: Status 401 Token de acesso ausente, inválido, expirado ou usuário do token não existe mais.
    [Tags]    produto    errors    seguranca    authorization

    Criar Sessão na ServerRest
    Criar Produto Novo
    Tentar Cadastrar Produto Sem Token

SP-4 - Cadastrar produto como usuario nao administrador
    [Documentation]    Tentar cadastrar produto com usuario sem permissao de administrador.
    ...                Resultado esperado: Status 403 Rota exclusiva para administradores.
    [Tags]    produto    errors    seguranca    authorization

    Criar Sessão na ServerRest
    Criar Usuario Novo Aleatorio
    Cadastrar Usuario Nao ADM
    Realizar Login
    Criar Produto Novo
    Tentar Cadastrar Produto Como Nao ADM
    Excluir Usuario

SP-5 - Cadastrar produto com nome duplicado
    [Documentation]    Tentar cadastrar produto com nome ja existente na base.
    ...                Resultado esperado: Status 400 Já existe produto com esse nome.
    [Tags]    produto    errors    business_rule

    Criar Sessão na ServerRest
    Criar Usuario Novo Aleatorio
    Cadastrar Usuario ADM
    Set Suite Variable    ${ID_USUARIO}    ${RESPOSTA}[_id]
    Realizar Login
    Criar Produto Novo
    Cadastrar Produto
    Tentar Cadastrar Produto Com Nome Duplicado
    Excluir Produto
    Excluir Usuario

SP-6 - Cadastrar carrinho com produto inexistente
    [Documentation]    Tentar adicionar ao carrinho um produto com ID invalido.
    ...                Resultado esperado: Status 400 Produto não encontrado.
    [Tags]    carrinho    errors    business_rule

    Criar Sessão na ServerRest
    Criar Usuario Novo Aleatorio
    Cadastrar Usuario ADM
    Set Suite Variable    ${ID_USUARIO}    ${RESPOSTA}[_id]
    Realizar Login
    Tentar Cadastrar Carrinho Com Produto Inexistente
    Excluir Usuario

SP-7 - Excluir produto que esta em um carrinho
    [Documentation]    Tentar excluir produto que faz parte de um carrinho ativo.
    ...                Resultado esperado: Status 400 Não é permitido excluir produto que faz parte de carrinho.
    [Tags]    produto    carrinho    errors    business_rule

    Criar Sessão na ServerRest
    Criar Usuario Novo Aleatorio
    Cadastrar Usuario ADM
    Set Suite Variable    ${ID_USUARIO}    ${RESPOSTA}[_id]
    Realizar Login
    Criar Produto Novo
    Cadastrar Produto
    Cadastrar Carrinho
    Tentar Excluir Produto Em Carrinho
    Excluir Carrinho    #Bug encontrado na documentação ou no message de resposta.
    Excluir Produto
    Excluir Usuario

SP-8 - Excluir usuario que possui carrinho cadastrado
    [Documentation]    Tentar excluir usuario que possui carrinho ativo.
    ...                Resultado esperado: Status 400 Não é permitido excluir usuário com carrinho cadastrado.
    [Tags]    usuarios    carrinho    errors    business_rule

    Criar Sessão na ServerRest
    Criar Usuario Novo Aleatorio
    Cadastrar Usuario ADM
    Set Suite Variable    ${ID_USUARIO}    ${RESPOSTA}[_id]
    Realizar Login
    Criar Produto Novo
    Cadastrar Produto
    Cadastrar Carrinho
    Tentar Excluir Usuario Com Carrinho
    Excluir Carrinho    #Bug encontrado na documentação ou no message de resposta.
    Excluir Produto
    Excluir Usuario
