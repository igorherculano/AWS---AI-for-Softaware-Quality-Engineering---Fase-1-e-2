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
############ CT USUARIOS ############
############             ############
*** Keywords ***
Tentar cadastrar usuario com email ja existente
    ${body}    Create Dictionary    nome=Clone QA    email=${EMAIL_TESTE}    password=teste    administrador=true
    
    ${resposta_errada}    POST On Session    
    ...    alias=CompassServerRest    
    ...    url=usuarios    
    ...    json=${body}    
    ...    expected_status=any
    
    Set Test Variable    ${RESPOSTA_ERRO}    ${resposta_errada}

Tentar cadastrar usuario com formato de email invalido
    ${body}    Create Dictionary    nome=User Fake    email=usuario.sem.arroba.com    password=teste    administrador=true
    
    ${resposta_errada}    POST On Session    
    ...    alias=CompassServerRest    
    ...    url=usuarios    
    ...    json=${body}    
    ...    expected_status=any
    
    Set Test Variable    ${RESPOSTA_ERRO}    ${resposta_errada}

Tentar cadastrar usuario sem enviar a senha
    ${PALAVRA_ALEATORIA}    Generate Random String    8    [LETTERS]
    ${body}    Create Dictionary    nome=User Sem Senha    email=teste${PALAVRA_ALEATORIA}@qa.com    password=${EMPTY}    administrador=true
    
    ${resposta_errada}    POST On Session    
    ...    alias=CompassServerRest    
    ...    url=usuarios    
    ...    json=${body}    
    ...    expected_status=any
    
    Set Test Variable    ${RESPOSTA_ERRO}    ${resposta_errada}

Tentar cadastrar usuario com nome e senha em branco
    ${PALAVRA_ALEATORIA}    Generate Random String    8    [LETTERS]
    ${body}    Create Dictionary    nome=" "    email=teste${PALAVRA_ALEATORIA}@qa.com    password=" "   administrador=true
    
    ${resposta_errada}    POST On Session    
    ...    alias=CompassServerRest    
    ...    url=usuarios    
    ...    json=${body}    
    ...    expected_status=any
    
    Set Test Variable    ${RESPOSTA_ERRO}    ${resposta_errada}

############## tratamento de erros ##############
Validar status code 400 e mensagem de erro de campos em branco
    Should Be Equal As Integers    ${RESPOSTA_ERRO.status_code}    400
    # Valida se a API apontou erro tanto no nome quanto na senha
    Run Keyword And Continue On Failure    Dictionary Should Contain Item    ${RESPOSTA_ERRO.json()}    nome    nome não pode ficar em branco
    Run Keyword And Continue On Failure    Dictionary Should Contain Item    ${RESPOSTA_ERRO.json()}    password    password não pode ficar em branco

Validar status code 400 e mensagem de email em uso
    Should Be Equal As Integers    ${RESPOSTA_ERRO.status_code}    400
    Run Keyword And Continue On Failure    Dictionary Should Contain Item    ${RESPOSTA_ERRO.json()}    message    Este email já está sendo usado

Validar status code 400 e mensagem de erro de email do cadastro
    Should Be Equal As Integers    ${RESPOSTA_ERRO.status_code}    400
    Run Keyword And Continue On Failure    Dictionary Should Contain Item    ${RESPOSTA_ERRO.json()}    email    email deve ser um email válido

Validar status code 400 e mensagem de senha em branco do cadastro
    Should Be Equal As Integers    ${RESPOSTA_ERRO.status_code}    400
    Run Keyword And Continue On Failure    Dictionary Should Contain Item    ${RESPOSTA_ERRO.json()}    password    password não pode ficar em branco