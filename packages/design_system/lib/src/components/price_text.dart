import 'package:flutter/material.dart';

import '../tokens/app_typography.dart';

/// Brazilian-real price from an amount in cents (`1240` -> `R$ 12,40`).
///
/// The API sends money as integer cents (see `docs/api`), so the app never
/// handles floating point prices.
class PriceText extends StatelessWidget {
  const PriceText({required this.cents, super.key, this.style});

  final int cents;
  final TextStyle? style;

  /// `1240` -> `R$ 12,40`, `123456` -> `R$ 1.234,56`, `-500` -> `-R$ 5,00`.
  static String format(int cents) {
    final absolute = cents.abs();
    final reais = (absolute ~/ 100).toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => '.',
    );
    final centavos = (absolute % 100).toString().padLeft(2, '0');
    return '${cents < 0 ? '-' : ''}R\$ $reais,$centavos';
  }

  @override
  Widget build(BuildContext context) {
    final base = style ?? Theme.of(context).textTheme.bodyMedium;
    return Text(
      format(cents),
      style: base?.copyWith(fontFeatures: AppTypography.tabularFigures),
    );
  }
}
