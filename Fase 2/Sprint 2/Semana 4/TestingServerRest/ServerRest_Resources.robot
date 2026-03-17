*** Settings ***
Library    RequestsLibrary
Library    String

*** Variables ***
${url}
${ENDPOINT_}
${EMAIL_TESTE}

*** Keywords ***
Criar Usuario Novo Aleatorio
    ${palavra_aleatorio}    Generate Random String    length=4    chars=[LETTERS]
    ${palavra_aleatorio}    Convert To Lower Case    ${palavra_aleatorio}
    Set Test Variable    ${EMAIL_TESTE}    ${palavra_aleatorio}@teste.com

Cadastrar Usuario ADM
    ${body}    Create Dictionary    nome=Fulano da Silva    email=${EMAIL_TESTE}    password=teste    administrador=true


