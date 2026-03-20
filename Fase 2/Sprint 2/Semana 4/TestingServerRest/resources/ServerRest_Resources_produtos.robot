*** Settings ***
Library    RequestsLibrary
Library    String
Library    Collections
Resource   ServerRest_Resources.robot

*** Variables ***
${URL}    https://compassuol.serverest.dev/
${EMAIL_TESTE}    
#^^^^^^^^^^^^^     está servindo tambem para palavras aleatorias
${RESPOSTA}
${RESPOSTA_ERRO}
${TOKEN_ADMIN} 
${ID_USUARIO}
${TOKEN}
${NOME_PRODUTO}
${ID_PRODUTO}
${ID_CARRINHO}
${VERBO}
${EMPTY}
${BODY_PRODUTO} 

*** Keywords ***
############             ############
############ CT Produtos ############
############             ############
Cadastrar Usuario Comum
    ${body_usuario}    Create Dictionary    
    ...    nome=QA Comum    
    ...    email=${EMAIL_TESTE}    
    ...    password=teste    
    ...    administrador=false
    POST On Session    
    ...    alias=CompassServerRest    url=usuarios    json=${body_usuario}

Criar Payload de Produto Valido
    ${PALAVRA_ALEATORIA}    Generate Random String    8    [LETTERS]
    # Usar ${250} garante que seja enviado como Integer, evitando o bug das aspas (Issue 225)
    ${body_produto}    Create Dictionary    nome=Produto Valido ${PALAVRA_ALEATORIA}    preco=${250}    descricao=Teclado    quantidade=${10}
    Set Test Variable    ${BODY_PRODUTO}    ${body_produto}

Criar Payload de Produto com preco negativo
    ${PALAVRA_ALEATORIA}    Generate Random String    8    [LETTERS]
    ${body_produto}    Create Dictionary    nome=Produto Negativo ${PALAVRA_ALEATORIA}    preco=${-50}    descricao=Teclado    quantidade=${10}
    Set Test Variable    ${BODY_PRODUTO}    ${body_produto}

Tentar cadastrar produto com usuario comum (nao administrador)
    ${headers}    Create Dictionary    Authorization=${TOKEN}
    ${resposta_errada}    POST On Session    
    ...    alias=CompassServerRest    
    ...    url=produtos    
    ...    json=${BODY_PRODUTO}    
    ...    headers=${headers}    
    ...    expected_status=any
    Set Test Variable    ${RESPOSTA_ERRO}    ${resposta_errada}

Tentar cadastrar produto com nome ja existente
    ${headers}    Create Dictionary    Authorization=${TOKEN}
    
    # 1. Faz o cadastro correto e insere no banco
    POST On Session    alias=CompassServerRest    url=produtos    json=${BODY_PRODUTO}    headers=${headers}
    
    # 2. Tenta mandar exatamente o mesmo dicionário de novo para tomar o erro 400
    ${resposta_errada}    POST On Session    
    ...    alias=CompassServerRest    
    ...    url=produtos    
    ...    json=${BODY_PRODUTO}    
    ...    headers=${headers}    
    ...    expected_status=any
    Set Test Variable    ${RESPOSTA_ERRO}    ${resposta_errada}

Tentar cadastrar produto com preco negativo
    ${headers}    Create Dictionary    Authorization=${TOKEN}
    ${resposta_errada}    POST On Session    
    ...    alias=CompassServerRest    
    ...    url=produtos    
    ...    json=${BODY_PRODUTO}    
    ...    headers=${headers}    
    ...    expected_status=any
    Set Test Variable    ${RESPOSTA_ERRO}    ${resposta_errada}

Tentar cadastrar produto sem enviar Token
    ${resposta_errada}    POST On Session    
    ...    alias=CompassServerRest    
    ...    url=produtos    
    ...    json=${BODY_PRODUTO}    
    ...    expected_status=any
    Set Test Variable    ${RESPOSTA_ERRO}    ${resposta_errada}

############## TRATAMENTO DE ERROS ##############
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