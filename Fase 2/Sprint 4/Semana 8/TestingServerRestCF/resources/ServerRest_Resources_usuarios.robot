*** Settings ***
Resource    ServerRest_Resources.robot

*** Keywords ***
Tentar cadastrar usuario com email ja existente
    ${body}    Create Dictionary    nome=Clone QA    email=${EMAIL_TESTE}    password=teste    administrador=true
    ${resposta_errada}    POST On Session
    ...    alias=CompassServerRest    url=usuarios    json=${body}    expected_status=any
    Set Test Variable    ${RESPOSTA_ERRO}    ${resposta_errada}

Tentar cadastrar usuario com formato de email invalido
    ${body}    Create Dictionary    nome=User Fake    email=usuario.sem.arroba.com    password=teste    administrador=true
    ${resposta_errada}    POST On Session
    ...    alias=CompassServerRest    url=usuarios    json=${body}    expected_status=any
    Set Test Variable    ${RESPOSTA_ERRO}    ${resposta_errada}

Tentar cadastrar usuario sem enviar a senha
    Gerar Email Aleatorio
    ${body}    Create Dictionary    nome=User Sem Senha    email=${EMAIL_TESTE}    password=${EMPTY}    administrador=true
    ${resposta_errada}    POST On Session
    ...    alias=CompassServerRest    url=usuarios    json=${body}    expected_status=any
    Set Test Variable    ${RESPOSTA_ERRO}    ${resposta_errada}

Tentar cadastrar usuario com nome e senha em branco
    Gerar Email Aleatorio
    ${body}    Create Dictionary    nome=" "    email=${EMAIL_TESTE}    password=" "    administrador=true
    ${resposta_errada}    POST On Session
    ...    alias=CompassServerRest    url=usuarios    json=${body}    expected_status=any
    Set Test Variable    ${RESPOSTA_ERRO}    ${resposta_errada}

Validar status code 400 e mensagem de erro de campos em branco
    Should Be Equal As Integers    ${RESPOSTA_ERRO.status_code}    400
    ...    msg=Sad Path: POST /usuarios deve retornar status 400 para campos nome e senha em branco (sanitização de dados)
    Run Keyword And Continue On Failure    Dictionary Should Contain Item    ${RESPOSTA_ERRO.json()}    nome    nome não pode ficar em branco
    ...    msg=Regra de negócio: Campo nome não pode ser vazio ou conter apenas espaços
    Run Keyword And Continue On Failure    Dictionary Should Contain Item    ${RESPOSTA_ERRO.json()}    password    password não pode ficar em branco
    ...    msg=Regra de negócio: Campo password não pode ser vazio ou conter apenas espaços

Validar status code 400 e mensagem de email em uso
    Should Be Equal As Integers    ${RESPOSTA_ERRO.status_code}    400
    ...    msg=Sad Path: POST /usuarios deve retornar status 400 ao tentar cadastrar email duplicado (bloqueio de unicidade)
    Run Keyword And Continue On Failure    Dictionary Should Contain Item    ${RESPOSTA_ERRO.json()}    message    Este email já está sendo usado
    ...    msg=Regra de negócio: API não permite cadastrar dois usuários com o mesmo email

Validar status code 400 e mensagem de erro de email do cadastro
    Should Be Equal As Integers    ${RESPOSTA_ERRO.status_code}    400
    ...    msg=Sad Path: POST /usuarios deve retornar status 400 para formato de email inválido (sanitização de entrada)
    Run Keyword And Continue On Failure    Dictionary Should Contain Item    ${RESPOSTA_ERRO.json()}    email    email deve ser um email válido
    ...    msg=Regra de negócio: Campo email deve seguir o padrão RFC 5322 (conter @ e domínio)

Validar status code 400 e mensagem de senha em branco do cadastro
    Should Be Equal As Integers    ${RESPOSTA_ERRO.status_code}    400
    ...    msg=Sad Path: POST /usuarios deve retornar status 400 para senha vazia (validação de campo obrigatório)
    Run Keyword And Continue On Failure    Dictionary Should Contain Item    ${RESPOSTA_ERRO.json()}    password    password não pode ficar em branco
    ...    msg=Regra de negócio: Campo password é obrigatório e não pode ser vazio
