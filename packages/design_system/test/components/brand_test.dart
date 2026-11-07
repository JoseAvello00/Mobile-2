import 'package:fastmob_design_system/fastmob_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_helpers.dart';

void main() {
  group('FastMobLogo', () {
    testWidgets('shows the bolt mark and the wordmark', (tester) async {
      await tester.pumpWidget(wrap(const FastMobLogo()));
      expect(find.byIcon(Icons.bolt_rounded), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('can hide the wordmark', (tester) async {
      await tester.pumpWidget(wrap(const FastMobLogo(showWordmark: false)));
      expect(find.byIcon(Icons.bolt_rounded), findsOneWidget);
      expect(find.byType(Text), findsNothing);
    });
  });

  group('BrandHeader', () {
    testWidgets('renders logo, title and subtitle', (tester) async {
      await tester.pumpWidget(
        wrap(const BrandHeader(title: 'Chegue mais rápido.', subtitle: 'Já!')),
      );
      expect(find.byType(FastMobLogo), findsOneWidget);
      expect(find.text('Chegue mais rápido.'), findsOneWidget);
      expect(find.text('Já!'), findsOneWidget);
    });

    testWidgets('builds in dark theme', (tester) async {
      await tester.pumpWidget(wrap(dark: true, const BrandHeader(title: 'x')));
      expect(find.byType(BrandHeader), findsOneWidget);
    });
  });
}
