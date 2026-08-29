import 'package:flutter/material.dart';
import '../common/app_colors.dart';
import '../common/app_spacing.dart';
import '../common/app_text_styles.dart';
import '../components/tab_bar/tab_bar_factory.dart';

/// SCREENS > SampleTabBarScreen
///
/// Tela de exemplo que só existe para demonstrar o componente TabBar
/// (View + ViewModel + Factory) funcionando e trocando de aba.
class SampleTabBarScreen extends StatefulWidget {
  const SampleTabBarScreen({super.key});

  @override
  State<SampleTabBarScreen> createState() => _SampleTabBarScreenState();
}

class _SampleTabBarScreenState extends State<SampleTabBarScreen> {
  int _selectedIndex = 0;

  static const _labels = ['Início', 'Buscar', 'Favoritos', 'Perfil'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Sample: Tab Bar')),
      body: Center(
        child: Text(
          'Aba selecionada: ${_labels[_selectedIndex]}',
          style: AppTextStyles.body,
        ),
      ),
      bottomNavigationBar: TabBarFactory.standard(
        selectedIndex: _selectedIndex,
        onTabSelected: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}
