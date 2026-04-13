# ServeRest API

## Visão Geral
API REST gratuita que simula uma loja virtual, utilizada para estudos e testes de API.

**Base URL**
```
https://compassuol.serverest.dev
```

---

## Autenticação e Segurança

### POST /login
Realiza login do usuário e retorna um token JWT.

- O token retornado tem validade de **600 segundos (10 minutos)**.
- Ao expirar, qualquer requisição protegida retorna **401 Unauthorized**.

**Request Body**
```json
{
  "email": "fulano@qa.com",
  "password": "teste"
}
```

**Resposta 200**
```json
{
  "message": "Login realizado com sucesso",
  "authorization": "Bearer <token>"
}
```

**Resposta 401**
```json
{
  "message": "E-mail e/ou senha inválidos"
}
```

---

## Controle de Acesso (Administrador)

Algumas rotas exigem que o usuário autenticado possua o campo:
```json
"administrador": "true"
```

Rotas exclusivas para administradores:
- POST /produtos
- PUT /produtos/{_id}
- DELETE /produtos/{_id}

Caso o usuário não seja administrador, a API retorna **403 Forbidden**.

---

## Usuários

### GET /usuarios
Lista usuários cadastrados.

**Query Params (opcionais):**
- `_id`
- `nome`
- `email`
- `password`
- `administrador` (true | false)

**Resposta 200**
```json
{
  "quantidade": 1,
  "usuarios": [
    {
      "nome": "Fulano da Silva",
      "email": "fulano@qa.com",
      "password": "teste",
      "administrador": "true",
      "_id": "0uxuPY0cbmQhpEz1"
    }
  ]
}
```

---

### POST /usuarios
Cadastra um novo usuário.

- Não é permitido cadastrar usuários com **email duplicado**.

**Request Body**
```json
{
  "nome": "Fulano da Silva",
  "email": "fulano@qa.com",
  "password": "teste",
  "administrador": "true"
}
```

**Respostas**
- 201 Created – Cadastro realizado com sucesso
- 400 Bad Request – Email já cadastrado

---

### GET /usuarios/{_id}
Busca usuário por ID.

**Resposta 200**
```json
{
  "nome": "Fulano da Silva",
  "email": "fulano@qa.com",
  "password": "teste",
  "administrador": "true",
  "_id": "0uxuPY0cbmQhpEz1"
}
```

---

### PUT /usuarios/{_id}
Edita um usuário existente.

⚠️ **Regra importante:**
- Caso o ID informado **não exista**, a API **cria um novo usuário**.
- Não é permitido reutilizar email já cadastrado.

---

### DELETE /usuarios/{_id}
Exclui usuário.

⚠️ **Regra de negócio:**
- Não é permitido excluir usuários que possuam carrinho cadastrado.

**Erro 400**
```json
{
  "message": "Não é permitido excluir usuário com carrinho cadastrado",
  "idCarrinho": "qbMqntef4iTOwWfg"
}
```

---

## Produtos

### GET /produtos
Lista produtos cadastrados.

**Query Params (opcionais):**
- `_id`
- `nome`
- `descricao`
- `preco` (inteiro >= 1)
- `quantidade` (inteiro >= 0)

**Resposta 200**
```json
{
  "quantidade": 1,
  "produtos": [
    {
      "nome": "Logitech MX Vertical",
      "preco": 470,
      "descricao": "Mouse",
      "quantidade": 381,
      "_id": "BeeJh5lz3k6kSIzA"
    }
  ]
}
```

---

### POST /produtos (Admin)
Cadastra produto.

⚠️ Não é permitido cadastrar produto com **nome duplicado**.

**Respostas comuns:**
- 201 Created
- 400 – Produto já existente
- 401 – Token inválido ou expirado
- 403 – Rota exclusiva para administradores

---

### DELETE /produtos/{_id}
Exclui produto.

⚠️ **Regra de negócio:**
- Não é permitido excluir produto que faz parte de um carrinho.

---

## Carrinhos

### Estrutura do Objeto Carrinho

```json
{
  "produtos": [
    {
      "idProduto": "BeeJh5lz3k6kSIzA",
      "quantidade": 1,
      "precoUnitario": 470
    }
  ],
  "precoTotal": 470,
  "quantidadeTotal": 1,
  "idUsuario": "0uxuPY0cbmQhpEz1",
  "_id": "aFOUqntef4iaOwWfg"
}
```

---

### GET /carrinhos
Lista carrinhos cadastrados (1 por usuário).

**Query Params:**
- `_id`
- `precoTotal` (>= 1)
- `quantidadeTotal` (>= 0)
- `idUsuario`

---

### POST /carrinhos
Cria carrinho para usuário autenticado.

### DELETE /carrinhos/concluir-compra
Finaliza compra e remove carrinho.

### DELETE /carrinhos/cancelar-compra
Cancela compra e retorna produtos ao estoque.
