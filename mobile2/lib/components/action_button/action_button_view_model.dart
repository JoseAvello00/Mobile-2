import 'package:flutter/widgets.dart';

/// Estilos visuais suportados pelo Action Button.
enum ActionButtonStyle { primary, secondary, destructive }

/// COMPONENTS > ActionButton > ViewModel
///
/// Guarda todo o ESTADO e DADOS necessários para o componente se desenhar.
/// O componente (View) nunca decide nada sozinho: ele apenas lê esta classe.
class ActionButtonViewModel {
  final String label;
  final ActionButtonStyle style;
  final bool isEnabled;
  final bool isLoading;
  final IconData? icon;
  final VoidCallback onPressed;

  const ActionButtonViewModel({
    required this.label,
    required this.onPressed,
    this.style = ActionButtonStyle.primary,
    this.isEnabled = true,
    this.isLoading = false,
    this.icon,
  });

  /// Facilita criar variações sem reescrever tudo (ex: versão "loading").
  ActionButtonViewModel copyWith({
    String? label,
    ActionButtonStyle? style,
    bool? isEnabled,
    bool? isLoading,
    IconData? icon,
    VoidCallback? onPressed,
  }) {
    return ActionButtonViewModel(
      label: label ?? this.label,
      style: style ?? this.style,
      isEnabled: isEnabled ?? this.isEnabled,
      isLoading: isLoading ?? this.isLoading,
      icon: icon ?? this.icon,
      onPressed: onPressed ?? this.onPressed,
    );
  }
}
