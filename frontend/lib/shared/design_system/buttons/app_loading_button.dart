import 'package:flutter/material.dart';

import 'app_button.dart';

/// A button that is already submitting.
///
/// Thin, intention-revealing convenience for the most common loading case:
/// a full-width primary button with a spinner. Every concern (colors, state,
/// sizes) lives in [AppButton] — this file exists only to read better at call
/// sites:
///
/// ```dart
/// AppLoadingButton(label: 'Saving...');
/// ```
class AppLoadingButton extends StatelessWidget {
  const AppLoadingButton({
    super.key,
    required this.label,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.isFullWidth = false,
    this.leadingIcon,
    this.trailingIcon,
  });

  final String label;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool isFullWidth;
  final IconData? leadingIcon;
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: label,
      variant: variant,
      size: size,
      isFullWidth: isFullWidth,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      onPressed: null,
      isLoading: true,
    );
  }
}
