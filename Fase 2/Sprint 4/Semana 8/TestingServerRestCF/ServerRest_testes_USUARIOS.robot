*** Settings ***
Documentation    Essa suite testa o site compassuol.serverest.dev
Resource    ../TestingServerRest/resources/ServerRest_Resources_usuarios.robot
    

*** Test Cases ***
CT-01 Validar bloqueio de duplicidade no cadastro de email
    [Documentation]    Garantir que a API não permita cadastrar dois usuários com o mesmo email.
    ...                Resultado esperado: Status 400 Bad Request.
    [Tags]    usuarios    business_rule    data

    Criar Sessão na ServerRest
    Criar Usuario Novo Aleatorio
    Cadastrar Usuario ADM
    Tentar cadastrar usuario com email ja existente
    Validar status code 400 e mensagem de email em uso

CT-02 Validar sanitizacao de formato de email no cadastro
    [Documentation]    Verificar se a API rejeita emails fora do padrão (sem @ ou dominio).
    ...                Resultado esperado: Status 400 Bad Request.
    [Tags]    usuarios    data    errors

    Criar Sessão na ServerRest
    Tentar cadastrar usuario com formato de email invalido
    Validar status code 400 e mensagem de erro de email do cadastro

CT-03 Validar obrigatoriedade do campo senha no cadastro
    [Documentation]    Garantir que não seja possível criar um usuário sem fornecer uma senha.
    ...                Resultado esperado: Status 400 Bad Request.
    [Tags]    usuarios    data    errors

    Criar Sessão na ServerRest
    Tentar cadastrar usuario sem enviar a senha
    Validar status code 400 e mensagem de senha em branco do cadastro

CT-04 Validar sanitizacao de campos em branco no cadastro (Bug-02)
    [Documentation]    Verificar se a API bloqueia o cadastro de usuário enviando nome e password vazios.
    ...                Resultado esperado: Status 400 Bad Request.
    [Tags]    bug    usuarios    data    errors

    Criar Sessão na ServerRest
    Tentar cadastrar usuario com nome e senha em branco
    Validar status code 400 e mensagem de erro de campos em branco
