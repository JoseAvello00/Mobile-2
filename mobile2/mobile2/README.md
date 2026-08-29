# Mobile 2 — Design System Local

Design System local para o app, com componentes isolados da lógica das
telas, seguindo o padrão **ViewModel → Component → Factory**.

## 🔗 Figma Referencial
https://www.figma.com/design/5jz2ZvSK8jzxzxfpKmHoEE/Food-Delivery-App--Community-

Paleta e formas do Design System foram extraídas visualmente deste arquivo
(botão "ADD TO CART", chips e seletor de quantidade da tela de detalhes do
produto). Como o arquivo do Figma é um kit de preview com telas "achatadas"
(imagens, não camadas editáveis), os valores exatos (hex, radius, spacing)
foram calibrados a partir do screenshot — ajuste `app_colors.dart` se tiver
acesso às variáveis reais do arquivo original.

## 📱 Como abrir no Android Studio

1. Abra o Android Studio → **Open** → selecione a pasta `mobile2/` (a raiz,
   onde está o `pubspec.yaml`).
2. Instale os plugins **Flutter** e **Dart** se ainda não tiver (Settings →
   Plugins).
3. O Android Studio vai pedir o caminho do Flutter SDK na primeira vez —
   aponte para onde você instalou o Flutter na sua máquina.
4. Rode `flutter pub get` (o próprio Android Studio oferece o botão, ou via
   terminal).
5. Selecione um emulador/dispositivo Android e clique em **Run**.

> A pasta `android/` já vem pronta (Gradle, Manifest, ícone). Só falta o
> `local.properties` apontar pro Flutter SDK da sua máquina — o Android
> Studio faz isso sozinho ao abrir o projeto.

## 📁 Estrutura de pastas

```
lib/
├── main/
│   └── main.dart                 # ponto de entrada do app
├── common/                       # recursos em comum (cores, fontes, espaçamentos)
│   ├── app_colors.dart
│   ├── app_text_styles.dart
│   └── app_spacing.dart
├── components/                   # componentes isolados e reutilizáveis
│   ├── action_button/
│   │   ├── action_button_view_model.dart
│   │   ├── action_button_component.dart
│   │   └── action_button_factory.dart
│   ├── tab_bar/
│   │   ├── tab_bar_view_model.dart
│   │   ├── tab_bar_component.dart
│   │   └── tab_bar_factory.dart
│   └── list_items/                # ponto de extensão (3º componente futuro)
└── screens/                      # telas de exemplo, sem lógica de negócio
    ├── sample_action_button_screen.dart
    ├── sample_tab_bar_screen.dart
    └── sample_screen.dart
```

## 🧩 Os 2 componentes exigidos

| Componente | ViewModel | Component (View) | Factory |
|---|---|---|---|
| **Action Button** | `ActionButtonViewModel` guarda label, estilo (primário/secundário/destrutivo), estado (habilitado/carregando) e o callback | `ActionButtonComponent` só desenha o botão de acordo com a ViewModel | `ActionButtonFactory.primary/.secondary/.destructive(...)` monta a ViewModel + Component prontos para uso |
| **Tab Bar** | `TabBarViewModel` guarda a lista de abas, o índice selecionado e o callback de troca | `TabBarComponent` só desenha a barra e delega o toque | `TabBarFactory.standard(...)` monta a Tab Bar padrão do app (Início/Buscar/Favoritos/Perfil) |

## ▶️ Como rodar

```bash
flutter pub get
flutter run -t lib/main/main.dart
```

## 📱 Telas de exemplo (prints aqui)

Adicione aqui os prints das telas rodando:

- `SampleScreen` — menu de navegação entre os componentes
- `SampleActionButtonScreen` — todos os estados do Action Button
- `SampleTabBarScreen` — Tab Bar funcionando e trocando de aba

## 🏗️ Arquitetura

- **ViewModel**: guarda dados/estado do componente, sem nenhuma lógica de UI.
- **Component**: widget "burro" — só renderiza o que a ViewModel manda.
- **Factory**: método de criação (*Factory Method*) que monta ViewModel +
  Component prontos, para as telas não precisarem montar tudo na mão.

As telas (`screens/`) não têm lógica de negócio: existem apenas para provar
que os componentes funcionam isoladamente.
