import 'package:flutter/material.dart';

import '../theme/app_semantic_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';

/// Environmental impact of a ride (FastMob's sustainable mobility promise).
///
/// Dumb component: the scene decides the texts, e.g. "Carro elétrico, zero
/// emissão local" for the Eco category and "Carbono compensado" for the rest.
class ImpactCard extends StatelessWidget {
  const ImpactCard({
    required this.title,
    required this.message,
    super.key,
    this.highlight,
    this.icon = Icons.eco_outlined,
  });

  final String title;
  final String message;

  /// Short figure shown in bold on the right ("850 g de CO₂ evitados").
  final String? highlight;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semantic = context.semanticColors;
    final color = semantic.success;

    return Semantics(
      container: true,
      label: [title, message, if (highlight != null) highlight!].join('. '),
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.10),
          borderRadius: AppRadius.lgAll,
          border: Border.all(color: color.withValues(alpha: 0.35)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.16),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleSmall),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    message,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: semantic.muted,
                    ),
                  ),
                ],
              ),
            ),
            if (highlight != null) ...[
              const SizedBox(width: AppSpacing.sm),
              Text(
                highlight!,
                textAlign: TextAlign.end,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
