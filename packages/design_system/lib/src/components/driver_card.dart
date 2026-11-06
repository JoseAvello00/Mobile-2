import 'package:flutter/material.dart';

import '../theme/app_semantic_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';
import 'app_avatar.dart';

/// Driver and vehicle shown while a ride is on the way.
class DriverCard extends StatelessWidget {
  const DriverCard({
    required this.name,
    required this.rating,
    required this.vehicle,
    required this.plate,
    super.key,
    this.imageUrl,
    this.onCall,
    this.onMessage,
  });

  final String name;

  /// 0 to 5, shown with one decimal ("4,9").
  final double rating;

  /// Model and color ("Onix prata").
  final String vehicle;
  final String plate;
  final String? imageUrl;

  /// Each action only shows up when its callback is given.
  final VoidCallback? onCall;
  final VoidCallback? onMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final semantic = context.semanticColors;
    final ratingText = rating.toStringAsFixed(1).replaceAll('.', ',');

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: scheme.outline),
      ),
      child: Row(
        children: [
          AppAvatar(name: name, imageUrl: imageUrl, size: 52),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Icon(Icons.star_rounded, size: 16, color: semantic.star),
                    const SizedBox(width: AppSpacing.xxs),
                    Text(ratingText, style: theme.textTheme.bodySmall),
                  ],
                ),
                Text(
                  vehicle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: semantic.muted,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHighest,
                    borderRadius: AppRadius.smAll,
                    border: Border.all(color: scheme.outline),
                  ),
                  child: Text(
                    plate,
                    style: theme.textTheme.labelLarge?.copyWith(
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (onMessage != null)
            IconButton.filledTonal(
              tooltip: 'Enviar mensagem',
              onPressed: onMessage,
              icon: const Icon(Icons.chat_bubble_outline),
            ),
          if (onCall != null)
            IconButton.filledTonal(
              tooltip: 'Ligar',
              onPressed: onCall,
              icon: const Icon(Icons.call_outlined),
            ),
        ],
      ),
    );
  }
}
