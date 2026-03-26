*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    FakerLibrary    locale=pt_BR

*** Variables ***
${URL}              https://compassuol.serverest.dev/
${EMAIL_TESTE}      ${EMPTY}
${RESPOSTA}         ${EMPTY}
${RESPOSTA_ERRO}    ${EMPTY}
${ID_USUARIO}       ${EMPTY}
${TOKEN}            ${EMPTY}
${NOME_PRODUTO}     ${EMPTY}
${ID_PRODUTO}       ${EMPTY}
${ID_CARRINHO}      ${EMPTY}
${VERBO}            ${EMPTY}

*** Keywords ***
Criar Sessão na ServerRest
    ${headers}    Create Dictionary    accept=application/json    Content-Type=application/json
    Create Session    alias=CompassServerRest    url=${URL}    headers=${headers}

Gerar Email Aleatorio
    ${email}    FakerLibrary.Email
    Set Test Variable    ${EMAIL_TESTE}    ${email}

Gerar Nome Aleatorio
    ${nome}    FakerLibrary.Name
    RETURN    ${nome}

Gerar Nome Produto Aleatorio
    ${nome}    FakerLibrary.Catch Phrase
    Set Test Variable    ${NOME_PRODUTO}    ${nome}

Criar Usuario Novo Aleatorio
    Gerar Email Aleatorio

Cadastrar Usuario ADM
    ${nome}    Gerar Nome Aleatorio
    ${body}    Create Dictionary
    ...    nome=${nome}
    ...    email=${EMAIL_TESTE}
    ...    password=teste
    ...    administrador=true
    ${resposta}    POST On Session    alias=CompassServerRest    url=usuarios    json=${body}
    Set Test Variable    ${RESPOSTA}    ${resposta.json()}

Listar Usuario e verificar se deu certo
    Dictionary Should Contain Item    ${RESPOSTA}    message    Cadastro realizado com sucesso
    Dictionary Should Contain Key     ${RESPOSTA}    _id
    Set Suite Variable    ${ID_USUARIO}    ${RESPOSTA}[_id]
    ${resposta_get}    GET On Session    alias=CompassServerRest    url=usuarios/${ID_USUARIO}
    Dictionary Should Contain Key    ${resposta_get.json()}    nome

Realizar Login
    ${body}    Create Dictionary    email=${EMAIL_TESTE}    password=teste
    ${resposta_login}    POST On Session    alias=CompassServerRest    url=login    json=${body}
    Dictionary Should Contain Item    ${resposta_login.json()}    message    Login realizado com sucesso
    Set Test Variable    ${TOKEN}    ${resposta_login.json()}[authorization]

Editar Usuario
    ${nome}    Gerar Nome Aleatorio
    ${body}    Create Dictionary
    ...    nome=${nome} Editado
    ...    email=${EMAIL_TESTE}
    ...    password=teste
    ...    administrador=true
    ${resposta_put}    PUT On Session    alias=CompassServerRest    url=usuarios/${ID_USUARIO}    json=${body}
    Dictionary Should Contain Item    ${resposta_put.json()}    message    Registro alterado com sucesso

Excluir Usuario
    ${resposta_del}    DELETE On Session    alias=CompassServerRest    url=usuarios/${ID_USUARIO}
    Dictionary Should Contain Item    ${resposta_del.json()}    message    Registro excluído com sucesso

Criar Produto Novo
    Gerar Nome Produto Aleatorio

Cadastrar Produto
    ${headers}    Create Dictionary    Authorization=${TOKEN}
    ${body}    Create Dictionary    nome=${NOME_PRODUTO}    preco=250    descricao=Produto criado via Robot    quantidade=100
    ${resposta_produto}    POST On Session
    ...    alias=CompassServerRest    url=produtos    json=${body}    headers=${headers}
    Dictionary Should Contain Item    ${resposta_produto.json()}    message    Cadastro realizado com sucesso
    Set Test Variable    ${ID_PRODUTO}    ${resposta_produto.json()}[_id]

Listar Produto e verificar se deu certo
    ${resposta_get}    GET On Session    alias=CompassServerRest    url=produtos/${ID_PRODUTO}
    Dictionary Should Contain Item    ${resposta_get.json()}    nome    ${NOME_PRODUTO}

Editar Produto
    ${headers}    Create Dictionary    Authorization=${TOKEN}
    ${body}    Create Dictionary    nome=${NOME_PRODUTO} Editado    preco=300    descricao=Produto Editado via Robot    quantidade=150
    ${resposta_put}    PUT On Session
    ...    alias=CompassServerRest    url=produtos/${ID_PRODUTO}    json=${body}    headers=${headers}
    Dictionary Should Contain Item    ${resposta_put.json()}    message    Registro alterado com sucesso

Excluir Produto
    ${headers}    Create Dictionary    Authorization=${TOKEN}
    ${resposta_del}    DELETE On Session
    ...    alias=CompassServerRest    url=produtos/${ID_PRODUTO}    headers=${headers}
    Dictionary Should Contain Item    ${resposta_del.json()}    message    Registro excluído com sucesso

Criar Carrinho Novo
    Criar Produto Novo
    Cadastrar Produto

Cadastrar Carrinho
    ${headers}    Create Dictionary    Authorization=${TOKEN}
    ${produto_dict}    Create Dictionary    idProduto=${ID_PRODUTO}    quantidade=2
    ${lista_produtos}    Create List    ${produto_dict}
    ${body}    Create Dictionary    produtos=${lista_produtos}
    ${resposta_carrinho}    POST On Session
    ...    alias=CompassServerRest    url=carrinhos    json=${body}    headers=${headers}
    Dictionary Should Contain Item    ${resposta_carrinho.json()}    message    Cadastro realizado com sucesso
    Set Test Variable    ${ID_CARRINHO}    ${resposta_carrinho.json()}[_id]

Listar Carrinho por ID e verificar se deu certo
    ${resposta_get}    GET On Session    alias=CompassServerRest    url=carrinhos/${ID_CARRINHO}
    Dictionary Should Contain Key    ${resposta_get.json()}    _id

Excluir Carrinho
    ${headers}    Create Dictionary    Authorization=${TOKEN}
    ${resposta_del}    DELETE On Session
    ...    alias=CompassServerRest    url=carrinhos/cancelar-compra    headers=${headers}
    Run Keyword And Continue On Failure    Dictionary Should Contain Item    ${resposta_del.json()}    message    Registro excluído com sucesso.
    ##^Necessario sempre que tem um bug#######
