import 'package:flutter/material.dart';
import '../../common/app_colors.dart';
import '../../common/app_spacing.dart';
import '../../common/app_text_styles.dart';
import 'action_button_view_model.dart';

/// COMPONENTS > ActionButton > Component (View)
///
/// Widget "burro": só desenha o que a ViewModel manda.
/// Não contém regra de negócio nenhuma.
class ActionButtonComponent extends StatelessWidget {
  final ActionButtonViewModel viewModel;

  const ActionButtonComponent({super.key, required this.viewModel});

  // Estilo "pill" laranja igual ao botão "ADD TO CART" do Figma.
  Color get _backgroundColor {
    if (!viewModel.isEnabled) return AppColors.disabled;
    switch (viewModel.style) {
      case ActionButtonStyle.primary:
        return AppColors.primary;
      case ActionButtonStyle.secondary:
        return AppColors.secondary; // pílula escura, como o seletor de quantidade
      case ActionButtonStyle.destructive:
        return AppColors.error;
    }
  }

  Color get _labelColor {
    if (!viewModel.isEnabled) return AppColors.textSecondary;
    return AppColors.textOnPrimary;
  }

  @override
  Widget build(BuildContext context) {
    final bool tappable = viewModel.isEnabled && !viewModel.isLoading;

    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: tappable ? viewModel.onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _backgroundColor,
          disabledBackgroundColor: AppColors.disabled,
          elevation: 0,
          shadowColor: AppColors.primary.withValues(alpha: 0.35),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        ),
        child: viewModel.isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: _labelColor,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (viewModel.icon != null) ...[
                    Icon(viewModel.icon, size: 18, color: _labelColor),
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  Text(
                    viewModel.label.toUpperCase(),
                    style: AppTextStyles.buttonLabel.copyWith(
                      color: _labelColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
