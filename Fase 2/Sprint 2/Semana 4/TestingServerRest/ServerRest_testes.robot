*** Settings ***
Documentation    Essa suite testa o site compassuol.serverest.dev
Resource    ../TestingServerRest/ServerRest_Resources.robot
# Test Setup

*** Test Cases ***
## HAPPY PATH ###
HP-01 - Happy Path ADM
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

    # Excluir Usuario


## CASOS DE TESTE ###
############             ############
############ CT DE LOGIN ############
############             ############
CT-01 Validar bloqueio de verbos HTTP não suportados na rota /login
    [Documentation]    Verificar se a API protege o endpoint de autenticação bloqueando métodos indevidos (GET, PUT, DELETE, PATCH).
    ...                Garantir que credenciais não trafeguem via URL no GET.
    ...                Resultado esperado: Status 405 Method Not Allowed (ou 400 no caso do GET).
    [Tags]    login    seguranca    verbos

    Tentar realizar login com metodo GET
    Validar status code 405
    
    Tentar realizar login com metodo PUT
    Validar status code 405
    
    Tentar realizar login com metodo DELETE
    Validar status code 405
    
# CT-02 Validar sanitização e obrigatoriedade de dados no Payload de Login
#     [Documentation]    Verificar se a API valida corretamente o formato do e-mail e a obrigatoriedade da senha antes de processar.
#     ...                Resultado esperado: Status 400 Bad Request.
#     [Tags]    login    data    errors

#     ## formato inválido
#     Tentar realizar login com e-mail com formato invalido
#     Validar status code 400 e mensagem de erro de email
    
#     ## campo vazio/faltante
#     Tentar realizar login com senha vazia
#     Validar status code 400 e mensagem de erro de senha vazia

# CT-03 Validar barreira de autenticação com credenciais invalidas e inexistentes
#     [Documentation]    Garantir que a API bloqueie o acesso e retorne erro 401 tanto para senhas incorretas quanto para usuários não cadastrados.
#     ...                Resultado esperado: Status 401 Unauthorized.
#     [Tags]    login    authorization    errors

#     ## usuário real com senha errada
#     Tentar realizar login com senha incorreta
#     Validar status code 401 e mensagem de credenciais invalidas
    
#     ## usuário que não existe no banco
#     Tentar realizar login com usuario nao cadastrado
#     Validar status code 401 e mensagem de credenciais invalidas

