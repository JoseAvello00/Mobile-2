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
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: List.generate(viewModel.items.length, (index) {
          final item = viewModel.items[index];
          final bool selected = index == viewModel.selectedIndex;
          final Color color =
              selected ? AppColors.primary : AppColors.textSecondary;

          return Expanded(
            child: InkWell(
              onTap: () => viewModel.onTabSelected(index),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item.icon, color: color, size: 22),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    item.label,
                    style: AppTextStyles.caption.copyWith(color: color),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
