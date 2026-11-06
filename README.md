# FastMob

Aplicativo Flutter de mobilidade urbana (peça uma corrida, acompanhe o
motorista), organizado por cenas e com um design system próprio na identidade
laranja da marca.

## Estrutura

```text
lib/
  main.dart                 # FastMobApp: tema claro/escuro e cena inicial
  scenes/
    login/                  # LoginScene          (MVVM + Factory + Coordinator)
    home/                   # HomeScene           (mapa, destino, categoria)
    confirm_ride/           # ConfirmRideScene    (resumo, impacto, pagamento)
    searching_driver/       # SearchingDriverScene (polling até ter motorista)
  shared/
    map/                    # CityMap: OpenStreetMap via flutter_map
    places/                 # Place, lugares de Palmas, PlaceSearch
    rides/                  # categorias, estimativa, RideService (mock)
packages/design_system/     # tokens, tema, componentes e galeria (example/)
docs/
  api/                      # contrato da API: requests e responses
  design/                   # tema do app, protótipo das telas
test/                       # testes das cenas
```

## Padrões de projeto aplicados

| Padrão | Onde |
| --- | --- |
| MVVM | `LoginView` observa `LoginViewModel` (`ChangeNotifier`) |
| Factory | `LoginFactory.make()` monta a cena e injeta as dependências |
| Injeção de dependências | `LoginViewModel` recebe `ServerLogin` e `LoginCoordinator` |
| Coordinator | `LoginCoordinator` decide para onde ir; a View não conhece a Home |
| Strategy | `ServerLogin` (mock e HTTP), `PlaceSearch`, `RideEstimator`, `RideService`: interfaces com implementação `Default*` trocável |
| Result (sealed class) | `LoginResult` e `RideResult` (`RideSuccess` / `RideFailure`) |
| Observer | `ListenableBuilder` na View escuta a ViewModel |
| Theme Extension | `AppSemanticColors` (`context.semanticColors`) |

## Fluxo da corrida

```text
Login → Home (destino em Palmas + categoria) → Confirmar corrida → Procurando motorista
                                                                   └─ Cancelar → Home
```

Uma única instância de `RideService` passa de factory em factory
(`HomeFactory` → `ConfirmRideFactory` → `SearchingDriverFactory`). No mock, um
motorista aceita depois de 3 consultas (cerca de 6 s).

O mapa usa tiles do OpenStreetMap: precisa de internet e, no Android, da
permissão `INTERNET` em `android/app/src/main/AndroidManifest.xml`.

## Executar

```sh
flutter pub get
flutter test
flutter run
cd packages/design_system/example && flutter run   # galeria de componentes
```

Por padrão o app usa um servidor simulado, então roda sem backend.
Credenciais de demonstração: `ana@fastmob.dev` / `123456`.

Para trocar para a API real, injete `ServerLoginReal()` em `LoginFactory`.
O contrato está em [docs/api](docs/api/README.md).

## Documentação

- [API: requests e responses](docs/api/README.md)
- [Tema do app e protótipo das telas](docs/design/tema.md)
