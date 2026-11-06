# API FastMob

Contrato entre o app e o backend. Os exemplos de request e response são os
mesmos usados nos testes do app.

| Documento | Conteúdo |
| --- | --- |
| [auth.md](auth.md) | Login, cadastro e perfil |
| [rides.md](rides.md) | Estimativa, pedido, acompanhamento, cancelamento e histórico de corridas |

## Convenções

| Item | Regra |
| --- | --- |
| Base URL (dev) | `http://localhost:8080` (emulador Android: `http://10.0.2.2:8080`) |
| Formato | JSON, UTF-8. Enviar `Content-Type: application/json` |
| Autenticação | `Authorization: Bearer <token>` em tudo, exceto `/auth/login` e `/auth/register` |
| Dinheiro | Inteiro em **centavos** (`1240` = R$ 12,40), com `currency: "BRL"` |
| Datas | ISO 8601 em UTC (`2026-10-30T22:15:00Z`) |
| Coordenadas | `{ "lat": -10.1844, "lng": -48.3336 }` (graus decimais, WGS 84) |
| Nomes de campo | `snake_case` |
| Identificadores | Strings opacas (`ride_8f3k2`), o app nunca interpreta o conteúdo |

## Formato de erro

Toda resposta de erro (4xx e 5xx) tem o mesmo corpo:

```json
{
  "error": {
    "code": "invalid_credentials",
    "message": "E-mail ou senha incorretos.",
    "fields": {}
  }
}
```

| Campo | Tipo | Descrição |
| --- | --- | --- |
| `error.code` | string | Código estável para o app tomar decisões. |
| `error.message` | string | Texto legível, em português. |
| `error.fields` | object | Só em `422`: mapa `campo -> motivo`. |

### Status HTTP usados

| Status | Significado | Exemplo de `code` |
| --- | --- | --- |
| `400` | Requisição malformada | `malformed_request` |
| `401` | Sem token, token expirado ou credenciais erradas | `invalid_credentials`, `token_expired` |
| `403` | Sem permissão para este recurso | `forbidden` |
| `404` | Recurso não existe | `ride_not_found` |
| `409` | Conflito com o estado atual | `ride_not_cancellable`, `ride_in_progress` |
| `422` | Campos ausentes ou inválidos | `validation_failed` |
| `429` | Muitas requisições | `rate_limited` |
| `5xx` | Falha do servidor | `internal_error` |

> O app (`ServerLoginReal`) decide pelo **status HTTP**; `error.code` fica
> disponível para telas futuras sem mudar o contrato.

## Paginação

Listas usam cursor:

```text
GET /rides?limit=20&cursor=abc123
```

```json
{ "items": [], "next_cursor": "def456" }
```

`next_cursor` é `null` na última página.

## Idempotência

`POST /rides` aceita o header `Idempotency-Key` (UUID gerado pelo app). Repetir
a mesma chave devolve a corrida já criada em vez de criar outra, o que evita
corrida duplicada quando o usuário toca duas vezes ou a rede cai.
