import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';
import '../layout/app_gap.dart';

/// Themed bottom sheet wrapper with a static [show] helper.
///
/// Composes a drag handle, an optional title and scrollable content inside
/// the shell provided by `showModalBottomSheet`. The global [BottomSheetTheme]
/// set in [AppTheme] handles radius and drag-handle visibility, but this
/// widget gives fine-grained control over padding, scroll behavior and actions.
class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({
    super.key,
    this.title,
    this.subtitle,
    this.actions,
    required this.child,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.sm,
    ),
    this.scrollControlled = false,
  });

  final String? title;
  final String? subtitle;
  final List<Widget>? actions;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool scrollControlled;

  /// Displays a modal bottom sheet.
  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
    String? title,
    String? subtitle,
    List<Widget>? actions,
    bool scrollControlled = false,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: scrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      useSafeArea: true,
      builder: (_) => AppBottomSheet(
        title: title,
        subtitle: subtitle,
        actions: actions,
        scrollControlled: scrollControlled,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (title != null || subtitle != null) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null)
                  Text(
                    title!,
                    style: AppTypeScale.titleMedium.copyWith(
                      color: ext.textPrimary,
                    ),
                  ),
                if (subtitle != null) ...[
                  AppGap.xxs,
                  Text(
                    subtitle!,
                    style: AppTypeScale.bodySmall.copyWith(
                      color: ext.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        Flexible(child: child),
        if (actions != null && actions!.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              children: actions!.map((a) => Expanded(child: a)).toList(),
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.md),
      ],
    );

    if (scrollControlled) {
      return DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Padding(
          padding: padding,
          child: ListView(controller: scrollController, children: [content]),
        ),
      );
    }

    return Padding(padding: padding, child: content);
  }
}
