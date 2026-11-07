import 'package:flutter/material.dart';

import '../theme/app_semantic_colors.dart';
import '../tokens/app_durations.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';
import 'price_text.dart';

/// Selectable card of a ride category (Fast, Conforto, Moto, Eco...).
///
/// Meant for a horizontal list with a fixed height of about 132.
class RideOptionCard extends StatelessWidget {
  const RideOptionCard({
    required this.name,
    required this.subtitle,
    required this.priceCents,
    required this.eta,
    required this.icon,
    required this.onTap,
    super.key,
    this.selected = false,
    this.eco = false,
  });

  final String name;
  final String subtitle;
  final int priceCents;

  /// Time until the driver arrives, already formatted ("4 min").
  final String eta;
  final IconData icon;
  final bool selected;

  /// Electric category: adds a leaf badge and says so to screen readers.
  final bool eco;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final semantic = context.semanticColors;
    final muted = semantic.muted;

    return Semantics(
      button: true,
      selected: selected,
      excludeSemantics: true,
      label:
          '$name, ${PriceText.format(priceCents)}, chega em $eta'
          '${eco ? ', 100% elétrico' : ''}',
      child: AnimatedContainer(
        duration: AppDurations.normal,
        width: 148,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: selected ? scheme.primaryContainer : scheme.surface,
          borderRadius: AppRadius.lgAll,
          border: Border.all(
            color: selected ? scheme.primary : scheme.outline,
            width: selected ? 2 : 1,
          ),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AnimatedContainer(
                        duration: AppDurations.normal,
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: selected
                              ? scheme.primary
                              : scheme.surfaceContainerHighest,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          icon,
                          size: 20,
                          color: selected
                              ? scheme.onPrimary
                              : scheme.onSurface,
                        ),
                      ),
                      if (eco) ...[
                        const SizedBox(width: AppSpacing.xs),
                        Icon(
                          Icons.eco,
                          key: const Key('ride_option_eco'),
                          size: 16,
                          color: semantic.success,
                        ),
                      ],
                      const Spacer(),
                      Text(
                        eta,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: muted,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall,
                      ),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: muted,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      PriceText(
                        cents: priceCents,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
