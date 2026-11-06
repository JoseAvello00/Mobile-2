# Autenticação

## Login

Autentica uma pessoa usuária e devolve o token usado nas próximas requisições.
O app consome este contrato em `ServerLoginReal`.

| Item | Valor |
| --- | --- |
| Método | `POST` |
| Rota | `/auth/login` |
| Content-Type | `application/json` |
| Autenticação | Não necessária |

### Request

```json
{
  "email": "ana@fastmob.dev",
  "password": "123456"
}
```

| Campo | Tipo | Obrigatório | Descrição |
| --- | --- | --- | --- |
| `email` | string | Sim | E-mail da conta. |
| `password` | string | Sim | Senha da conta. |

### Response — sucesso (`200 OK`)

```json
{
  "token": "eyJhbGciOiJIUzI1NiJ9...",
  "expires_in": 3600,
  "user": {
    "id": "usr_41a9",
    "name": "Ana Ribeiro",
    "email": "ana@fastmob.dev"
  }
}
```

| Campo | Tipo | Descrição |
| --- | --- | --- |
| `token` | string | Token de acesso da sessão (JWT). |
| `expires_in` | integer | Validade do token, em segundos. |
| `user.id` | string | Identificador da pessoa usuária. |
| `user.name` | string | Nome a exibir. |
| `user.email` | string | E-mail da conta. |

O app hoje lê apenas `token` e `user.name`; os demais campos podem ser
ignorados sem quebrar nada.

### Responses de erro

| Status | `error.code` | Quando ocorre | Tratamento no app |
| --- | --- | --- | --- |
| `401` | `invalid_credentials` | E-mail ou senha inválidos. | “E-mail ou senha incorretos.” |
| `422` | `validation_failed` | E-mail ou senha ausentes ou inválidos. | “Informe e-mail e senha.” |
| `429` | `rate_limited` | Tentativas demais. | “Erro no servidor (429).” |
| `5xx` | `internal_error` | Falha inesperada. | “Erro no servidor (`<status>`).” |

Exemplo `422`:

```json
{
  "error": {
    "code": "validation_failed",
    "message": "Dados inválidos.",
    "fields": { "email": "obrigatório", "password": "obrigatório" }
  }
}
```

## Cadastro

Cria a conta e já devolve a sessão (mesma resposta do login).

| Item | Valor |
| --- | --- |
| Método | `POST` |
| Rota | `/auth/register` |
| Autenticação | Não necessária |

### Request

```json
{
  "name": "Ana Ribeiro",
  "email": "ana@fastmob.dev",
  "phone": "+5563999990000",
  "password": "S3nha-forte"
}
```

| Campo | Tipo | Obrigatório | Descrição |
| --- | --- | --- | --- |
| `name` | string | Sim | Nome completo. |
| `email` | string | Sim | E-mail único. |
| `phone` | string | Sim | Celular em formato E.164. |
| `password` | string | Sim | Mínimo de 8 caracteres. |

### Response — `201 Created`

Mesmo corpo do [login](#response--sucesso-200-ok).

### Erros

| Status | `error.code` | Quando ocorre |
| --- | --- | --- |
| `409` | `email_taken` | Já existe conta com este e-mail. |
| `422` | `validation_failed` | Campo ausente ou inválido (veja `error.fields`). |

## Perfil

Devolve a pessoa autenticada.

| Item | Valor |
| --- | --- |
| Método | `GET` |
| Rota | `/me` |
| Autenticação | `Authorization: Bearer <token>` |

### Response — `200 OK`

```json
{
  "id": "usr_41a9",
  "name": "Ana Ribeiro",
  "email": "ana@fastmob.dev",
  "phone": "+5563999990000",
  "rating": 4.95,
  "rides_count": 37
}
```

### Erros

| Status | `error.code` | Quando ocorre |
| --- | --- | --- |
| `401` | `token_expired` | Token expirado ou inválido: o app volta ao login. |

## Ambiente local

`ServerLoginReal` usa `http://localhost:8080` em desktop e web. No emulador
Android usa `http://10.0.2.2:8080`, que aponta para a máquina hospedeira. O
tempo limite da requisição é de dez segundos.
