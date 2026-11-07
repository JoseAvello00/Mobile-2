import 'package:flutter/material.dart';

import '../theme/app_semantic_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';
import 'fastmob_logo.dart';
import 'gap.dart';

/// Orange hero that opens the entry screens (login, sign up).
///
/// Paints under the status bar by itself: put it in an `AppScaffold` with
/// `safeAreaTop: false`.
class BrandHeader extends StatelessWidget {
  const BrandHeader({required this.title, super.key, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: context.semanticColors.brandGradient,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(AppRadius.xl),
        ),
      ),
      child: Stack(
        children: [
          const Positioned(top: -48, right: -40, child: _Bubble(180, 0.12)),
          const Positioned(bottom: -56, left: -36, child: _Bubble(150, 0.08)),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.xl,
                AppSpacing.xl,
                AppSpacing.xxl,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const FastMobLogo(size: 44, onBrand: true),
                  const Gap.xxl(),
                  Semantics(
                    header: true,
                    child: Text(
                      title,
                      style: textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  if (subtitle != null) ...[
                    const Gap.sm(),
                    Text(
                      subtitle!,
                      style: textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withValues(alpha: 0.95),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble(this.size, this.opacity);

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: opacity),
      ),
      child: SizedBox.square(dimension: size),
    );
  }
}
