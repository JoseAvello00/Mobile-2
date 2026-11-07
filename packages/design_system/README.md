# FastMob Design System

Tokens, tema e componentes do app FastMob (mobilidade urbana, identidade
laranja). Pacote Flutter local, consumido pelo app via `path`.

```text
lib/src/
  tokens/       cores, espaçamento, raios, tipografia, durações
  theme/        AppTheme.light()/dark() + AppSemanticColors (ThemeExtension)
  components/   AppButton, AppTextField, PasswordField, FastMobLogo,
                BrandHeader, RideOptionCard, LocationTile, DriverCard,
                StatusChip, PriceText, BottomPanel, StateView, ...
example/        galeria (sample app) com uma página por grupo de componentes
test/           testes de widget dos componentes e do tema
```

## Regras

- Widgets do app nunca leem `AppColors` direto: usam `Theme.of(context)` ou
  `context.semanticColors`.
- Componentes são "burros": recebem dados e callbacks, sem regra de negócio.
- Dinheiro é sempre `int` em centavos (`PriceText`).

## Galeria

```sh
cd example
flutter run
```

Os componentes aparecem em claro, escuro e automático (botão no canto superior
direito).
