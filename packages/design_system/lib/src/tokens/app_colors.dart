import 'package:flutter/material.dart';

/// Raw color palette of the FastMob design system.
///
/// Two palettes, one per brightness, with the same field names so the theme
/// can be built from either one. Widgets never read these directly; they go
/// through [ThemeData] or `AppSemanticColors`.
class AppColorPalette {
  const AppColorPalette({
    required this.primary,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.brandStart,
    required this.brandEnd,
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.outline,
    required this.success,
    required this.info,
    required this.warning,
    required this.star,
    required this.error,
    required this.onError,
  });

  final Color primary;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;

  /// Both ends of the brand gradient (hero areas, splash).
  final Color brandStart;
  final Color brandEnd;

  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color outline;

  /// Ride confirmed, trip finished.
  final Color success;

  /// Driver on the way, neutral highlights.
  final Color info;
  final Color warning;

  /// Driver rating star.
  final Color star;
  final Color error;
  final Color onError;
}

/// The two official palettes.
abstract final class AppColors {
  /// Light palette: warm off-white grounds with a vivid orange accent.
  static const AppColorPalette light = AppColorPalette(
    primary: Color(0xFFE85D04),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFFFE8D6),
    onPrimaryContainer: Color(0xFF5C2200),
    brandStart: Color(0xFFFF7F1F),
    brandEnd: Color(0xFFD94F00),
    background: Color(0xFFFFF8F3),
    surface: Color(0xFFFFFFFF),
    surfaceVariant: Color(0xFFF6EEE8),
    onSurface: Color(0xFF1F1A17),
    onSurfaceMuted: Color(0xFF6F625A),
    outline: Color(0xFFE6DAD1),
    success: Color(0xFF1E8E5A),
    info: Color(0xFF2F6FDE),
    warning: Color(0xFF9A5B00),
    star: Color(0xFFF5A524),
    error: Color(0xFFC93B2B),
    onError: Color(0xFFFFFFFF),
  );

  /// Dark palette: the same hues lifted so they read on dark grounds.
  static const AppColorPalette dark = AppColorPalette(
    primary: Color(0xFFFF8A3D),
    onPrimary: Color(0xFF2B1000),
    primaryContainer: Color(0xFF5A2A0A),
    onPrimaryContainer: Color(0xFFFFD9BF),
    brandStart: Color(0xFFB84300),
    brandEnd: Color(0xFF7A2A00),
    background: Color(0xFF15110E),
    surface: Color(0xFF1E1915),
    surfaceVariant: Color(0xFF2A231E),
    onSurface: Color(0xFFF3ECE7),
    onSurfaceMuted: Color(0xFFA89A90),
    outline: Color(0xFF3A312B),
    success: Color(0xFF4FC38A),
    info: Color(0xFF7AA7FF),
    warning: Color(0xFFE8B04A),
    star: Color(0xFFF5B94A),
    error: Color(0xFFF28B7D),
    onError: Color(0xFF2A0F0B),
  );
}
