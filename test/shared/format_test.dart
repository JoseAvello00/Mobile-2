import 'package:fastmob/shared/format.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('formatEta', () {
    expect(formatEta(240), '4 min');
    expect(formatEta(10), '1 min');
    expect(formatEta(1580), '26 min');
  });

  test('formatCo2', () {
    expect(formatCo2(0), '0 g');
    expect(formatCo2(850), '850 g');
    expect(formatCo2(2130), '2,1 kg');
  });

  test('formatDistance', () {
    expect(formatDistance(850), '850 m');
    expect(formatDistance(14230), '14,2 km');
  });
}
