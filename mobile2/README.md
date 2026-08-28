# Mobile 2 — Design System Local

Design System local para o app, com componentes isolados da lógica das
telas, seguindo o padrão **ViewModel → Component → Factory**.

## 🔗 Figma Referencial
> ⚠️ Substitua pelo link público do seu protótipo antes de entregar:
`https://www.figma.com/file/SEU-LINK-AQUI`

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
