*** Settings ***
Documentation    Essa suite testa o site compassuol.serverest.dev
Resource    ../TestingServerRest/resources/ServerRest_Resources_login.robot
    

*** Test Cases ***
############             ############
############ CT DE LOGIN ############
############             ############
CT-01 Validar bloqueio de verbos HTTP não suportados na rota /login
    [Documentation]    Verificar se a API protege o endpoint de autenticação bloqueando métodos indevidos (GET, PUT, DELETE, PATCH).
    ...                Garantir que credenciais não trafeguem via URL no GET.
    ...                Resultado esperado: Status 405 Method Not Allowed (ou 400 no caso do GET).
    [Tags]    login    seguranca    verbs

    Tentar realizar login com metodo GET
    Validar status code 405
    
    Tentar realizar login com metodo PUT
    Validar status code 405
    
    Tentar realizar login com metodo DELETE
    Validar status code 405
    
CT-02 Validar sanitização e obrigatoriedade de dados no Payload de Login
    [Documentation]    Verificar se a API valida corretamente o formato do e-mail e a obrigatoriedade da senha antes de processar.
    ...                Resultado esperado: Status 400 Bad Request.
    [Tags]    bug    login    data    errors

    Tentar realizar login com e-mail com formato invalido          #bug encontrado, aceitando emojis no email
    Validar status code 401 e mensagem de erro de email
    
    Tentar realizar login com senha vazia
    Validar status code 400 e mensagem de erro de senha vazia

CT-03 Validar barreira de autenticação com credenciais invalidas e inexistentes
    [Documentation]    Garantir que a API bloqueie o acesso e retorne erro 401 para senhas incorretas e usuários não cadastrados.
    ...                Resultado esperado: Status 401 Unauthorized.
    [Tags]    login    authorization    errors

    # Passo 1: Senha errada
    Tentar realizar login com senha incorreta
    Validar status code: 401 Email e/ou senha inválidos
    
    # Passo 2: Usuário não existe
    Tentar realizar login com usuario nao cadastrado
    Validar status code: 401 Email e/ou senha inválidos
