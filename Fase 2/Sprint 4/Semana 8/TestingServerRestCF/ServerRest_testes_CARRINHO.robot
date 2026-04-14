*** Settings ***
Documentation    Essa suite testa o site compassuol.serverest.dev
Resource    ../TestingServerRestCF/resources/ServerRest_Resources_carrinho.robot
    

*** Test Cases ***

CT-01 Validar regra de negocio: Limite de um carrinho por usuario
    [Documentation]    Garantir que o sistema bloqueie a criação de um segundo carrinho para um usuário que já possui um ativo.
    ...                Resultado esperado: Status 400 Bad Request.
    [Tags]    carrinho    business_rule    errors

    Criar Sessão na ServerRest
    Criar Usuario Novo Aleatorio
    Cadastrar Usuario ADM
    Realizar Login
    Criar Produto Novo
    Cadastrar Produto
    Criar Carrinho Novo
    Cadastrar Carrinho
    Tentar cadastrar um segundo carrinho para o mesmo usuario
    Validar status code 400 e mensagem de limite de carrinho

CT-02 Validar regra de negocio: Bloqueio de estoque insuficiente
    [Documentation]    Verificar se a API impede a adição de uma quantidade de produtos maior do que a disponível no estoque.
    ...                Resultado esperado: Status 400 Bad Request.
    [Tags]    carrinho    business_rule    data

    Criar produto com estoque limitado
    Tentar cadastrar carrinho com quantidade maior que o estoque
    Validar status code 400 e mensagem de estoque insuficiente

CT-03 Validar regra de negocio: Produtos duplicados no payload
    [Documentation]    A API exige que para aumentar a quantidade de um produto, mude-se o campo "quantidade", e não envie o mesmo ID duas vezes.
    ...                Resultado esperado: Status 400 Bad Request.
    [Tags]    carrinho    business_rule    data

    Criar Sessão na ServerRest
    Criar Usuario Novo Aleatorio
    Cadastrar Usuario ADM
    Realizar Login
    Criar Produto Novo
    Cadastrar Produto
    Tentar cadastrar carrinho com o mesmo ID de produto duplicado
    Validar status code 400 e mensagem de produto duplicado

CT-04 Validar barreira de autenticação na criação do carrinho
    [Documentation]    Verificar se é impossível interagir com carrinhos sem enviar um Token Bearer válido.
    ...                Resultado esperado: Status 401 Unauthorized.
    [Tags]    carrinho    authorization    errors

    Criar Sessão na ServerRest
    Criar Produto Novo
    Tentar cadastrar carrinho sem enviar Token de autorizacao
    Validar status code 401 e mensagem de token ausente

CT-05 Validar fluxo de Conclusão de Compra e baixa de estoque
    [Documentation]    Garantir que ao concluir a compra, o carrinho seja excluído.
    ...                Resultado esperado: Status 200 OK.
    [Tags]    carrinho    lifecycle    delete    

    Criar Sessão na ServerRest
    Criar Usuario Novo Aleatorio
    Cadastrar Usuario ADM
    Realizar Login
    Criar Produto Novo
    Cadastrar Produto
    Criar Carrinho Novo
    Cadastrar Carrinho
    Concluir a compra do carrinho
    Validar status code 200 e exclusao bem sucedida

CT-07 Validar sanitizacao com quantidade zero no carrinho
    [Documentation]    Verificar se a API valida que a quantidade de produtos no carrinho deve ser maior que zero.
    ...                Resultado esperado: Status 400 Bad Request.
    [Tags]    carrinho    data    errors    bug

    Criar Sessão na ServerRest
    Criar Usuario Novo Aleatorio
    Cadastrar Usuario ADM
    Realizar Login
    Criar Produto Novo
    Cadastrar Produto
    Tentar cadastrar carrinho com quantidade zero
    Validar status code 400 e mensagem de quantidade invalida

CT-08 Validar sanitizacao com lista de produtos vazia
    [Documentation]    Verificar se a API valida que o carrinho deve conter pelo menos um produto.
    ...                Resultado esperado: Status 400 Bad Request.
    [Tags]    carrinho    data    errors    bug

    Criar Sessão na ServerRest
    Criar Usuario Novo Aleatorio
    Cadastrar Usuario ADM
    Realizar Login
    Tentar cadastrar carrinho com lista de produtos vazia
    Validar status code 400 e mensagem de carrinho vazio
