import 'package:flutter/widgets.dart';

/// Representa um único item/aba dentro da Tab Bar.
class TabItemViewModel {
  final String label;
  final IconData icon;

  const TabItemViewModel({required this.label, required this.icon});
}

/// COMPONENTS > TabBar > ViewModel
///
/// Guarda a lista de abas, qual está selecionada e o callback de troca.
class TabBarViewModel {
  final List<TabItemViewModel> items;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const TabBarViewModel({
    required this.items,
    required this.onTabSelected,
    this.selectedIndex = 0,
  });

  TabBarViewModel copyWith({
    List<TabItemViewModel>? items,
    int? selectedIndex,
    ValueChanged<int>? onTabSelected,
  }) {
    return TabBarViewModel(
      items: items ?? this.items,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      onTabSelected: onTabSelected ?? this.onTabSelected,
    );
  }
}
