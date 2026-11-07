# Tema do app FastMob

## Conceito

FastMob é um app de mobilidade urbana (passageiro) com identidade **laranja**:
energia, velocidade e calor. O raio (⚡) é o símbolo; o nome combina “Fast” (em
itálico pesado, a pressa) com “Mob” (peso normal, a calma de quem chega).

> **Diferencial inovador: mobilidade sustentável.** A FastMob oferece a
> categoria **Eco** (carros 100% elétricos) e compensa o carbono das demais
> categorias. Toda corrida mostra o impacto na tela de confirmação
> (`ImpactCard`): na Eco, o CO₂ evitado; nas outras, o CO₂ compensado.

### Mapa

Mapa gratuito do **OpenStreetMap** (pacote `flutter_map`, sem chave de API),
centrado em **Palmas, Tocantins**. A atribuição “© OpenStreetMap” fica no topo,
porque o painel inferior cobriria o canto de baixo. Os tiles públicos do OSM
servem para uso leve, como este projeto; em produção, a política de uso pede um
servidor de tiles próprio ou um provedor.

### Cálculos da estimativa (mock `DefaultRideEstimator`)

| Item | Fórmula |
| --- | --- |
| Distância | linha reta (Haversine) × 1,3 (fator de ruas) |
| Duração | distância ÷ 9 m/s (≈ 32 km/h) |
| Preço | máx(mínimo, base + km × por km + min × por minuto), arredondado a 10 centavos |
| CO₂ da viagem | g/km da categoria × km |
| CO₂ evitado (Eco) | g/km do Fast × km |

| Categoria | Base | Por km | Por min | Mínimo | CO₂ (g/km) | Espera |
| --- | --- | --- | --- | --- | --- | --- |
| Fast | R$ 4,00 | R$ 1,60 | R$ 0,20 | R$ 8,00 | 150 | 4 min |
| Conforto | R$ 5,40 | R$ 2,16 | R$ 0,27 | R$ 10,80 | 180 | 6 min |
| Moto | R$ 2,80 | R$ 1,12 | R$ 0,14 | R$ 5,60 | 80 | 3 min |
| Eco | R$ 4,40 | R$ 1,76 | R$ 0,22 | R$ 8,80 | 0 | 5 min |

**Premissas.** Os valores de g/km são estimativas ilustrativas para o projeto,
não medições. “Zero emissão” se refere ao escapamento (emissão local); a
geração da energia não entra na conta. A “compensação de 100%” é um conceito do
projeto: o parceiro de compensação ainda não foi definido.

## Cores

| Token | Claro | Escuro | Uso |
| --- | --- | --- | --- |
| `primary` | `#E85D04` | `#FF8A3D` | Botões, seleção, ações |
| `onPrimary` | `#FFFFFF` | `#2B1000` | Texto sobre `primary` |
| `primaryContainer` | `#FFE8D6` | `#5A2A0A` | Fundo de item selecionado |
| `brandStart` → `brandEnd` | `#FF7F1F` → `#D94F00` | `#B84300` → `#7A2A00` | Gradiente do hero |
| `background` | `#FFF8F3` | `#15110E` | Fundo das telas |
| `surface` | `#FFFFFF` | `#1E1915` | Cartões e painéis |
| `onSurface` | `#1F1A17` | `#F3ECE7` | Texto principal |
| `onSurfaceMuted` | `#6F625A` | `#A89A90` | Texto secundário |
| `outline` | `#E6DAD1` | `#3A312B` | Bordas |
| `success` | `#1E8E5A` | `#4FC38A` | Corrida confirmada/concluída |
| `info` | `#2F6FDE` | `#7AA7FF` | Motorista a caminho |
| `warning` | `#9A5B00` | `#E8B04A` | Atenção |
| `error` | `#C93B2B` | `#F28B7D` | Erros e cancelamento |
| `star` | `#F5A524` | `#F5B94A` | Estrela de avaliação |

**Contraste.** Texto principal e secundário passam de 5,5:1 no claro. O texto
branco sobre o laranja do botão tem cerca de 3,5:1: aceitável para rótulos
grandes e em negrito (16 sp, peso 700), mas não para texto corrido. Por isso o
laranja é usado em **preenchimentos e ícones**, nunca como cor de parágrafo.

## Tipografia

Fonte da plataforma (sem dependência externa). Escala em
`AppTypography`: `displayLarge` 40 · `headlineMedium` 28 · `titleLarge` 22 ·
`titleMedium` 17 · `titleSmall` 14 · `bodyLarge` 17 · `bodyMedium` 15 ·
`bodySmall` 13 · `labelLarge` 15 · `labelSmall` 11. Preços usam algarismos
tabulares para alinhar colunas.

## Espaçamento e raios

Grade de 4 pt: `xxs` 2 · `xs` 4 · `sm` 8 · `md` 12 · `lg` 16 · `xl` 24 ·
`xxl` 32 · `xxxl` 48. Raios: `sm` 8 · `md` 12 · `lg` 16 · `xl` 28 · `pill`.

## Componentes

| Grupo | Componentes |
| --- | --- |
| Marca | `FastMobLogo`, `BrandHeader` |
| Ações e campos | `AppButton` (primary/secondary/text), `AppTextField`, `PasswordField` |
| Corrida | `RideOptionCard` (com selo `eco`), `LocationTile`, `DriverCard`, `StatusChip`, `PriceText`, `BottomPanel`, `ImpactCard` |
| Estrutura | `AppScaffold`, `AppAvatar`, `SectionHeader`, `Gap`, `StateView` |

Todos aparecem na galeria: `packages/design_system/example`. O tema também
estiliza o `SegmentedButton` (forma de pagamento): o segmento selecionado usa
`primaryContainer`, e não o azul de `secondary` que o Material usaria.

## Protótipo das telas

| # | Tela | Estado | Componentes principais |
| --- | --- | --- | --- |
| 1 | Login | **Implementada** | `BrandHeader`, `AppTextField`, `PasswordField`, `AppButton` |
| 2 | Home (destino + categorias) | **Implementada** (mapa OSM de Palmas) | `BottomPanel`, `RideOptionCard`, `AppTextField`, `LocationTile` |
| 3 | Cadastro | Prototipar | `AppTextField`, `PasswordField` com força |
| 4 | Buscar endereço | **Implementada** dentro da Home (catálogo local) | `LocationTile`, `AppTextField` |
| 5 | Confirmar corrida | **Implementada** | `LocationTile` ×2, `PriceText`, `ImpactCard`, `SegmentedButton`, `AppButton` |
| 6 | Procurando motorista | **Implementada** | `StatusChip`, barra de progresso, `DriverCard` |
| 7 | Motorista a caminho | Prototipar | `DriverCard`, `StatusChip`, `BottomPanel` |
| 8 | Em viagem | Prototipar | `StatusChip`, `LocationTile`, `BottomPanel` |
| 9 | Avaliação | Prototipar | `AppAvatar`, `AppButton` |
| 10 | Histórico | Prototipar | `LocationTile`, `PriceText`, `StatusChip` |
| 11 | Perfil | Prototipar | `AppAvatar`, `SectionHeader` |

Cada tela nova segue o mesmo molde da LoginScene:
`<scene>_view.dart`, `<scene>_view_model.dart`, `<scene>_factory.dart`,
`<scene>_coordinator.dart` e um serviço injetado (como `ServerLogin`).
