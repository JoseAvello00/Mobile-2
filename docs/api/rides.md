# Corridas

Todas as rotas exigem `Authorization: Bearer <token>`.

## Fluxo

```text
POST /rides/estimates   → quanto custa e quanto demora, por categoria
POST /rides             → pede a corrida (status: searching)
GET  /rides/{id}        → o app consulta a cada poucos segundos
POST /rides/{id}/cancel → cancela, se ainda for possível
GET  /rides             → histórico
```

### Status da corrida

```text
searching → driver_assigned → driver_arriving → in_progress → completed
    │              │                 │
    └──────────────┴─────────────────┴──────────→ cancelled
```

| `status` | Significado | Texto no app |
| --- | --- | --- |
| `searching` | Procurando motorista | “Procurando motorista” |
| `driver_assigned` | Motorista aceitou | “Motorista confirmado” |
| `driver_arriving` | Motorista a caminho do embarque | “A caminho” |
| `in_progress` | Passageiro a bordo | “Em viagem” |
| `completed` | Chegou ao destino | “Concluída” |
| `cancelled` | Cancelada por qualquer parte | “Cancelada” |
| `no_driver` | Ninguém aceitou a tempo | “Sem motoristas” |

### Categorias (`category`)

| Valor | Nome no app | Descrição |
| --- | --- | --- |
| `fast` | Fast | Carro, a opção mais barata |
| `comfort` | Conforto | Carros mais novos e espaçosos |
| `moto` | Moto | Mototáxi |
| `eco` | Eco | Carro 100% elétrico (diferencial sustentável) |

### Impacto ambiental (`co2_grams`, `co2_offset`)

Toda estimativa e toda corrida informam a emissão estimada de CO₂ da viagem.
Os valores são **ilustrativos** (fatores por km definidos pelo projeto, ver
`docs/design/tema.md`), não medições.

| Campo | Tipo | Descrição |
| --- | --- | --- |
| `co2_grams` | integer | Emissão do escapamento na viagem, em gramas. `0` para `eco`. |
| `co2_avoided_grams` | integer | Só em `eco`: o que um carro `fast` emitiria na mesma rota. |
| `co2_offset` | boolean | `true` quando a FastMob compensa a emissão (todas as categorias a combustão). |

## Estimativa

Calcula preço e tempo de chegada para cada categoria disponível. Alimenta a
lista de `RideOptionCard` da Home.

| Item | Valor |
| --- | --- |
| Método | `POST` |
| Rota | `/rides/estimates` |

### Request

```json
{
  "origin": { "lat": -10.1844, "lng": -48.3336, "address": "Quadra 104 Sul" },
  "destination": { "lat": -10.2917, "lng": -48.3573, "address": "Aeroporto de Palmas" }
}
```

| Campo | Tipo | Obrigatório | Descrição |
| --- | --- | --- | --- |
| `origin.lat`, `origin.lng` | number | Sim | Ponto de embarque. |
| `origin.address` | string | Não | Texto para exibir. |
| `destination.lat`, `destination.lng` | number | Sim | Ponto de destino. |
| `destination.address` | string | Não | Texto para exibir. |

### Response — `200 OK`

```json
{
  "distance_m": 14200,
  "duration_s": 1260,
  "options": [
    {
      "category": "fast",
      "name": "Fast",
      "description": "Mais barato",
      "price_cents": 1240,
      "currency": "BRL",
      "eta_seconds": 240,
      "available": true,
      "co2_grams": 2130,
      "co2_offset": true
    },
    {
      "category": "comfort",
      "name": "Conforto",
      "description": "Carros novos",
      "price_cents": 1790,
      "currency": "BRL",
      "eta_seconds": 360,
      "available": true,
      "co2_grams": 2556,
      "co2_offset": true
    },
    {
      "category": "moto",
      "name": "Moto",
      "description": "Mais ágil",
      "price_cents": 860,
      "currency": "BRL",
      "eta_seconds": 180,
      "available": true,
      "co2_grams": 1136,
      "co2_offset": true
    },
    {
      "category": "eco",
      "name": "Eco",
      "description": "100% elétrico",
      "price_cents": 1360,
      "currency": "BRL",
      "eta_seconds": 300,
      "available": true,
      "co2_grams": 0,
      "co2_avoided_grams": 2130,
      "co2_offset": false
    }
  ]
}
```

| Campo | Tipo | Descrição |
| --- | --- | --- |
| `distance_m` | integer | Distância da rota, em metros. |
| `duration_s` | integer | Duração da viagem, em segundos. |
| `options[].category` | string | Ver tabela de categorias. |
| `options[].price_cents` | integer | Preço estimado, em centavos. |
| `options[].eta_seconds` | integer | Tempo até o motorista chegar. O app exibe “4 min”. |
| `options[].available` | boolean | `false` esmaece a opção no app. |
| `options[].co2_grams` | integer | Emissão estimada da viagem (ver Impacto ambiental). |
| `options[].co2_avoided_grams` | integer | Só em `eco`. |
| `options[].co2_offset` | boolean | Emissão compensada pela FastMob. |

### Erros

| Status | `error.code` | Quando ocorre |
| --- | --- | --- |
| `422` | `validation_failed` | Coordenadas ausentes ou fora do mapa. |
| `422` | `out_of_service_area` | Origem ou destino fora da área atendida. |

## Pedir corrida

