import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';

/// Colors that carry meaning in a mobility app and have no slot in
/// [ColorScheme]: success, info, warning, danger, the rating star and the
/// brand gradient.
///
/// Registered as a [ThemeExtension] so widgets read them with
/// `context.semanticColors`.
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors({
    required this.success,
    required this.info,
    required this.warning,
    required this.danger,
    required this.star,
    required this.muted,
    required this.brandStart,
    required this.brandEnd,
  });

  factory AppSemanticColors.fromPalette(AppColorPalette palette) {
    return AppSemanticColors(
      success: palette.success,
      info: palette.info,
      warning: palette.warning,
      danger: palette.error,
      star: palette.star,
      muted: palette.onSurfaceMuted,
      brandStart: palette.brandStart,
      brandEnd: palette.brandEnd,
    );
  }

  final Color success;
  final Color info;
  final Color warning;
  final Color danger;
  final Color star;

  /// Secondary text color.
  final Color muted;

  final Color brandStart;
  final Color brandEnd;

  /// Diagonal gradient used by the brand hero.
  LinearGradient get brandGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [brandStart, brandEnd],
  );

  @override
  AppSemanticColors copyWith({
    Color? success,
    Color? info,
    Color? warning,
    Color? danger,
    Color? star,
    Color? muted,
    Color? brandStart,
    Color? brandEnd,
  }) {
    return AppSemanticColors(
      success: success ?? this.success,
      info: info ?? this.info,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
      star: star ?? this.star,
      muted: muted ?? this.muted,
      brandStart: brandStart ?? this.brandStart,
      brandEnd: brandEnd ?? this.brandEnd,
    );
  }

  @override
  AppSemanticColors lerp(AppSemanticColors? other, double t) {
    if (other == null) return this;
    return AppSemanticColors(
      success: Color.lerp(success, other.success, t)!,
      info: Color.lerp(info, other.info, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      star: Color.lerp(star, other.star, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      brandStart: Color.lerp(brandStart, other.brandStart, t)!,
      brandEnd: Color.lerp(brandEnd, other.brandEnd, t)!,
    );
  }
}

/// Shortcut: `context.semanticColors.success`.
extension SemanticColorsContext on BuildContext {
  AppSemanticColors get semanticColors {
    final colors = Theme.of(this).extension<AppSemanticColors>();
    assert(
      colors != null,
      'AppSemanticColors is missing. Use AppTheme.light() or AppTheme.dark().',
    );
    return colors!;
  }
}
