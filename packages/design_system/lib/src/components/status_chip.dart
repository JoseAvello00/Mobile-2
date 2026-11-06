import 'package:flutter/material.dart';

import '../theme/app_semantic_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';

/// Meaning of a [StatusChip]; maps to a semantic color.
enum StatusTone { neutral, success, info, warning, danger }

/// Small pill that names the state of something ("Motorista a caminho").
class StatusChip extends StatelessWidget {
  const StatusChip({
    required this.label,
    super.key,
    this.tone = StatusTone.neutral,
    this.icon,
  });

  final String label;
  final StatusTone tone;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final semantic = context.semanticColors;
    final color = switch (tone) {
      StatusTone.neutral => semantic.muted,
      StatusTone.success => semantic.success,
      StatusTone.info => semantic.info,
      StatusTone.warning => semantic.warning,
      StatusTone.danger => semantic.danger,
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs + AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: AppRadius.pillAll,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: AppSpacing.xs),
          ],
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontSize: 12,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
