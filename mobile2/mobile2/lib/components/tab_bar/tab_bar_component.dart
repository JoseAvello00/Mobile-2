import 'package:flutter/material.dart';
import '../../common/app_colors.dart';
import '../../common/app_spacing.dart';
import '../../common/app_text_styles.dart';
import 'tab_bar_view_model.dart';

/// COMPONENTS > TabBar > Component (View)
///
/// Widget "burro": renderiza a lista de abas e delega o toque
/// para o callback definido na ViewModel.
class TabBarComponent extends StatelessWidget {
  final TabBarViewModel viewModel;

  const TabBarComponent({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    // Barra flutuante e arredondada, com o item ativo destacado em laranja
    // (mesmo estilo dos chips/pills usados no restante do app do Figma).
    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        0,
        AppSpacing.md,
        AppSpacing.md,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: List.generate(viewModel.items.length, (index) {
          final item = viewModel.items[index];
          final bool selected = index == viewModel.selectedIndex;

          return Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
              onTap: () => viewModel.onTabSelected(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.sm,
                  horizontal: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item.icon,
                      color: selected
                          ? AppColors.textOnPrimary
                          : AppColors.textSecondary,
                      size: 22,
                    ),
                    if (selected) ...[
                      const SizedBox(height: AppSpacing.xs / 2),
                      Text(
                        item.label,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textOnPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
