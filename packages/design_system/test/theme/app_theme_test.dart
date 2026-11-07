import 'package:fastmob_design_system/fastmob_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppTheme', () {
    test('light theme is built from the light palette', () {
      final theme = AppTheme.light();
      expect(theme.brightness, Brightness.light);
      expect(theme.colorScheme.primary, AppColors.light.primary);
      expect(theme.scaffoldBackgroundColor, AppColors.light.background);
    });

    test('dark theme is built from the dark palette', () {
      final theme = AppTheme.dark();
      expect(theme.brightness, Brightness.dark);
      expect(theme.colorScheme.primary, AppColors.dark.primary);
      expect(theme.scaffoldBackgroundColor, AppColors.dark.background);
    });

    test('the brand color is orange in both themes', () {
      for (final palette in [AppColors.light, AppColors.dark]) {
        final hue = HSLColor.fromColor(palette.primary).hue;
        expect(hue, inInclusiveRange(15, 35));
      }
    });

    test('both themes register AppSemanticColors', () {
      for (final theme in [AppTheme.light(), AppTheme.dark()]) {
        final semantic = theme.extension<AppSemanticColors>();
        expect(semantic, isNotNull);
        expect(semantic!.success, isNot(semantic.danger));
      }
    });

    test('selected segments use the orange container, not blue', () {
      for (final (theme, palette) in [
        (AppTheme.light(), AppColors.light),
        (AppTheme.dark(), AppColors.dark),
      ]) {
        final style = theme.segmentedButtonTheme.style!;
        expect(
          style.backgroundColor!.resolve({WidgetState.selected}),
          palette.primaryContainer,
        );
        expect(style.backgroundColor!.resolve({}), palette.surface);
      }
    });

    testWidgets('context.semanticColors reads the extension', (tester) async {
      late AppSemanticColors colors;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Builder(
            builder: (context) {
              colors = context.semanticColors;
              return const SizedBox();
            },
          ),
        ),
      );
      expect(colors.danger, AppColors.light.error);
      expect(colors.brandGradient.colors, [
        AppColors.light.brandStart,
        AppColors.light.brandEnd,
      ]);
    });
  });
}
