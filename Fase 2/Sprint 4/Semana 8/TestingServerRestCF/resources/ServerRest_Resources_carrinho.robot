*** Settings ***
Resource    ServerRest_Resources.robot

*** Variables ***
${ID_PRODUTO_LIMITADO}    ${EMPTY}

*** Keywords ***
Tentar cadastrar um segundo carrinho para o mesmo usuario
    ${produto}    Create Dictionary    idProduto=${ID_PRODUTO}    quantidade=1
    ${lista_produtos}    Create List    ${produto}
    ${body}    Create Dictionary    produtos=${lista_produtos}
    ${headers}    Create Dictionary    Authorization=${TOKEN}
    ${resposta_errada}    POST On Session
    ...    alias=CompassServerRest    url=carrinhos    json=${body}    headers=${headers}    expected_status=any
    Set Test Variable    ${RESPOSTA_ERRO}    ${resposta_errada}

Criar produto com estoque limitado
    Criar Sessão na ServerRest
    Criar Usuario Novo Aleatorio
    Cadastrar Usuario ADM
    Realizar Login
    Gerar Nome Produto Aleatorio
    ${body}    Create Dictionary
    ...    nome=${NOME_PRODUTO}
    ...    preco=50
    ...    descricao=Teclado
    ...    quantidade=2
    ${headers}    Create Dictionary    Authorization=${TOKEN}
    ${resposta}    POST On Session
    ...    alias=CompassServerRest    url=produtos    json=${body}    headers=${headers}
    Set Test Variable    ${ID_PRODUTO_LIMITADO}    ${resposta.json()}[_id]

Tentar cadastrar carrinho com quantidade maior que o estoque
    ${produto}    Create Dictionary    idProduto=${ID_PRODUTO_LIMITADO}    quantidade=5
    ${lista_produtos}    Create List    ${produto}
    ${body}    Create Dictionary    produtos=${lista_produtos}
    ${headers}    Create Dictionary    Authorization=${TOKEN}
    ${resposta_errada}    POST On Session
    ...    alias=CompassServerRest    url=carrinhos    json=${body}    headers=${headers}    expected_status=any
    Set Test Variable    ${RESPOSTA_ERRO}    ${resposta_errada}

Tentar cadastrar carrinho com o mesmo ID de produto duplicado
    ${produto_1}    Create Dictionary    idProduto=${ID_PRODUTO}    quantidade=1
    ${produto_2}    Create Dictionary    idProduto=${ID_PRODUTO}    quantidade=2
    ${lista_produtos}    Create List    ${produto_1}    ${produto_2}
    ${body}    Create Dictionary    produtos=${lista_produtos}
    ${headers}    Create Dictionary    Authorization=${TOKEN}
    ${resposta_errada}    POST On Session
    ...    alias=CompassServerRest    url=carrinhos    json=${body}    headers=${headers}    expected_status=any
    Set Test Variable    ${RESPOSTA_ERRO}    ${resposta_errada}

Tentar cadastrar carrinho sem enviar Token de autorizacao
    ${produto}    Create Dictionary    idProduto=qualquer_id_falso    quantidade=1
    ${lista_produtos}    Create List    ${produto}
    ${body}    Create Dictionary    produtos=${lista_produtos}
    ${resposta_errada}    POST On Session
    ...    alias=CompassServerRest    url=carrinhos    json=${body}    expected_status=any
    Set Test Variable    ${RESPOSTA_ERRO}    ${resposta_errada}

Concluir a compra do carrinho
    ${headers}    Create Dictionary    Authorization=${TOKEN}
    ${resposta}    DELETE On Session
    ...    alias=CompassServerRest    url=carrinhos/concluir-compra    headers=${headers}
    Set Test Variable    ${RESPOSTA}    ${resposta}

Validar status code 400 e mensagem de limite de carrinho
    Should Be Equal As Integers    ${RESPOSTA_ERRO.status_code}    400
    Run Keyword And Continue On Failure    Dictionary Should Contain Item    ${RESPOSTA_ERRO.json()}    message    Não é permitido ter mais de 1 carrinho

Validar status code 400 e mensagem de estoque insuficiente
    Should Be Equal As Integers    ${RESPOSTA_ERRO.status_code}    400
    Run Keyword And Continue On Failure    Dictionary Should Contain Item    ${RESPOSTA_ERRO.json()}    message    Produto não possui quantidade suficiente

Validar status code 400 e mensagem de produto duplicado
    Should Be Equal As Integers    ${RESPOSTA_ERRO.status_code}    400
    Run Keyword And Continue On Failure    Dictionary Should Contain Item    ${RESPOSTA_ERRO.json()}    message    Não é permitido possuir produto duplicado

Validar status code 401 e mensagem de token ausente
    Should Be Equal As Integers    ${RESPOSTA_ERRO.status_code}    401
    Run Keyword And Continue On Failure    Dictionary Should Contain Item    ${RESPOSTA_ERRO.json()}    message    Token de acesso ausente, inválido, expirado ou usuário do token não existe mais

Validar status code 200 e exclusao bem sucedida
    Should Be Equal As Integers    ${RESPOSTA.status_code}    200
    Run Keyword And Continue On Failure    Dictionary Should Contain Item    ${RESPOSTA.json()}    message    Registro excluído com sucesso

Cancelar a compra do carrinho
    ${headers}    Create Dictionary    Authorization=${TOKEN}
    ${resposta}    DELETE On Session
    ...    alias=CompassServerRest    url=carrinhos/cancelar-compra    headers=${headers}
    Set Test Variable    ${RESPOSTA}    ${resposta}
