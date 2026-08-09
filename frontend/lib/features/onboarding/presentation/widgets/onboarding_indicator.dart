import 'package:flutter/material.dart';

import 'package:frontend/core/theme/theme.dart';

/// Three-dot page indicator for the onboarding flow.
///
/// The active dot grows into a wide pill and uses the chapter [accent];
/// inactive dots stay neutral. Width and color animate with
/// [AppDurations.fast] and [AppEasing.standard]. Pass [inactiveColor] to
/// adapt the quiet dots to the chapter background.
class OnboardingIndicator extends StatelessWidget {
  const OnboardingIndicator({
    super.key,
    required this.accent,
    required this.current,
    this.total = 3,
    this.inactiveColor,
  });

  final Color accent;
  final int current;
  final int total;

  /// Inactive dot color; falls back to `surfaceContainerHighest`.
  final Color? inactiveColor;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final quietColor = inactiveColor ?? scheme.surfaceContainerHighest;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (index) {
        final isActive = index == current;

        return AnimatedContainer(
          duration: AppDurations.fast,
          curve: AppEasing.standard,
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
          width: isActive ? AppSpacing.xl : AppSpacing.xs,
          height: AppSpacing.xs,
          decoration: BoxDecoration(
            color: isActive ? accent : quietColor,
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
        );
      }),
    );
  }
}
