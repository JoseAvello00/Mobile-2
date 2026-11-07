import 'package:fastmob_design_system/fastmob_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_helpers.dart';

void main() {
  testWidgets('Gap sizes follow the spacing scale', (tester) async {
    await tester.pumpWidget(wrap(const Gap.lg()));
    final box = tester.getSize(find.byType(Gap));
    expect(box.width, AppSpacing.lg);
    expect(box.height, AppSpacing.lg);
  });

  testWidgets('SectionHeader uppercases title and fires action', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(
      wrap(
        SectionHeader(
          title: 'Hoje',
          actionLabel: 'Ver todos',
          onAction: () => taps++,
        ),
      ),
    );
    expect(find.text('HOJE'), findsOneWidget);
    await tester.tap(find.text('Ver todos'));
    expect(taps, 1);
  });

  testWidgets('AppScaffold renders title, body and bottom', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: const AppScaffold(
          title: 'FastMob',
          body: Text('corpo'),
          bottom: SizedBox(height: 40, child: Text('rodapé')),
        ),
      ),
    );
    expect(find.text('FastMob'), findsOneWidget);
    expect(find.text('corpo'), findsOneWidget);
    expect(find.text('rodapé'), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
  });

  testWidgets('BottomPanel shows its child under the handle', (tester) async {
    await tester.pumpWidget(wrap(const BottomPanel(child: Text('conteúdo'))));
    expect(find.text('conteúdo'), findsOneWidget);
  });
}
