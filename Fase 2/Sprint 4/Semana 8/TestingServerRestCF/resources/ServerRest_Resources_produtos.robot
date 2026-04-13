*** Settings ***
Resource    ServerRest_Resources.robot

*** Variables ***
${BODY_PRODUTO}    ${EMPTY}
${BODY_CARRINHO}    ${EMPTY}

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
    ...    msg=Sad Path: POST /produtos deve retornar status 403 para usuário comum sem permissão (controle de acesso RBAC)
    Run Keyword And Continue On Failure    Dictionary Should Contain Item    ${RESPOSTA_ERRO.json()}    message    Rota exclusiva para administradores
    ...    msg=Regra de negócio: Apenas usuários com administrador=true podem criar produtos

Validar status code 400 e mensagem de produto duplicado
    Should Be Equal As Integers    ${RESPOSTA_ERRO.status_code}    400
    ...    msg=Sad Path: POST /produtos deve retornar status 400 ao tentar cadastrar nome duplicado (bloqueio de unicidade)
    Run Keyword And Continue On Failure    Dictionary Should Contain Item    ${RESPOSTA_ERRO.json()}    message    Já existe produto com esse nome
    ...    msg=Regra de negócio: API não permite cadastrar dois produtos com o mesmo nome

Validar status code 400 e mensagem de erro de preco invalido
    Should Be Equal As Integers    ${RESPOSTA_ERRO.status_code}    400
    ...    msg=Sad Path: POST /produtos deve retornar status 400 para preço negativo (sanitização de dados)
    Run Keyword And Continue On Failure    Dictionary Should Contain Item    ${RESPOSTA_ERRO.json()}    preco    preco deve ser um número positivo
    ...    msg=Regra de negócio: Campo preço deve ser um número inteiro maior ou igual a 1

Validar status code 401 e mensagem de token ausente
    Should Be Equal As Integers    ${RESPOSTA_ERRO.status_code}    401
    ...    msg=Sad Path: POST /produtos deve retornar status 401 ao tentar cadastrar sem token JWT (barreira de autenticação)
    Run Keyword And Continue On Failure    Dictionary Should Contain Item    ${RESPOSTA_ERRO.json()}    message    Token de acesso ausente, inválido, expirado ou usuário do token não existe mais
    ...    msg=Regra de segurança: API exige autenticação válida para manipulação de produtos

Criar Carrinho Novo Com Produto Existente
    ${produto_dict}    Create Dictionary    idProduto=${ID_PRODUTO}    quantidade=2
    ${lista_produtos}    Create List    ${produto_dict}
    ${body}    Create Dictionary    produtos=${lista_produtos}
    Set Test Variable    ${BODY_CARRINHO}    ${body}

Tentar excluir produto vinculado a carrinho
    ${headers}    Create Dictionary    Authorization=${TOKEN}
    ${resposta_errada}    DELETE On Session
    ...    alias=CompassServerRest    url=produtos/${ID_PRODUTO}    headers=${headers}    expected_status=any
    Set Test Variable    ${RESPOSTA_ERRO}    ${resposta_errada}

Validar status code 400 e mensagem de produto em carrinho
    Should Be Equal As Integers    ${RESPOSTA_ERRO.status_code}    400
    ...    msg=Sad Path: DELETE /produtos/{_id} deve retornar status 400 ao tentar excluir produto vinculado a carrinho (proteção de integridade)
    Run Keyword And Continue On Failure    Dictionary Should Contain Item    ${RESPOSTA_ERRO.json()}    message    Não é permitido excluir produto que faz parte de carrinho
    ...    msg=Regra de negócio: API bloqueia exclusão de produtos que estão em carrinhos ativos
