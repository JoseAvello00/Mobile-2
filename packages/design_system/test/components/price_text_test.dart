import 'package:fastmob_design_system/fastmob_design_system.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_helpers.dart';

void main() {
  group('PriceText.format', () {
    test('formats cents as Brazilian reais', () {
      expect(PriceText.format(0), r'R$ 0,00');
      expect(PriceText.format(5), r'R$ 0,05');
      expect(PriceText.format(860), r'R$ 8,60');
      expect(PriceText.format(1240), r'R$ 12,40');
    });

    test('groups thousands with a dot', () {
      expect(PriceText.format(123456), r'R$ 1.234,56');
      expect(PriceText.format(100000000), r'R$ 1.000.000,00');
    });

    test('keeps the sign of negative amounts', () {
      expect(PriceText.format(-500), r'-R$ 5,00');
    });
  });

  testWidgets('PriceText renders the formatted value', (tester) async {
    await tester.pumpWidget(wrap(const PriceText(cents: 1790)));
    expect(find.text(r'R$ 17,90'), findsOneWidget);
  });
}
