*** Settings ***
Resource    ServerRest_Resources.robot

*** Variables ***
${BODY_PRODUTO}    ${EMPTY}

*** Keywords ***
Cadastrar Usuario Comum
    ${body}    Create Dictionary
    ...    nome=QA Comum    email=${EMAIL_TESTE}    password=teste    administrador=false
    POST On Session    alias=CompassServerRest    url=usuarios    json=${body}

Criar Payload de Produto Valido
    Gerar Nome Produto Aleatorio
    ${body}    Create Dictionary    nome=${NOME_PRODUTO}    preco=${250}    descricao=Teclado    quantidade=${10}
    Set Test Variable    ${BODY_PRODUTO}    ${body}

Criar Payload de Produto com preco negativo
    Gerar Nome Produto Aleatorio
    ${body}    Create Dictionary    nome=${NOME_PRODUTO}    preco=${-50}    descricao=Teclado    quantidade=${10}
    Set Test Variable    ${BODY_PRODUTO}    ${body}

Tentar cadastrar produto com usuario comum (nao administrador)
    ${headers}    Create Dictionary    Authorization=${TOKEN}
    ${resposta_errada}    POST On Session
    ...    alias=CompassServerRest    url=produtos    json=${BODY_PRODUTO}    headers=${headers}    expected_status=any
    Set Test Variable    ${RESPOSTA_ERRO}    ${resposta_errada}

Tentar cadastrar produto com nome ja existente
    ${headers}    Create Dictionary    Authorization=${TOKEN}
    POST On Session    alias=CompassServerRest    url=produtos    json=${BODY_PRODUTO}    headers=${headers}
    ${resposta_errada}    POST On Session
    ...    alias=CompassServerRest    url=produtos    json=${BODY_PRODUTO}    headers=${headers}    expected_status=any
    Set Test Variable    ${RESPOSTA_ERRO}    ${resposta_errada}

Tentar cadastrar produto com preco negativo
    ${headers}    Create Dictionary    Authorization=${TOKEN}
    ${resposta_errada}    POST On Session
    ...    alias=CompassServerRest    url=produtos    json=${BODY_PRODUTO}    headers=${headers}    expected_status=any
    Set Test Variable    ${RESPOSTA_ERRO}    ${resposta_errada}

Tentar cadastrar produto sem enviar Token
    ${resposta_errada}    POST On Session
    ...    alias=CompassServerRest    url=produtos    json=${BODY_PRODUTO}    expected_status=any
    Set Test Variable    ${RESPOSTA_ERRO}    ${resposta_errada}

Validar status code 403 e mensagem de rota exclusiva para administradores
    Should Be Equal As Integers    ${RESPOSTA_ERRO.status_code}    403
    Run Keyword And Continue On Failure    Dictionary Should Contain Item    ${RESPOSTA_ERRO.json()}    message    Rota exclusiva para administradores

Validar status code 400 e mensagem de produto duplicado
    Should Be Equal As Integers    ${RESPOSTA_ERRO.status_code}    400
    Run Keyword And Continue On Failure    Dictionary Should Contain Item    ${RESPOSTA_ERRO.json()}    message    Já existe produto com esse nome

Validar status code 400 e mensagem de erro de preco invalido
    Should Be Equal As Integers    ${RESPOSTA_ERRO.status_code}    400
    Run Keyword And Continue On Failure    Dictionary Should Contain Item    ${RESPOSTA_ERRO.json()}    preco    preco deve ser um número positivo

Validar status code 401 e mensagem de token ausente
    Should Be Equal As Integers    ${RESPOSTA_ERRO.status_code}    401
    Run Keyword And Continue On Failure    Dictionary Should Contain Item    ${RESPOSTA_ERRO.json()}    message    Token de acesso ausente, inválido, expirado ou usuário do token não existe mais
