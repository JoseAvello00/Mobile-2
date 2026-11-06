import 'package:flutter/material.dart';

import '../theme/app_semantic_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';

/// Role of a place in a trip; decides the marker drawn on the left.
enum LocationKind { origin, destination, stop }

/// One address row: marker, title, optional subtitle and trailing widget.
class LocationTile extends StatelessWidget {
  const LocationTile({
    required this.title,
    super.key,
    this.subtitle,
    this.kind = LocationKind.destination,
    this.trailing,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final LocationKind kind;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = context.semanticColors.muted;

    return Semantics(
      button: onTap != null,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.mdAll,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Row(
            children: [
              _Marker(kind),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall,
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: muted,
                        ),
                      ),
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: AppSpacing.sm),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Marker extends StatelessWidget {
  const _Marker(this.kind);

  final LocationKind kind;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final muted = context.semanticColors.muted;

    final Widget shape = switch (kind) {
      LocationKind.origin => Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: muted, width: 3.5),
        ),
      ),
      LocationKind.destination => Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(
          color: scheme.primary,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      LocationKind.stop => Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(color: muted, shape: BoxShape.circle),
      ),
    };
    return SizedBox.square(dimension: 20, child: Center(child: shape));
  }
}
