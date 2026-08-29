import 'package:flutter/material.dart';
import '../common/app_colors.dart';
import '../screens/sample_screen.dart';

/// MAIN
/// Ponto de entrada do aplicativo. Não contém lógica de UI nem de
/// componentes — apenas inicializa o app e aponta para a primeira tela.
void main() {
  runApp(const MobileTwoApp());
}

class MobileTwoApp extends StatelessWidget {
  const MobileTwoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile 2 - Design System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      ),
      home: const SampleScreen(),
    );
  }
}
