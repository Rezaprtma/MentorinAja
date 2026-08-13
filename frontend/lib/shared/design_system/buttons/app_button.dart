import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';
import '../layout/app_gap.dart';

/// Visual variants of [AppButton], mapped 1:1 to Material 3 button types.
enum AppButtonVariant {
  /// Filled with the brand primary color — the main call to action.
  primary,

  /// Tonal filled with the secondary container — supporting actions.
  secondary,

  /// Bordered, transparent background — low emphasis.
  outlined,

  /// Borderless — the lowest emphasis.
  text,

  /// Filled with the error color — destructive or irreversible actions.
  danger,
}

/// Height tiers for [AppButton].
enum AppButtonSize {
  /// 40dp — dense, compact contexts.
  small,

  /// 48dp — default touch-target-friendly height.
  medium,

  /// 56dp — primary CTAs and hero actions.
  large,
}

/// The single entry point for all labeled buttons in the app.
///
/// Choosing one widget instead of one-per-variant keeps every button variant
/// consistent: same loading, disabled, full-width and icon APIs, same touch
/// targets, same state handling.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.onPressed,
    this.label,
    this.child,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.leadingIcon,
    this.trailingIcon,
    this.enabled = true,
    this.onLongPress,
  }) : assert(
         label != null || child != null,
         'AppButton requires either a label or a child.',
       );

  final VoidCallback? onPressed;
  final String? label;
  final Widget? child;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final bool enabled;
  final VoidCallback? onLongPress;

  double get _height => switch (size) {
    AppButtonSize.small => 40,
    AppButtonSize.medium => 48,
    AppButtonSize.large => 56,
  };

  TextStyle _labelStyle() => switch (size) {
    AppButtonSize.small => AppTypeScale.labelMedium,
    AppButtonSize.medium => AppTypeScale.labelLarge,
    AppButtonSize.large => AppTypeScale.labelLarge,
  };

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = context.appColors;
    final (background, foreground) = _palette(scheme, ext);

    final effectiveOnPressed = (enabled && !isLoading) ? onPressed : null;
    final style = _buildStyle(context, background, foreground);

    final Widget content = child ?? _buildContent(foreground);

    final button = switch (variant) {
      AppButtonVariant.outlined => OutlinedButton(
        onPressed: effectiveOnPressed,
        onLongPress: onLongPress,
        style: style,
        child: content,
      ),
      AppButtonVariant.text => TextButton(
        onPressed: effectiveOnPressed,
        onLongPress: onLongPress,
        style: style,
        child: content,
      ),
      AppButtonVariant.secondary => FilledButton.tonal(
        onPressed: effectiveOnPressed,
        onLongPress: onLongPress,
        style: style,
        child: content,
      ),
      AppButtonVariant.primary || AppButtonVariant.danger => FilledButton(
        onPressed: effectiveOnPressed,
        onLongPress: onLongPress,
        style: style,
        child: content,
      ),
    };

    if (!isLoading) return button;

    return Semantics(
      liveRegion: true,
      container: true,
      label: label ?? 'Loading',
      child: ExcludeSemantics(excluding: true, child: button),
    );
  }

  Widget _buildContent(Color foreground) {
    if (isLoading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: AppIconSizes.md,
            height: AppIconSizes.md,
            child: CircularProgressIndicator(
              strokeWidth: 2.4,
              color: foreground,
            ),
          ),
          if (label != null) ...[
            AppGap.xs,
            Flexible(fit: FlexFit.loose, child: Text(label!)),
          ],
        ],
      );
    }

    final labelWidget = label != null ? Text(label!) : null;
    final leading = leadingIcon != null
        ? Icon(leadingIcon, size: AppIconSizes.md)
        : null;
    final trailing = trailingIcon != null
        ? Icon(trailingIcon, size: AppIconSizes.md)
        : null;

    if (leading == null && trailing == null) {
      return labelWidget ?? const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (leading != null) ...[leading, AppGap.xs],
        if (labelWidget != null)
          Flexible(fit: FlexFit.loose, child: labelWidget),
        if (trailing != null) ...[AppGap.xs, trailing],
      ],
    );
  }

  ButtonStyle _buildStyle(
    BuildContext context,
    Color background,
    Color foreground,
  ) {
    final ext = context.appColors;
    final isOutline = variant == AppButtonVariant.outlined;

    return ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(background),
      foregroundColor: WidgetStatePropertyAll(foreground),
      overlayColor: WidgetStatePropertyAll(foreground.withValues(alpha: 0.12)),
      elevation: const WidgetStatePropertyAll(0),
      side: isOutline
          ? WidgetStatePropertyAll(BorderSide(color: ext.border))
          : const WidgetStatePropertyAll(BorderSide.none),
      shape: const WidgetStatePropertyAll(StadiumBorder()),
      minimumSize: WidgetStatePropertyAll(
        Size(isFullWidth ? double.infinity : 0, _height),
      ),
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(
          horizontal: isFullWidth ? AppSpacing.lg : AppSpacing.md,
        ),
      ),
      textStyle: WidgetStatePropertyAll(
        _labelStyle().copyWith(color: foreground),
      ),
    );
  }

  (Color, Color) _palette(ColorScheme scheme, AppThemeExtension ext) {
    return switch (variant) {
      AppButtonVariant.primary => (scheme.primary, scheme.onPrimary),
      AppButtonVariant.secondary => (
        scheme.secondaryContainer,
        scheme.onSecondaryContainer,
      ),
      AppButtonVariant.outlined => (Colors.transparent, scheme.primary),
      AppButtonVariant.text => (Colors.transparent, scheme.primary),
      AppButtonVariant.danger => (scheme.error, scheme.onError),
    };
  }
}
