import 'package:flutter/material.dart';

/// FastMob mark: a rounded square with a bolt, followed by the wordmark.
///
/// Use [onBrand] over the orange gradient (white mark, white text). Without
/// it the mark is solid orange and the text follows the theme.
class FastMobLogo extends StatelessWidget {
  const FastMobLogo({
    super.key,
    this.size = 56,
    this.onBrand = false,
    this.showWordmark = true,
  });

  /// Side of the square mark. The wordmark scales with it.
  final double size;
  final bool onBrand;
  final bool showWordmark;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final markColor = onBrand ? Colors.white : scheme.primary;
    final boltColor = onBrand ? scheme.primary : scheme.onPrimary;
    final textColor = onBrand ? Colors.white : scheme.onSurface;

    final mark = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: markColor,
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
      child: Icon(Icons.bolt_rounded, size: size * 0.64, color: boltColor),
    );

    return Semantics(
      label: 'FastMob',
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          mark,
          if (showWordmark) ...[
            SizedBox(width: size * 0.22),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'Fast',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  TextSpan(
                    text: 'Mob',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: textColor.withValues(alpha: 0.92),
                    ),
                  ),
                ],
              ),
              style: TextStyle(
                fontSize: size * 0.62,
                height: 1,
                letterSpacing: -0.8,
                color: textColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
