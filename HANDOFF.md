# FastMob: documento de passagem de contexto

Leia este arquivo primeiro. Ele resume o pedido, as decisões já tomadas, o que
está pronto e o que falta, para outra conversa continuar o trabalho sem perder
nada. Idioma da conversa com o usuário: **português (pt-BR)**.

## 1. Pedido original (trabalho de faculdade, Mobile II)

Transformar um app Flutter simples (gerado no Codex, "terrivelmente feio") em um
app estilo **99/Uber**, chamado **FastMob**, com tela inicial em **tom de
laranja**. Requisitos da disciplina:

1. Remover a cena padrão e criar a **LoginScene** na pasta `Scenes`.
2. LoginScene em **MVVM**, com injeção de dependências `ServerLogin` e
   `Coordinator` a partir de uma **`LoginFactory`**.
3. View com `AppTextField` (e-mail), `PasswordField` (senha) e botão de ação
   estilo **primary**.
4. Definir o tema do app (o "tema" precisa ser **inovador**) e **prototipar as telas**.
5. Desenvolver o **conjunto de componentes e o sample app (galeria) do design system**.
6. Documentar **requests e responses da API**.
7. Implementação do app e do design system deve seguir os **padrões de projeto
   estudados no semestre**. Referência do professor:
   `https://github.com/malfattito/mobileii/tree/Versao_2`
   (**não foi possível abrir**: o GitHub bloqueia acesso automatizado. Se o
   usuário enviar o ZIP dessa branch, comparar a estrutura).

O usuário quer **montar o projeto junto**, com perguntas sobre preferências.

## 2. Decisões já tomadas pelo usuário

| Pergunta | Resposta |
| --- | --- |
| Diferencial inovador | **Sustentável** (carros elétricos, carbono compensado) |
| Mapa da Home | **App de mapa gratuito focado em Palmas, Tocantins** (plano: OpenStreetMap via `flutter_map`, sem chave de API) |
| Próxima tela | **Confirmar corrida e procurando motorista** |

## 3. Ambiente e limitações

- Projeto **Flutter** (Dart SDK `^3.13.1`), Windows. Usa parâmetros nomeados
  privados (`required this._serverLogin`), sintaxe recente do Dart.
- **Nunca foi compilado nem testado** (Sprints 1 e 2): não havia Flutter no
  ambiente do assistente. Primeiro passo do usuário:
  `flutter pub get && flutter test`. Pedir a saída de erros e corrigir.
- O zip original do usuário trazia caminhos com barra invertida (feito no
  Windows). Os arquivos `android/`, `ios/` etc. dele **não** estão neste pacote.
- Código-fonte do usuário usa CRLF; o pacote usa LF.

## 4. O que está pronto (Sprint 1) e está neste pacote

- Renomeado: app `fastmob`, pacote `fastmob_design_system`
  (pasta `packages/design_system`).
- **Tema laranja** claro/escuro: primary `#E85D04`, gradiente de marca
  `#FF7F1F → #D94F00`, fundo `#FFF8F3`. Tokens em
  `packages/design_system/lib/src/tokens/`; `AppSemanticColors` (ThemeExtension:
  success, info, warning, danger, star, muted, brandGradient).
- **Componentes do DS**: `AppButton`, `AppTextField`, `PasswordField`,
  `AppScaffold` (novo `safeAreaTop`), `AppAvatar`, `SectionHeader`, `Gap`,
  `StateView`, e novos: `FastMobLogo`, `BrandHeader`, `RideOptionCard`,
  `LocationTile`, `DriverCard`, `StatusChip`, `PriceText` (centavos → `R$ 12,40`),
  `BottomPanel`. Removidos os componentes de carteira (saldo/transação).
- **Galeria** (`packages/design_system/example`): páginas Tokens, Marca, Botões,
  Campos, Corrida, Estados.
- **LoginScene** (`lib/scenes/login/`): MVVM + `LoginFactory` + `LoginCoordinator`
  + `ServerLogin` (Strategy: `DefaultServerLogin` mock, `ServerLoginReal` HTTP) +
  `LoginResult` sealed. Login de teste: `ana@fastmob.dev` / `123456`.
