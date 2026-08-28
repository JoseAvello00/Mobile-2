import 'package:flutter/material.dart';

/// COMMON > Recursos em comum (cores)
/// Paleta central do Design System. Nenhum componente deve usar
/// Color(...) "hardcoded" diretamente — sempre referenciar esta classe.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF4F46E5);
  static const Color primaryDark = Color(0xFF3730A3);
  static const Color secondary = Color(0xFF14B8A6);

  static const Color background = Color(0xFFF8F9FB);
  static const Color surface = Color(0xFFFFFFFF);

  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  static const Color disabled = Color(0xFFD1D5DB);
  static const Color border = Color(0xFFE5E7EB);
  static const Color error = Color(0xFFDC2626);
}
