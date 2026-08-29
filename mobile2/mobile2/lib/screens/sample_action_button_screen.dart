import 'package:flutter/material.dart';
import '../common/app_colors.dart';
import '../common/app_spacing.dart';
import '../common/app_text_styles.dart';
import '../components/action_button/action_button_factory.dart';

/// SCREENS > SampleActionButtonScreen
///
/// Tela de exemplo SEM lógica de negócio: existe só para provar,
/// visualmente, que o componente ActionButton (View + ViewModel + Factory)
/// funciona em todos os seus estados.
class SampleActionButtonScreen extends StatefulWidget {
  const SampleActionButtonScreen({super.key});

  @override
  State<SampleActionButtonScreen> createState() =>
      _SampleActionButtonScreenState();
}

class _SampleActionButtonScreenState extends State<SampleActionButtonScreen> {
  bool _isLoading = false;

  void _simulateLoading() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Sample: Action Button')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text('Estilos', style: AppTextStyles.heading),
          const SizedBox(height: AppSpacing.md),
          ActionButtonFactory.primary(label: 'Primário', onPressed: () {}),
          const SizedBox(height: AppSpacing.sm),
          ActionButtonFactory.secondary(
              label: 'Secundário', onPressed: () {}),
          const SizedBox(height: AppSpacing.sm),
          ActionButtonFactory.destructive(
              label: 'Destrutivo', onPressed: () {}),
          const SizedBox(height: AppSpacing.lg),
          Text('Estados', style: AppTextStyles.heading),
          const SizedBox(height: AppSpacing.md),
          ActionButtonFactory.primary(
            label: 'Desabilitado',
            onPressed: () {},
            isEnabled: false,
          ),
          const SizedBox(height: AppSpacing.sm),
          ActionButtonFactory.primary(
            label: _isLoading ? 'Carregando...' : 'Simular carregamento',
            onPressed: _simulateLoading,
            isLoading: _isLoading,
          ),
          const SizedBox(height: AppSpacing.sm),
          ActionButtonFactory.primary(
            label: 'Com ícone',
            icon: Icons.check_circle_outline,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