- **HomeScene**: reescrita na Sprint 2 (ver seção 5).
- **Docs**: `docs/api/{README,auth,rides}.md` (convenções, erros, login,
  cadastro, perfil, estimativa, pedido, acompanhamento, cancelamento, histórico,
  avaliação) e `docs/design/tema.md` (cores, tipografia, componentes, lista de
  11 telas). `README.md` com tabela de padrões de projeto.
- **Testes** de widget para DS, tema, login e home.

## 5. Sprint 2: **implementada** (ainda não compilada)

O plano original da Sprint 2 foi seguido. O que existe agora:

- `pubspec.yaml`: `flutter_map: ^8.0.0`, `latlong2: ^0.9.1`.
- `lib/shared/map/city_map.dart`: `CityMap` (tiles OSM, linha reta
  origem→destino, pino no destino, pulso na origem, atribuição no topo,
  `CityMap.debugDisableTiles` para testes).
- `lib/shared/places/`: `Place`, `PalmasPlaces` (coordenadas **aproximadas**),
  `PlaceSearch` + `DefaultPlaceSearch` (sem acento).
- `lib/shared/rides/`: `RideCategory` (fast, comfort, moto, **eco**) com tarifa e
  CO₂; `RideQuote`, `RideEstimate`, `RideDraft` (`co2AvoidedGrams`);
  `RideEstimator` + `DefaultRideEstimator` (Haversine próprio × 1,3; 9 m/s);
  `Ride`, `Driver`, `RideStatus`, `PaymentMethod`, `RideResult` sealed;
  `RideService` + `DefaultRideService` (mock, motorista após 3 consultas).
- `lib/shared/format.dart` (`formatEta`, `formatCo2`, `formatDistance`) e
  `lib/shared/safe_notifier.dart`.
- Cenas: `home/` reescrita (+ `home_coordinator.dart`), `confirm_ride/` e
  `searching_driver/`, todas com View, ViewModel, Factory, Coordinator.
- DS: `ImpactCard` (novo), `RideOptionCard(eco:)`, `segmentedButtonTheme`;
  galeria e testes atualizados.
- Docs: `rides.md` (eco, `co2_grams`, `co2_avoided_grams`, `co2_offset`),
  `tema.md` (diferencial, mapa, fórmulas e premissas), `README.md` (fluxo).
- Testes: `test/shared/*`, VMs e Views de Home, Confirm e Searching
  (`test/fakes.dart` tem os serviços falsos).

### Pendências conhecidas
- **Nada foi compilado**: rodar `flutter pub get && flutter test` e corrigir.
  Pontos de maior risco: API do `flutter_map` 8 (`MapOptions`, `CameraFit`,
  `Marker.alignment`), `ButtonStyle.iconColor`, parâmetros nomeados privados.
- Conferir `<uses-permission android:name="android.permission.INTERNET"/>` no
  `AndroidManifest.xml` do usuário.
- Conferir as coordenadas de `PalmasPlaces` no openstreetmap.org.
- Referência do professor (`Versao_2`) ainda não comparada.

## 6. Sprints seguintes (ainda a combinar com o usuário)

Próxima sugerida: tela dedicada **Motorista a caminho / Em viagem** (Sprint 3).
Depois: Cadastro · Avaliação · Histórico e Perfil ·
rota real e geolocalização · servidor simples para a API (opcional) ·
arquivo OpenAPI (opcional).

## 7. Convenções do projeto

- Português nas strings de UI e na documentação; código e comentários em inglês.
- Widgets do app nunca leem `AppColors` direto: usam `Theme.of(context)` ou
  `context.semanticColors`.
- Componentes do DS são "burros" (dados + callbacks). Dinheiro = `int` em centavos.
- Cada cena: `<scene>_view.dart`, `_view_model.dart`, `_factory.dart`,
  `_coordinator.dart` + serviço injetado por interface (Strategy). Resultado de
  operações com `sealed class`.
- Respostas ao usuário no app móvel do Claude: curtas, direto ao ponto; fazer no
  máximo 1 a 3 perguntas de preferência por vez.
- Ao entregar: avisar que o código não foi compilado; listar ressalvas.

## 8. Como usar este pacote

Descompactar, rodar `flutter pub get` e `flutter test`. Para integrar a um
projeto existente: apagar `lib/`, `test/`, `docs/` e
`packages/design_system/{lib,test,example/lib}` do projeto antigo e copiar estes
por cima (pastas `android/`, `ios/` etc. do projeto antigo permanecem).
Galeria: `cd packages/design_system/example && flutter run`.
