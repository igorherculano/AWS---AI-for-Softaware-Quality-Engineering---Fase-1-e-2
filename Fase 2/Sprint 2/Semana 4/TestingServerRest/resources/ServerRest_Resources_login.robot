*** Settings ***
Library    RequestsLibrary
Library    String
Library    Collections
Resource    ServerRest_Resources.robot

*** Variables ***
${URL}    https://compassuol.serverest.dev/
${EMAIL_TESTE}
${RESPOSTA}
${RESPOSTA_ERRO}
${ID_USUARIO}
${TOKEN}
${NOME_PRODUTO}
${ID_PRODUTO}
${ID_CARRINHO}
${VERBO}
${EMPTY}

*** Keywords ***
############             ############
############ CT DE LOGIN ############
############             ############
Tentar realizar login com metodo ${VERBO}
    Criar Sessão na ServerRest
    Criar Usuario Novo Aleatorio
    ${dados}    Create Dictionary    email=${EMAIL_TESTE}    password=teste
                        #para GET é necessario o campo params
    IF    '${VERBO}' == 'GET'
        ${resposta_errada}    GET On Session    
        ...    alias=CompassServerRest    
        ...    url=login    
        ...    params=${dados}    
        ...    expected_status=any
    ELSE
        # Para PUT e DELETE é necessario o campo json
        ${resposta_errada}    Run Keyword    ${VERBO} On Session    
        ...    alias=CompassServerRest    
        ...    url=login    
        ...    json=${dados}    
        ...    expected_status=any
    END
    
    Set Test Variable    ${RESPOSTA_ERRO}    ${resposta_errada}

    
    Log    Status code retornado: ${RESPOSTA_ERRO.status_code}

Tentar realizar login com e-mail com formato invalido
    Criar Sessão na ServerRest
    
    ${body}    Create Dictionary    
    ...    email=teste@🙂🙂oi.com    
    ...    password=teste
    
    ${resposta_errada_login}    POST On Session    
    ...    alias=CompassServerRest
    ...    url=login
    ...    json=${body}
    ...    expected_status=any
    
    ${body_json}    Set Variable    ${resposta_errada_login.json()}
    Log    ${body_json}
    
    # Validação da mensagem correta
    Run Keyword And Continue On Failure    
    ...    Should Be Equal As Strings    
    ...    ${body_json["message"]}    
    ...    Email e/ou senha inválidos
    
    # Validação do status code correto
    Run Keyword And Continue On Failure    
    ...    Should Be Equal As Integers    
    ...    ${resposta_errada_login.status_code}    
    ...    401
    
    Set Test Variable    ${RESPOSTA_ERRO}    ${resposta_errada_login}
    
Tentar realizar login com senha vazia
    Criar Sessão na ServerRest
    ${body}    Create Dictionary    email=teste@teste.com    password=${EMPTY}
    
    ${resposta_errada_login}    POST On Session    
    ...    alias=CompassServerRest
    ...    url=login
    ...    json=${body}
    ...    expected_status=any
    
    Set Test Variable    ${RESPOSTA_ERRO}    ${resposta_errada_login}

Tentar realizar login com senha incorreta
    Criar Sessão na ServerRest
    Criar Usuario Novo Aleatorio
    
    ${body_cadastro}    Create Dictionary    
    ...    nome=Fulano    
    ...    email=${EMAIL_TESTE}    
    ...    password=senha_correta    
    ...    administrador=true
    POST On Session    
    ...    alias=CompassServerRest    
    ...    url=usuarios    
    ...    json=${body_cadastro}
    
    ${body}    Create Dictionary    
    ...    email=${EMAIL_TESTE}    
    ...    password=senha_errada
    ${resposta_errada_login}    POST On Session   
    ...     alias=CompassServerRest    
    ...    url=login    
    ...    json=${body}    
    ...    expected_status=any
    
    Set Test Variable    ${RESPOSTA_ERRO}    ${resposta_errada_login}

Tentar realizar login com usuario nao cadastrado
    Criar Sessão na ServerRest
    Criar Usuario Novo Aleatorio
    
    ${body}    Create Dictionary    email=${EMAIL_TESTE}    password=teste
    ${resposta_errada_login}    POST On Session    alias=CompassServerRest    url=login    json=${body}    expected_status=any
    
    Set Test Variable    ${RESPOSTA_ERRO}    ${resposta_errada_login}
############## TRATAMENTO DE ERROS ##############
Validar status code 405
    # comparar se o status_code da resposta é exatamente 405
    Should Be Equal As Integers    ${RESPOSTA_ERRO.status_code}    405

Validar status code 401 e mensagem de erro de email
    Run Keyword And Continue On Failure    Should Be Equal As Integers    ${RESPOSTA_ERRO.status_code}    401
    Log    Status code retornado: ${RESPOSTA_ERRO.status_code}


Validar status code 400 e mensagem de erro de senha vazia
    Should Be Equal As Integers    ${RESPOSTA_ERRO.status_code}    400
    Dictionary Should Contain Item    ${RESPOSTA_ERRO.json()}    password    password não pode ficar em branco

Validar status code: 401 Email e/ou senha inválidos
    Should Be Equal As Integers    ${RESPOSTA_ERRO.status_code}    401
    Dictionary Should Contain Item    ${RESPOSTA_ERRO.json()}    message    Email e/ou senha inválidos
    Log    Status code retornado: ${RESPOSTA_ERRO.status_code}
