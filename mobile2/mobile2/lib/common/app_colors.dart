import 'package:flutter/material.dart';

/// COMMON > Recursos em comum (cores)
/// Paleta central do Design System. Nenhum componente deve usar
/// Color(...) "hardcoded" diretamente — sempre referenciar esta classe.
class AppColors {
  AppColors._();

  // Extraídas do Figma "Food Delivery App" (botão "ADD TO CART", chips, cards)
  static const Color primary = Color(0xFFF2822C); // laranja principal
  static const Color primaryLight = Color(0xFFFFE7D2); // fundo de destaque suave
  static const Color secondary = Color(0xFF2B2B38); // pílula escura (quantidade, ícones ativos)

  static const Color background = Color(0xFFF7F7FA);
  static const Color surface = Color(0xFFFFFFFF);

  static const Color textPrimary = Color(0xFF1E1E26);
  static const Color textSecondary = Color(0xFF8C8C9A);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  static const Color disabled = Color(0xFFE3E3EA);
  static const Color border = Color(0xFFEDEDF2);
  static const Color error = Color(0xFFE0483E);
  static const Color star = Color(0xFFF2822C);
}
