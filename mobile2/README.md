# Mobile 2 — Design System Local
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

