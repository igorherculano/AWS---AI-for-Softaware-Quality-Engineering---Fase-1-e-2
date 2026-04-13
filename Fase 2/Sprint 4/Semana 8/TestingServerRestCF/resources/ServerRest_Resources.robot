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
    ...    msg=Regra de negócio: API deve confirmar cadastro de usuário com mensagem de sucesso
    Dictionary Should Contain Key     ${RESPOSTA}    _id
    ...    msg=Contrato da API: Resposta de cadastro deve retornar o campo _id do usuário criado
    Set Suite Variable    ${ID_USUARIO}    ${RESPOSTA}[_id]
    ${resposta_get}    GET On Session    alias=CompassServerRest    url=usuarios/${ID_USUARIO}
    Should Be Equal As Integers    ${resposta_get.status_code}    200
    ...    msg=Happy Path: GET /usuarios/{_id} deve retornar status 200 para usuário existente
    Dictionary Should Contain Key    ${resposta_get.json()}    nome
    ...    msg=Contrato da API: Resposta deve conter o campo obrigatório 'nome' do usuário

Realizar Login
    ${body}    Create Dictionary    email=${EMAIL_TESTE}    password=teste
    ${resposta_login}    POST On Session    alias=CompassServerRest    url=login    json=${body}
    Should Be Equal As Integers    ${resposta_login.status_code}    200
    ...    msg=Happy Path: POST /login deve retornar status 200 para credenciais válidas
    Dictionary Should Contain Item    ${resposta_login.json()}    message    Login realizado com sucesso
    ...    msg=Regra de negócio: API deve confirmar autenticação bem-sucedida com mensagem específica
    Dictionary Should Contain Key    ${resposta_login.json()}    authorization
    ...    msg=Contrato da API: Resposta de login deve retornar token JWT no campo 'authorization'
    Set Test Variable    ${TOKEN}    ${resposta_login.json()}[authorization]

Editar Usuario
    ${nome}    Gerar Nome Aleatorio
    ${body}    Create Dictionary
    ...    nome=${nome} Editado
    ...    email=${EMAIL_TESTE}
    ...    password=teste
    ...    administrador=true
    ${resposta_put}    PUT On Session    alias=CompassServerRest    url=usuarios/${ID_USUARIO}    json=${body}
    Should Be Equal As Integers    ${resposta_put.status_code}    200
    ...    msg=Happy Path: PUT /usuarios/{_id} deve retornar status 200 ao editar usuário existente
    Dictionary Should Contain Item    ${resposta_put.json()}    message    Registro alterado com sucesso
    ...    msg=Regra de negócio: API deve confirmar edição de usuário com mensagem de sucesso

Excluir Usuario
    ${resposta_del}    DELETE On Session    alias=CompassServerRest    url=usuarios/${ID_USUARIO}
    Should Be Equal As Integers    ${resposta_del.status_code}    200
    ...    msg=Happy Path: DELETE /usuarios/{_id} deve retornar status 200 ao excluir usuário sem carrinho
    ${msg}    Set Variable    ${resposta_del.json()}[message]
    Should Be True    '${msg}' == 'Registro excluído com sucesso' or '${msg}' == 'Nenhum registro excluído'
    ...    msg=Regra de negócio: API deve confirmar exclusão ou informar que registro não existe


Criar Produto Novo
    Gerar Nome Produto Aleatorio

Cadastrar Produto
    ${headers}    Create Dictionary    Authorization=${TOKEN}
    ${body}    Create Dictionary    nome=${NOME_PRODUTO}    preco=250    descricao=Produto criado via Robot    quantidade=100
    ${resposta_produto}    POST On Session
    ...    alias=CompassServerRest    url=produtos    json=${body}    headers=${headers}
    Should Be Equal As Integers    ${resposta_produto.status_code}    201
    ...    msg=Happy Path: POST /produtos deve retornar status 201 ao criar produto com usuário administrador autenticado
    Dictionary Should Contain Item    ${resposta_produto.json()}    message    Cadastro realizado com sucesso
    ...    msg=Regra de negócio: API deve confirmar cadastro de produto com mensagem de sucesso
    Dictionary Should Contain Key    ${resposta_produto.json()}    _id
    ...    msg=Contrato da API: Resposta de cadastro deve retornar o campo _id do produto criado
    Set Test Variable    ${ID_PRODUTO}    ${resposta_produto.json()}[_id]

Listar Produto e verificar se deu certo
    ${resposta_get}    GET On Session    alias=CompassServerRest    url=produtos/${ID_PRODUTO}
    Should Be Equal As Integers    ${resposta_get.status_code}    200
    ...    msg=Happy Path: GET /produtos/{_id} deve retornar status 200 para produto existente
    Dictionary Should Contain Item    ${resposta_get.json()}    nome    ${NOME_PRODUTO}
    ...    msg=Contrato da API: Resposta deve retornar o nome exato do produto cadastrado

