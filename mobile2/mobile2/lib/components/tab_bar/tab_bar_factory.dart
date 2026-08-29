import 'package:flutter/material.dart';
import 'tab_bar_component.dart';
import 'tab_bar_view_model.dart';

/// COMPONENTS > TabBar > Factory
///
/// Centraliza a criação de configurações comuns de Tab Bar,
/// para as telas não precisarem repetir a lista de itens toda vez.
class TabBarFactory {
  TabBarFactory._();

  /// Tab Bar padrão do app: Início, Buscar, Favoritos, Perfil.
  static Widget standard({
    required int selectedIndex,
    required ValueChanged<int> onTabSelected,
  }) {
    return TabBarComponent(
      viewModel: TabBarViewModel(
        selectedIndex: selectedIndex,
        onTabSelected: onTabSelected,
        items: const [
          TabItemViewModel(label: 'Início', icon: Icons.home_outlined),
          TabItemViewModel(label: 'Buscar', icon: Icons.search),
          TabItemViewModel(label: 'Favoritos', icon: Icons.favorite_border),
          TabItemViewModel(label: 'Perfil', icon: Icons.person_outline),
        ],
      ),
    );
  }

  /// Versão customizada, para telas que precisam de outras abas.
  static Widget custom({
    required List<TabItemViewModel> items,
    required int selectedIndex,
    required ValueChanged<int> onTabSelected,
  }) {
    return TabBarComponent(
      viewModel: TabBarViewModel(
        items: items,
        selectedIndex: selectedIndex,
        onTabSelected: onTabSelected,
      ),
    );
  }
}
