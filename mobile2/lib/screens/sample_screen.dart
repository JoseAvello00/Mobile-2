import 'package:flutter/material.dart';
import '../common/app_colors.dart';
import '../common/app_spacing.dart';
import '../common/app_text_styles.dart';
import '../components/action_button/action_button_factory.dart';
import 'sample_action_button_screen.dart';
import 'sample_tab_bar_screen.dart';

/// SCREENS > SampleScreen
///
/// Tela inicial de navegação: só lista links para as demais telas de
/// exemplo. Sem lógica de negócio.
class SampleScreen extends StatelessWidget {
  const SampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Design System - Demo')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            Text('Componentes disponíveis', style: AppTextStyles.heading),
            const SizedBox(height: AppSpacing.lg),
            ActionButtonFactory.primary(
              label: 'Ver Action Button',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SampleActionButtonScreen(),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            ActionButtonFactory.secondary(
              label: 'Ver Tab Bar',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SampleTabBarScreen(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