Editar Produto
    ${headers}    Create Dictionary    Authorization=${TOKEN}
    ${body}    Create Dictionary    nome=${NOME_PRODUTO} Editado    preco=300    descricao=Produto Editado via Robot    quantidade=150
    ${resposta_put}    PUT On Session
    ...    alias=CompassServerRest    url=produtos/${ID_PRODUTO}    json=${body}    headers=${headers}
    Should Be Equal As Integers    ${resposta_put.status_code}    200
    ...    msg=Happy Path: PUT /produtos/{_id} deve retornar status 200 ao editar produto com usuário administrador
    Dictionary Should Contain Item    ${resposta_put.json()}    message    Registro alterado com sucesso
    ...    msg=Regra de negócio: API deve confirmar edição de produto com mensagem de sucesso

Excluir Produto
    ${headers}    Create Dictionary    Authorization=${TOKEN}
    ${resposta_del}    DELETE On Session
    ...    alias=CompassServerRest    url=produtos/${ID_PRODUTO}    headers=${headers}
    Should Be Equal As Integers    ${resposta_del.status_code}    200
    ...    msg=Happy Path: DELETE /produtos/{_id} deve retornar status 200 ao excluir produto não vinculado a carrinho
    Dictionary Should Contain Item    ${resposta_del.json()}    message    Registro excluído com sucesso
    ...    msg=Regra de negócio: API deve confirmar exclusão de produto com mensagem de sucesso

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
    Should Be Equal As Integers    ${resposta_carrinho.status_code}    201
    ...    msg=Happy Path: POST /carrinhos deve retornar status 201 ao criar carrinho com usuário autenticado
    Dictionary Should Contain Item    ${resposta_carrinho.json()}    message    Cadastro realizado com sucesso
    ...    msg=Regra de negócio: API deve confirmar criação de carrinho com mensagem de sucesso
    Dictionary Should Contain Key    ${resposta_carrinho.json()}    _id
    ...    msg=Contrato da API: Resposta de cadastro deve retornar o campo _id do carrinho criado
    Set Test Variable    ${ID_CARRINHO}    ${resposta_carrinho.json()}[_id]

Listar Carrinho por ID e verificar se deu certo
    ${resposta_get}    GET On Session    alias=CompassServerRest    url=carrinhos/${ID_CARRINHO}
    Should Be Equal As Integers    ${resposta_get.status_code}    200
    ...    msg=Happy Path: GET /carrinhos/{_id} deve retornar status 200 para carrinho existente
    Dictionary Should Contain Key    ${resposta_get.json()}    _id
    ...    msg=Contrato da API: Resposta deve conter o campo _id do carrinho
    Dictionary Should Contain Key    ${resposta_get.json()}    produtos
    ...    msg=Contrato da API: Resposta deve conter a lista de produtos do carrinho

Excluir Carrinho
    ${headers}    Create Dictionary    Authorization=${TOKEN}
    ${resposta_del}    DELETE On Session
    ...    alias=CompassServerRest    url=carrinhos/cancelar-compra    headers=${headers}
    Run Keyword And Continue On Failure    Dictionary Should Contain Item    ${resposta_del.json()}    message    Registro excluído com sucesso.
    ##^Necessario sempre que tem um bug#######

############  SAD PATH KEYWORDS  ############

Tentar Login Com Credenciais Invalidas
    ${body}    Create Dictionary    email=invalido@email.com    password=senhaerrada
    ${resposta}    POST On Session
    ...    alias=CompassServerRest    url=login    json=${body}
    ...    expected_status=401
    Should Be Equal As Integers    ${resposta.status_code}    401
    ...    msg=Sad Path: POST /login deve retornar status 401 para credenciais inválidas (barreira de autenticação)
    Dictionary Should Contain Item    ${resposta.json()}    message    Email e/ou senha inválidos
    ...    msg=Regra de negócio: API deve bloquear acesso e retornar mensagem específica de erro de autenticação

Cadastrar Usuario Nao ADM
    ${nome}    Gerar Nome Aleatorio
    ${body}    Create Dictionary
    ...    nome=${nome}
    ...    email=${EMAIL_TESTE}
    ...    password=teste
    ...    administrador=false
    ${resposta}    POST On Session    alias=CompassServerRest    url=usuarios    json=${body}
    Set Test Variable    ${RESPOSTA}    ${resposta.json()}

Tentar Cadastrar Usuario Com Email Duplicado
    ${nome}    Gerar Nome Aleatorio
    ${body}    Create Dictionary
    ...    nome=${nome}
    ...    email=${EMAIL_TESTE}
    ...    password=teste
    ...    administrador=true
    ${resposta}    POST On Session
    ...    alias=CompassServerRest    url=usuarios    json=${body}
    ...    expected_status=400
    Should Be Equal As Integers    ${resposta.status_code}    400
    ...    msg=Sad Path: POST /usuarios deve retornar status 400 ao tentar cadastrar email duplicado (bloqueio de unicidade)
    Dictionary Should Contain Item    ${resposta.json()}    message    Este email já está sendo usado
    ...    msg=Regra de negócio: API não permite cadastrar dois usuários com o mesmo email

