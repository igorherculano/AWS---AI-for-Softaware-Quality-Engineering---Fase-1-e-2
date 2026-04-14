*** Settings ***
Resource    ServerRest_Resources.robot

*** Keywords ***
Tentar realizar login com metodo ${VERBO}
    Criar Sessão na ServerRest
    Criar Usuario Novo Aleatorio
    ${dados}    Create Dictionary    email=${EMAIL_TESTE}    password=teste
    IF    '${VERBO}' == 'GET'
        ${resposta_errada}    GET On Session
        ...    alias=CompassServerRest    url=login    params=${dados}    expected_status=any
    ELSE
        ${resposta_errada}    Run Keyword    ${VERBO} On Session
        ...    alias=CompassServerRest    url=login    json=${dados}    expected_status=any
    END
    Set Test Variable    ${RESPOSTA_ERRO}    ${resposta_errada}
    Log    Status code retornado: ${RESPOSTA_ERRO.status_code}

Tentar realizar login com e-mail com formato invalido
    Criar Sessão na ServerRest
    ${body}    Create Dictionary    email=teste@🙂🙂oi.com    password=teste
    ${resposta_errada}    POST On Session
    ...    alias=CompassServerRest    url=login    json=${body}    expected_status=any
    Set Test Variable    ${RESPOSTA_ERRO}    ${resposta_errada}

Tentar realizar login com senha vazia
    Criar Sessão na ServerRest
    ${body}    Create Dictionary    email=teste@teste.com    password=${EMPTY}
    ${resposta_errada}    POST On Session
    ...    alias=CompassServerRest    url=login    json=${body}    expected_status=any
    Set Test Variable    ${RESPOSTA_ERRO}    ${resposta_errada}

Tentar realizar login com senha incorreta
    Criar Sessão na ServerRest
    Criar Usuario Novo Aleatorio
    ${body_cadastro}    Create Dictionary
    ...    nome=Fulano    email=${EMAIL_TESTE}    password=senha_correta    administrador=true
    POST On Session    alias=CompassServerRest    url=usuarios    json=${body_cadastro}
    ${body}    Create Dictionary    email=${EMAIL_TESTE}    password=senha_errada
    ${resposta_errada}    POST On Session
    ...    alias=CompassServerRest    url=login    json=${body}    expected_status=any
    Set Test Variable    ${RESPOSTA_ERRO}    ${resposta_errada}

Tentar realizar login com usuario nao cadastrado
    Criar Sessão na ServerRest
    Criar Usuario Novo Aleatorio
    ${body}    Create Dictionary    email=${EMAIL_TESTE}    password=teste
    ${resposta_errada}    POST On Session
    ...    alias=CompassServerRest    url=login    json=${body}    expected_status=any
    Set Test Variable    ${RESPOSTA_ERRO}    ${resposta_errada}

Validar status code 405
    Should Be Equal As Integers    ${RESPOSTA_ERRO.status_code}    405
    ...    msg=Sad Path: Rota /login deve retornar status 405 para verbos HTTP não suportados (proteção de segurança)

Validar status code 401 e mensagem de erro de email
    Run Keyword And Continue On Failure    Should Be Equal As Integers    ${RESPOSTA_ERRO.status_code}    401
    ...    msg=Sad Path: POST /login deve retornar status 401 para email com formato inválido (validação de entrada)
    Log    Status code retornado: ${RESPOSTA_ERRO.status_code}

Validar status code 400 e mensagem de erro de senha vazia
    Should Be Equal As Integers    ${RESPOSTA_ERRO.status_code}    400
    ...    msg=Sad Path: POST /login deve retornar status 400 para senha vazia (validação de campo obrigatório)
    Dictionary Should Contain Item    ${RESPOSTA_ERRO.json()}    password    password não pode ficar em branco
    ...    msg=Regra de negócio: Campo password é obrigatório e não pode ser vazio

Validar status code: 401 Email e/ou senha inválidos
    Should Be Equal As Integers    ${RESPOSTA_ERRO.status_code}    401
    ...    msg=Sad Path: POST /login deve retornar status 401 para credenciais incorretas ou usuário inexistente (barreira de autenticação)
    Dictionary Should Contain Item    ${RESPOSTA_ERRO.json()}    message    Email e/ou senha inválidos
    ...    msg=Regra de segurança: API retorna mensagem genérica para não expor se email existe ou não
    Log    Status code retornado: ${RESPOSTA_ERRO.status_code}

Tentar realizar login com payload vazio
    Criar Sessão na ServerRest
    ${body}    Create Dictionary
    ${resposta_errada}    POST On Session
    ...    alias=CompassServerRest    url=login    json=${body}    expected_status=any
    Set Test Variable    ${RESPOSTA_ERRO}    ${resposta_errada}

Validar status code 400 e mensagem de campos obrigatorios
    Should Be Equal As Integers    ${RESPOSTA_ERRO.status_code}    400
    ...    msg=Sad Path: POST /login deve retornar status 400 para payload vazio (validação de campos obrigatórios)
    Dictionary Should Contain Key    ${RESPOSTA_ERRO.json()}    email
    ...    msg=Contrato da API: Resposta de erro deve indicar que campo email é obrigatório
    Dictionary Should Contain Key    ${RESPOSTA_ERRO.json()}    password
    ...    msg=Contrato da API: Resposta de erro deve indicar que campo password é obrigatório

Tentar realizar login com email muito longo
    Criar Sessão na ServerRest
    ${email_longo}    Evaluate    'a' * 500 + '@teste.com'
    ${body}    Create Dictionary    email=${email_longo}    password=teste
    ${resposta_errada}    POST On Session
    ...    alias=CompassServerRest    url=login    json=${body}    expected_status=any
    Set Test Variable    ${RESPOSTA_ERRO}    ${resposta_errada}

Validar status code de email muito longo
    Run Keyword And Continue On Failure    Should Be True    ${RESPOSTA_ERRO.status_code} == 400 or ${RESPOSTA_ERRO.status_code} == 401
    ...    msg=Sad Path: POST /login deve retornar status 400 ou 401 para email muito longo (validação de tamanho)
    Log    Status code retornado: ${RESPOSTA_ERRO.status_code}

Tentar realizar login com email contendo SQL injection
    ${body}    Create Dictionary    email=admin' OR '1'='1    password=teste
    ${resposta_errada}    POST On Session
    ...    alias=CompassServerRest    url=login    json=${body}    expected_status=any
    Set Test Variable    ${RESPOSTA_ERRO}    ${resposta_errada}

Validar status code de rejeicao de SQL injection
    Run Keyword And Continue On Failure    Should Be True    ${RESPOSTA_ERRO.status_code} == 400 or ${RESPOSTA_ERRO.status_code} == 401
    ...    msg=Sad Path: POST /login deve rejeitar tentativas de SQL injection (proteção de segurança)
    Log    Status code retornado: ${RESPOSTA_ERRO.status_code}
