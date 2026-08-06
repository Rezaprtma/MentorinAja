import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';

/// Scrollable, responsive container for authentication screens.
///
/// Centers a single form column on large screens while keeping it edge-to-edge
/// on phones. Content scrolls when the keyboard appears so nothing overflows.
///
/// Provide either [child] for a fixed composition or [contentBuilder] to receive
/// the viewport [BoxConstraints] and derive proportional spacing (e.g. hero
/// height, section gaps from the available height).
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    this.child,
    this.contentBuilder,
    this.appBar,
    this.maxWidth = 480,
    this.background,
    this.backgroundColor,
  }) : assert(
         child != null || contentBuilder != null,
         'AuthScaffold requires either child or contentBuilder.',
       );

  /// Static content for form-based screens.
  final Widget? child;

  /// Builds content from the scrollable viewport constraints.
  final Widget Function(BuildContext context, BoxConstraints constraints)?
  contentBuilder;

  /// Optional top app bar (e.g. back navigation on login).
  final PreferredSizeWidget? appBar;

  /// Content width cap for tablets and desktops.
  final double maxWidth;

  /// Decorative layer painted behind the content, filling the whole screen.
  final Widget? background;

  /// Page background color; defaults to `appColors.background`.
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? context.appColors.background,
      appBar: appBar,
      body: Stack(
        fit: StackFit.expand,
        children: [
          ?background,
          AppSafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final content = contentBuilder != null
                    ? contentBuilder!(context, constraints)
                    : child!;

                Widget body = content;
                if (contentBuilder == null) {
                  body = Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxWidth),
                      child: content,
                    ),
                  );
                } else {
                  body = ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: content,
                  );
                }

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: body,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