Tentar Cadastrar Produto Sem Token
    ${body}    Create Dictionary    nome=${NOME_PRODUTO}    preco=250    descricao=Produto sem token    quantidade=10
    ${resposta}    POST On Session
    ...    alias=CompassServerRest    url=produtos    json=${body}
    ...    expected_status=401
    Should Be Equal As Integers    ${resposta.status_code}    401
    ...    msg=Sad Path: POST /produtos deve retornar status 401 ao tentar cadastrar sem token JWT (barreira de autenticação)
    Dictionary Should Contain Item    ${resposta.json()}    message    Token de acesso ausente, inválido, expirado ou usuário do token não existe mais
    ...    msg=Regra de segurança: API exige autenticação válida para manipulação de produtos

Tentar Cadastrar Produto Como Nao ADM
    ${headers}    Create Dictionary    Authorization=${TOKEN}
    ${body}    Create Dictionary    nome=${NOME_PRODUTO}    preco=250    descricao=Produto nao adm    quantidade=10
    ${resposta}    POST On Session
    ...    alias=CompassServerRest    url=produtos    json=${body}    headers=${headers}
    ...    expected_status=403
    Should Be Equal As Integers    ${resposta.status_code}    403
    ...    msg=Sad Path: POST /produtos deve retornar status 403 para usuário não administrador (controle de acesso RBAC)
    Dictionary Should Contain Item    ${resposta.json()}    message    Rota exclusiva para administradores
    ...    msg=Regra de negócio: Apenas usuários com administrador=true podem cadastrar produtos

Tentar Cadastrar Produto Com Nome Duplicado
    ${headers}    Create Dictionary    Authorization=${TOKEN}
    ${body}    Create Dictionary    nome=${NOME_PRODUTO}    preco=250    descricao=Produto duplicado    quantidade=10
    ${resposta}    POST On Session
    ...    alias=CompassServerRest    url=produtos    json=${body}    headers=${headers}
    ...    expected_status=400
    Should Be Equal As Integers    ${resposta.status_code}    400
    ...    msg=Sad Path: POST /produtos deve retornar status 400 ao tentar cadastrar nome duplicado (bloqueio de unicidade)
    Dictionary Should Contain Item    ${resposta.json()}    message    Já existe produto com esse nome
    ...    msg=Regra de negócio: API não permite cadastrar dois produtos com o mesmo nome

Tentar Cadastrar Carrinho Com Produto Inexistente
    ${headers}    Create Dictionary    Authorization=${TOKEN}
    ${produto_dict}    Create Dictionary    idProduto=id_invalido_inexistente    quantidade=1
    ${lista_produtos}    Create List    ${produto_dict}
    ${body}    Create Dictionary    produtos=${lista_produtos}
    ${resposta}    POST On Session
    ...    alias=CompassServerRest    url=carrinhos    json=${body}    headers=${headers}
    ...    expected_status=400
    Should Be Equal As Integers    ${resposta.status_code}    400
    ...    msg=Sad Path: POST /carrinhos deve retornar status 400 ao tentar adicionar produto inexistente (validação de integridade)
    Dictionary Should Contain Item    ${resposta.json()}    message    Produto não encontrado
    ...    msg=Regra de negócio: API valida existência do produto antes de adicionar ao carrinho

Tentar Excluir Produto Em Carrinho
    ${headers}    Create Dictionary    Authorization=${TOKEN}
    ${resposta}    DELETE On Session
    ...    alias=CompassServerRest    url=produtos/${ID_PRODUTO}    headers=${headers}
    ...    expected_status=400
    Should Be Equal As Integers    ${resposta.status_code}    400
    ...    msg=Sad Path: DELETE /produtos/{_id} deve retornar status 400 ao tentar excluir produto vinculado a carrinho (proteção de integridade)
    Dictionary Should Contain Item    ${resposta.json()}    message    Não é permitido excluir produto que faz parte de carrinho
    ...    msg=Regra de negócio: API bloqueia exclusão de produtos que estão em carrinhos ativos

Tentar Excluir Usuario Com Carrinho
    ${resposta}    DELETE On Session
    ...    alias=CompassServerRest    url=usuarios/${ID_USUARIO}
    ...    expected_status=400
    Should Be Equal As Integers    ${resposta.status_code}    400
    ...    msg=Sad Path: DELETE /usuarios/{_id} deve retornar status 400 ao tentar excluir usuário com carrinho ativo (proteção de integridade)
    Dictionary Should Contain Item    ${resposta.json()}    message    Não é permitido excluir usuário com carrinho cadastrado
    ...    msg=Regra de negócio: API bloqueia exclusão de usuários que possuem carrinho cadastrado
