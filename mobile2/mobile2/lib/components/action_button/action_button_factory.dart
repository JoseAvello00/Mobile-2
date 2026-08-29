import 'package:flutter/widgets.dart';
import 'action_button_component.dart';
import 'action_button_view_model.dart';

/// COMPONENTS > ActionButton > Factory
///
/// Padrão Factory Method: centraliza a CRIAÇÃO do componente,
/// para quem consome não precisar montar a ViewModel manualmente
/// toda vez. Isso separa "como construir" de "onde usar".
class ActionButtonFactory {
  ActionButtonFactory._();

  static Widget primary({
    required String label,
    required VoidCallback onPressed,
    bool isEnabled = true,
    bool isLoading = false,
    IconData? icon,
  }) {
    return ActionButtonComponent(
      viewModel: ActionButtonViewModel(
        label: label,
        onPressed: onPressed,
        style: ActionButtonStyle.primary,
        isEnabled: isEnabled,
        isLoading: isLoading,
        icon: icon,
      ),
    );
  }

  /// Atalho específico pro caso de uso do Figma: botão "ADD TO CART".
  static Widget addToCart({
    required VoidCallback onPressed,
    bool isEnabled = true,
    bool isLoading = false,
  }) {
    return primary(
      label: 'Add to Cart',
      onPressed: onPressed,
      isEnabled: isEnabled,
      isLoading: isLoading,
    );
  }

  static Widget secondary({
    required String label,
    required VoidCallback onPressed,
    bool isEnabled = true,
  }) {
    return ActionButtonComponent(
      viewModel: ActionButtonViewModel(
        label: label,
        onPressed: onPressed,
        style: ActionButtonStyle.secondary,
        isEnabled: isEnabled,
      ),
    );
  }

  static Widget destructive({
    required String label,
    required VoidCallback onPressed,
    bool isEnabled = true,
  }) {
    return ActionButtonComponent(
      viewModel: ActionButtonViewModel(
        label: label,
        onPressed: onPressed,
        style: ActionButtonStyle.destructive,
        isEnabled: isEnabled,
      ),
    );
  }
}
