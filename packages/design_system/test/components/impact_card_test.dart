import 'package:fastmob_design_system/fastmob_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_helpers.dart';

void main() {
  group('ImpactCard', () {
    testWidgets('shows title, message and highlight', (tester) async {
      await tester.pumpWidget(
        wrap(
          const ImpactCard(
            title: 'Carro elétrico, zero emissão local',
            message: 'Você evita a emissão de um carro a combustão.',
            highlight: '850 g de CO₂',
          ),
        ),
      );
      expect(find.text('Carro elétrico, zero emissão local'), findsOneWidget);
      expect(find.text('850 g de CO₂'), findsOneWidget);
      expect(find.byIcon(Icons.eco_outlined), findsOneWidget);
    });

    testWidgets('reads as one sentence to screen readers', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        wrap(
          const ImpactCard(
            title: 'Carbono compensado',
            message: 'A FastMob compensa 100%.',
          ),
        ),
      );
      expect(
        find.bySemanticsLabel('Carbono compensado. A FastMob compensa 100%.'),
        findsOneWidget,
      );
      handle.dispose();
    });

    testWidgets('builds in the dark theme', (tester) async {
      await tester.pumpWidget(
        wrap(dark: true, const ImpactCard(title: 'a', message: 'b')),
      );
      expect(find.byType(ImpactCard), findsOneWidget);
    });
  });
}
