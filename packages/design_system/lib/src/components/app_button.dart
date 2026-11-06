import 'package:flutter/material.dart';

import '../tokens/app_spacing.dart';

/// Visual weight of an [AppButton].
enum AppButtonVariant { primary, secondary, text }

/// Button of the design system.
///
/// While [isLoading] is true the button shows a spinner and ignores taps, so
/// a ViewModel can bind it straight to a running command.
class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.icon,
    this.expanded = true,
  });

  const AppButton.secondary({
    required this.label,
    required this.onPressed,
    super.key,
    this.isLoading = false,
    this.icon,
    this.expanded = true,
  }) : variant = AppButtonVariant.secondary;

  const AppButton.text({
    required this.label,
    required this.onPressed,
    super.key,
    this.isLoading = false,
    this.icon,
    this.expanded = false,
  }) : variant = AppButtonVariant.text;

  final String label;

  /// Null disables the button.
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final IconData? icon;

  /// Stretch to the parent's width. Text buttons default to false.
  final bool expanded;

  bool get _enabled => onPressed != null && !isLoading;

  // While loading, the button keeps its colors (instead of turning grey) but
  // swallows taps.
  static void _ignoreTap() {}

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final child = _Content(
      label: label,
      icon: icon,
      isLoading: isLoading,
      spinnerColor: variant == AppButtonVariant.primary
          ? scheme.onPrimary
          : scheme.primary,
    );
    final VoidCallback? callback = _enabled
        ? onPressed
        : (isLoading ? _ignoreTap : null);

    final Widget button = switch (variant) {
      AppButtonVariant.primary => FilledButton(
        onPressed: callback,
        child: child,
      ),
      AppButtonVariant.secondary => OutlinedButton(
        onPressed: callback,
        child: child,
      ),
      AppButtonVariant.text => TextButton(onPressed: callback, child: child),
    };

    return Semantics(
      button: true,
      enabled: _enabled,
      label: label,
      child: expanded
          ? SizedBox(width: double.infinity, child: button)
          : button,
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    required this.label,
    required this.icon,
    required this.isLoading,
    required this.spinnerColor,
  });

  final String label;
  final IconData? icon;
  final bool isLoading;
  final Color spinnerColor;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SizedBox.square(
        dimension: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2.4,
          color: spinnerColor,
        ),
      );
    }
    if (icon == null) return Text(label);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: AppSpacing.sm),
        Text(label),
      ],
    );
  }
}