| Item | Valor |
| --- | --- |
| Método | `POST` |
| Rota | `/rides` |
| Headers extras | `Idempotency-Key: <uuid>` (recomendado) |

### Request

```json
{
  "category": "fast",
  "origin": { "lat": -10.1844, "lng": -48.3336, "address": "Quadra 104 Sul" },
  "destination": { "lat": -10.2917, "lng": -48.3573, "address": "Aeroporto de Palmas" },
  "price_cents": 1240,
  "payment_method": "pix"
}
```

| Campo | Tipo | Obrigatório | Descrição |
| --- | --- | --- | --- |
| `category` | string | Sim | Categoria escolhida. |
| `origin` / `destination` | object | Sim | Como na estimativa. |
| `price_cents` | integer | Sim | Preço que o passageiro viu. Se mudou, a API responde `409 price_changed`. |
| `payment_method` | string | Sim | `pix`, `card` ou `cash`. |

### Response — `201 Created`

```json
{
  "id": "ride_8f3k2",
  "status": "searching",
  "category": "fast",
  "origin": { "lat": -10.1844, "lng": -48.3336, "address": "Quadra 104 Sul" },
  "destination": { "lat": -10.2917, "lng": -48.3573, "address": "Aeroporto de Palmas" },
  "price_cents": 1240,
  "currency": "BRL",
  "payment_method": "pix",
  "co2_grams": 2130,
  "co2_offset": true,
  "driver": null,
  "created_at": "2026-10-30T22:15:00Z"
}
```

### Erros

| Status | `error.code` | Quando ocorre |
| --- | --- | --- |
| `409` | `price_changed` | O preço mudou desde a estimativa; o app refaz a estimativa. |
| `409` | `ride_in_progress` | A pessoa já tem uma corrida ativa. |
| `422` | `validation_failed` | Campo ausente ou inválido. |

## Acompanhar corrida

| Item | Valor |
| --- | --- |
| Método | `GET` |
| Rota | `/rides/{id}` |

### Response — `200 OK`

Mesmo objeto do pedido, com `driver` e `eta_seconds` preenchidos a partir de
`driver_assigned`:

```json
{
  "id": "ride_8f3k2",
  "status": "driver_arriving",
  "category": "fast",
  "origin": { "lat": -10.1844, "lng": -48.3336, "address": "Quadra 104 Sul" },
  "destination": { "lat": -10.2917, "lng": -48.3573, "address": "Aeroporto de Palmas" },
  "price_cents": 1240,
  "currency": "BRL",
  "payment_method": "pix",
  "eta_seconds": 150,
  "driver": {
    "id": "drv_77c1",
    "name": "Carlos Souza",
    "rating": 4.9,
    "photo_url": "https://cdn.fastmob.dev/drivers/drv_77c1.jpg",
    "phone": "+5563988880000",
    "vehicle": {
      "model": "Onix",
      "color": "Prata",
      "plate": "QWE-1A23"
    },
    "location": { "lat": -10.1901, "lng": -48.3302, "heading": 212 }
  },
  "created_at": "2026-10-30T22:15:00Z"
}
```

| Campo | Tipo | Descrição |
| --- | --- | --- |
| `eta_seconds` | integer | Quanto falta para o motorista chegar (ou para o destino, se `in_progress`). |
| `driver.rating` | number | Nota de 0 a 5. Alimenta o `DriverCard`. |
| `driver.photo_url` | string \| null | Foto; sem ela o app mostra as iniciais. |
| `driver.vehicle.*` | object | Modelo, cor e placa. |
| `driver.location` | object | Posição atual e direção (`heading`, em graus). |

### Erros

| Status | `error.code` | Quando ocorre |
| --- | --- | --- |
| `404` | `ride_not_found` | A corrida não existe ou é de outra pessoa. |

## Cancelar corrida

| Item | Valor |
| --- | --- |
| Método | `POST` |
| Rota | `/rides/{id}/cancel` |

### Request

```json
{ "reason": "changed_mind" }
```

`reason` (opcional): `changed_mind`, `driver_too_far`, `wrong_address`, `other`.

### Response — `200 OK`

```json
{
  "id": "ride_8f3k2",
  "status": "cancelled",
  "cancellation_fee_cents": 0,
  "currency": "BRL"
}
```

### Erros

| Status | `error.code` | Quando ocorre |
| --- | --- | --- |
| `409` | `ride_not_cancellable` | A corrida já está em andamento ou concluída. |

## Histórico

| Item | Valor |
| --- | --- |
| Método | `GET` |
| Rota | `/rides?limit=20&cursor=<cursor>&status=completed` |

### Response — `200 OK`

```json
{
  "items": [
    {
      "id": "ride_8f3k2",
      "status": "completed",
      "category": "fast",
      "origin": { "address": "Quadra 104 Sul" },
      "destination": { "address": "Aeroporto de Palmas" },
      "price_cents": 1240,
      "currency": "BRL",
      "completed_at": "2026-10-30T22:41:00Z"
    }
  ],
  "next_cursor": null
}
```

## Avaliar motorista

| Item | Valor |
| --- | --- |
| Método | `POST` |
| Rota | `/rides/{id}/rating` |

```json
{ "stars": 5, "comment": "Direção tranquila." }
```

`stars` é obrigatório (1 a 5); `comment` é opcional. Resposta `204 No Content`.
Só vale para corridas `completed` (senão `409 ride_not_completed`).
