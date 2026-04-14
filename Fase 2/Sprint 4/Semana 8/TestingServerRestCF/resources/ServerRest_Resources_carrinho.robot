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
    ...    msg=Sad Path: POST /carrinhos deve retornar status 400 ao tentar criar segundo carrinho para mesmo usuário (limite de 1 carrinho ativo)
    Run Keyword And Continue On Failure    Dictionary Should Contain Item    ${RESPOSTA_ERRO.json()}    message    Não é permitido ter mais de 1 carrinho
    ...    msg=Regra de negócio: Sistema permite apenas 1 carrinho ativo por usuário

Validar status code 400 e mensagem de estoque insuficiente
    Should Be Equal As Integers    ${RESPOSTA_ERRO.status_code}    400
    ...    msg=Sad Path: POST /carrinhos deve retornar status 400 ao tentar adicionar quantidade maior que estoque disponível (validação de limite)
    Run Keyword And Continue On Failure    Dictionary Should Contain Item    ${RESPOSTA_ERRO.json()}    message    Produto não possui quantidade suficiente
    ...    msg=Regra de negócio: API valida disponibilidade de estoque antes de adicionar produto ao carrinho

Validar status code 400 e mensagem de produto duplicado
    Should Be Equal As Integers    ${RESPOSTA_ERRO.status_code}    400
    ...    msg=Sad Path: POST /carrinhos deve retornar status 400 ao enviar mesmo ID de produto duplicado no payload (validação de estrutura)
    Run Keyword And Continue On Failure    Dictionary Should Contain Item    ${RESPOSTA_ERRO.json()}    message    Não é permitido possuir produto duplicado
    ...    msg=Regra de negócio: Para aumentar quantidade, deve-se alterar o campo 'quantidade', não duplicar o ID do produto

Validar status code 401 e mensagem de token ausente
    Should Be Equal As Integers    ${RESPOSTA_ERRO.status_code}    401
    ...    msg=Sad Path: POST /carrinhos deve retornar status 401 ao tentar criar carrinho sem token JWT (barreira de autenticação)
    Run Keyword And Continue On Failure    Dictionary Should Contain Item    ${RESPOSTA_ERRO.json()}    message    Token de acesso ausente, inválido, expirado ou usuário do token não existe mais
    ...    msg=Regra de segurança: API exige autenticação válida para operações com carrinho

Validar status code 200 e exclusao bem sucedida
    Should Be Equal As Integers    ${RESPOSTA.status_code}    200
    ...    msg=Happy Path: DELETE /carrinhos/concluir-compra ou /cancelar-compra deve retornar status 200 ao finalizar operação
    Log    Resposta recebida: ${RESPOSTA.json()}    
    Run Keyword And Continue On Failure    Dictionary Should Contain Item    ${RESPOSTA.json()}    message    Registro excluído com sucesso
    ...    msg=Regra de negócio: API deve confirmar exclusão do carrinho após conclusão ou cancelamento da compra

Cancelar a compra do carrinho
    ${headers}    Create Dictionary    Authorization=${TOKEN}
    ${resposta}    DELETE On Session
    ...    alias=CompassServerRest    url=carrinhos/cancelar-compra    headers=${headers}
    Set Test Variable    ${RESPOSTA}    ${resposta}

Tentar cadastrar carrinho com quantidade zero
    ${produto}    Create Dictionary    idProduto=${ID_PRODUTO}    quantidade=0
    ${lista_produtos}    Create List    ${produto}
    ${body}    Create Dictionary    produtos=${lista_produtos}
    ${headers}    Create Dictionary    Authorization=${TOKEN}
    ${resposta_errada}    POST On Session
    ...    alias=CompassServerRest    url=carrinhos    json=${body}    headers=${headers}    expected_status=any
    Set Test Variable    ${RESPOSTA_ERRO}    ${resposta_errada}

Validar status code 400 e mensagem de quantidade invalida
    Should Be Equal As Integers    ${RESPOSTA_ERRO.status_code}    400
    ...    msg=Sad Path: POST /carrinhos deve retornar status 400 ao tentar adicionar produto com quantidade zero (validação de dados)
    Run Keyword And Continue On Failure    Dictionary Should Contain Item    ${RESPOSTA_ERRO.json()}    message    Produto não possui quantidade suficiente
    ...    msg=Regra de negócio: Quantidade de produtos no carrinho deve ser maior que zero

Tentar cadastrar carrinho com lista de produtos vazia
    ${lista_produtos}    Create List
    ${body}    Create Dictionary    produtos=${lista_produtos}
    ${headers}    Create Dictionary    Authorization=${TOKEN}
    ${resposta_errada}    POST On Session
    ...    alias=CompassServerRest    url=carrinhos    json=${body}    headers=${headers}    expected_status=any
    Set Test Variable    ${RESPOSTA_ERRO}    ${resposta_errada}

Validar status code 400 e mensagem de carrinho vazio
    Should Be Equal As Integers    ${RESPOSTA_ERRO.status_code}    400
    ...    msg=Sad Path: POST /carrinhos deve retornar status 400 ao tentar criar carrinho sem produtos (validação de estrutura)
    Run Keyword And Continue On Failure    Dictionary Should Contain Item    ${RESPOSTA_ERRO.json()}    message    Carrinho inválido
    ...    msg=Regra de negócio: Carrinho deve conter pelo menos um produto
