*** Settings ***
Library    RequestsLibrary
Library    String
Library    Collections

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
############      ############
############  HP  ############
############      ############
Criar Usuario Novo Aleatorio
    ${palavra_aleatorio}    Generate Random String    length=4    chars=[LETTERS]
    ${palavra_aleatorio}    Convert To Lower Case    ${palavra_aleatorio}
    Set Test Variable    ${EMAIL_TESTE}    ${palavra_aleatorio}@teste.com

Cadastrar Usuario ADM
    #Criando dicionario com os dados padrão para o teste
    ${body}    Create Dictionary    
    ...    nome=Fulano da Silva    
    ...    email=${EMAIL_TESTE}   
    ...    password=teste    
    ...    administrador=true

    Criar Sessão na ServerRest

    ${resposta}    POST On Session    
    ...    alias=CompassServerRest    
    ...    url=usuarios    
    ...    json=${body}

    Log    ${resposta.json()}

    Set Test Variable    ${RESPOSTA}    ${resposta.json()}

Criar Sessão na ServerRest

    ${headers}  Create Dictionary    accept=application/json    Content-Type=application/json
    Create Session    alias=CompassServerRest    url=${URL}    headers=${headers}

Listar Usuario e verificar se deu certo
    Log    ${RESPOSTA}
    Dictionary Should Contain Item    ${RESPOSTA}    message    Cadastro realizado com sucesso
    Dictionary Should Contain Key     ${RESPOSTA}    _id
    
    # Captura o id e salva para a suite toda poder usar
    ${id_capturado}    Set Variable    ${RESPOSTA}[_id]
    Set Suite Variable    ${ID_USUARIO}    ${id_capturado}
    
    Log    ${ID_USUARIO}

    ${resposta_get}    GET On Session
    ...    alias=CompassServerRest    
    ...    url=usuarios/${ID_USUARIO}
    
    Dictionary Should Contain Item    ${resposta_get.json()}    nome    Fulano da Silva  

Realizar Login
    ${body}    Create Dictionary    email=${EMAIL_TESTE}    password=teste
    ${resposta_login}    POST On Session    
    ...    alias=CompassServerRest    
    ...    url=login    
    ...    json=${body}
    
    Dictionary Should Contain Item    ${resposta_login.json()}    message    Login realizado com sucesso
    
    # guardando o Token gerado no login
    Set Test Variable    ${TOKEN}    ${resposta_login.json()}[authorization]

Editar Usuario
    ${body}    Create Dictionary    
    ...    nome=Fulano da Silva Editado    
    ...    email=${EMAIL_TESTE}   
    ...    password=teste    
    ...    administrador=true

    ${resposta_put}    PUT On Session    
    ...    alias=CompassServerRest    
    ...    url=usuarios/${ID_USUARIO}    
    ...    json=${body}
    Dictionary Should Contain Item    ${resposta_put.json()}    message    Registro alterado com sucesso

Criar Produto Novo
    ${palavra_aleatoria}    Generate Random String    length=5    chars=[LETTERS]
    Set Test Variable    ${NOME_PRODUTO}    Produto Automation ${palavra_aleatoria}

Cadastrar Produto
    ${headers}    Create Dictionary    Authorization=${TOKEN}
    ${body}    Create Dictionary    nome=${NOME_PRODUTO}    preco=250    descricao=Produto criado via Robot    quantidade=100
    
    ${resposta_produto}    POST On Session    
    ...    alias=CompassServerRest    
    ...    url=produtos    
    ...    json=${body}    
    ...    headers=${headers}
    
    Dictionary Should Contain Item    ${resposta_produto.json()}    message    Cadastro realizado com sucesso
    Set Test Variable    ${ID_PRODUTO}    ${resposta_produto.json()}[_id]

Listar Produto e verificar se deu certo
    ${resposta_get_prod}    GET On Session    
    ...    alias=CompassServerRest    
    ...    url=produtos/${ID_PRODUTO}
    Dictionary Should Contain Item    ${resposta_get_prod.json()}    nome    ${NOME_PRODUTO}

Editar Produto
    ${headers}    Create Dictionary    Authorization=${TOKEN}
    ${body}    Create Dictionary    nome=${NOME_PRODUTO} Editado    preco=300    descricao=Produto Editado via Robot    quantidade=150
    
    ${resposta_put_prod}    PUT On Session    
    ...    alias=CompassServerRest    
    ...    url=produtos/${ID_PRODUTO}    
    ...    json=${body}    
    ...    headers=${headers}
    Dictionary Should Contain Item    ${resposta_put_prod.json()}    message    Registro alterado com sucesso

Excluir Produto
    ${headers}    Create Dictionary    Authorization=${TOKEN}
    ${resposta_del_prod}    DELETE On Session    
    ...    alias=CompassServerRest    
    ...    url=produtos/${ID_PRODUTO}    
    ...    headers=${headers}
    Dictionary Should Contain Item    ${resposta_del_prod.json()}    message    Registro excluído com sucesso

Criar Carrinho Novo
    Criar Produto Novo
    Cadastrar Produto

Cadastrar Carrinho
    ${headers}    Create Dictionary    Authorization=${TOKEN}
    
    # O payload de carrinho exige uma lista de produtos dentro do JSON
    ${produto_dict}    Create Dictionary    idProduto=${ID_PRODUTO}    quantidade=2
    ${lista_produtos}  Create List          ${produto_dict}
    ${body}            Create Dictionary    produtos=${lista_produtos}
    
    ${resposta_carrinho}    POST On Session    
    ...    alias=CompassServerRest    
    ...    url=carrinhos    
    ...    json=${body}    
    ...    headers=${headers}
    
    Dictionary Should Contain Item    ${resposta_carrinho.json()}    message    Cadastro realizado com sucesso
    Set Test Variable    ${ID_CARRINHO}    ${resposta_carrinho.json()}[_id]

Listar Carrinho por ID e verificar se deu certo
    ${resposta_get_car}    GET On Session    
    ...    alias=CompassServerRest    
    ...    url=carrinhos/${ID_CARRINHO}
    Dictionary Should Contain Key    ${resposta_get_car.json()}    _id

Excluir Carrinho
    ${headers}    Create Dictionary    Authorization=${TOKEN}
    
    # O ServeRest limpa o carrinho através da rota de cancelar ou concluir compra
    ${resposta_del_car}    DELETE On Session    
    ...    alias=CompassServerRest    
    ...    url=carrinhos/cancelar-compra    
    ...    headers=${headers}
    Run Keyword And Continue On Failure    Dictionary Should Contain Item    ${resposta_del_car.json()}    message    Registro excluído com sucesso.
     ##^Necessario sempre que tem um bug####### 

Excluir Usuario
    ${resposta_del_user}    DELETE On Session    alias=CompassServerRest    url=usuarios/${ID_USUARIO}
    Dictionary Should Contain Item    ${resposta_del_user.json()}    message    Registro excluído com sucesso

    
