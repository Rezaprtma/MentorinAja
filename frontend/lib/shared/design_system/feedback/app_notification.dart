import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';

/// Semantic variants of a notification.
enum AppNotificationType {
  /// Neutral/blue guidance.
  info,

  /// Positive confirmation.
  success,

  /// Blocking or destructive outcome.
  error,

  /// Timely caution.
  warning,
}

/// Static palette entry for a [AppNotificationType].
@immutable
class AppNotificationPalette {
  const AppNotificationPalette({
    required this.background,
    required this.foreground,
    required this.accent,
    required this.actionSurface,
    required this.border,
  });

  /// White card surface shared by every variant.
  final Color background;

  /// Title color; carries the severity on the otherwise neutral card.
  final Color foreground;

  /// Subtle icon accent (success/info/error/warning tint).
  final Color accent;

  /// Neutral button surface for the compact action chip.
  final Color actionSurface;

  /// Hairline card border separating the card from the page.
  final Color border;
}

/// Design-system notification card.
///
/// Single neutral visual language: every variant renders on a white surface
/// with a subtle border and shadow, and only the title and icon tint reflect
/// the [AppNotificationType]. The message always uses the secondary text tone.
/// Layout `[icon] - [title]/[message] - optional [action]` with the text block
/// vertically centered on the icon.
/// Pure presentation — animation and lifecycle live in [AppNotificationService].
class AppNotificationCard extends StatelessWidget {
  const AppNotificationCard({
    super.key,
    required this.type,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.onClose,
  });

  /// Which severity palette and icon to use.
  final AppNotificationType type;

  final String title;
  final String? message;

  /// Optional trailing action button.
  final String? actionLabel;
  final VoidCallback? onAction;

  /// Optional close button shown when there is no [actionLabel].
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final palette = AppNotificationService.paletteFor(type);
    final ext = context.appColors;
    final action = actionLabel;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: palette.background,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(color: palette.border),
        boxShadow: const [AppShadow.soft],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            AppNotificationService.iconFor(type),
            size: AppIconSizes.lg,
            color: palette.accent,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypeScale.titleSmall.copyWith(
                    color: palette.foreground,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.none,
                  ),
                ),
                if (message != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    message!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypeScale.bodySmall.copyWith(
                      color: ext.textSecondary,
                      fontWeight: FontWeight.w400,
                      height: 1.3,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          if (action != null)
            _ActionChip(label: action, onPressed: onAction, palette: palette)
          else if (onClose != null)
            IconButton(
              onPressed: onClose,
              icon: Icon(
                Icons.close,
                size: AppIconSizes.md,
                color: ext.textSecondary,
              ),
              constraints: const BoxConstraints.tightFor(width: 36, height: 36),
              padding: EdgeInsets.zero,
            ),
        ],
      ),
    );
  }
}

/// Compact raised action placed inside the notification card.
class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.label,
    required this.onPressed,
    required this.palette,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppNotificationPalette palette;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: palette.actionSurface,
        foregroundColor: ext.textPrimary,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xxs,
        ),
        minimumSize: const Size(0, 32),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.small),
        ),
        textStyle: AppTypeScale.labelMedium.copyWith(
          color: ext.textPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
      child: Text(label),
    );
  }
}

/// Global notification host.
///
/// Shows a single compact [AppNotificationCard] floating from the top SafeArea.
/// Success/info/warning auto-dismiss; errors persist until dismissed or until
/// an [actionLabel] is chosen. The card never blocks the rest of the UI.
class AppNotificationService {
  AppNotificationService._();

  static OverlayEntry? _current;

  static void show(
    BuildContext context, {
    required AppNotificationType type,
    required String title,
    String? message,
    String? actionLabel,
    VoidCallback? onAction,
    Duration? duration,
    VoidCallback? onDismiss,
  }) {
    _current?.remove();
    _current = null;

    final overlay = Overlay.of(context);
    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _AppNotificationOverlay(
        type: type,
        title: title,
        message: message,
        actionLabel: actionLabel,
        onAction: onAction,
        duration: duration ?? defaultDurationFor(type),
        onDismissed: () {
          if (_current == entry) _current = null;
          if (entry.mounted) entry.remove();
          onDismiss?.call();
        },
      ),
    );
    _current = entry;
    overlay.insert(entry);
  }

  /// Dismisses the visible notification immediately.
  static void dismiss() {
    _current?.remove();
    _current = null;
  }

  static Duration? defaultDurationFor(AppNotificationType type) {
    return switch (type) {
      AppNotificationType.success => const Duration(seconds: 3),
      AppNotificationType.info => const Duration(seconds: 4),
      AppNotificationType.warning => const Duration(seconds: 5),
      AppNotificationType.error => null,
    };
  }

  static AppNotificationPalette paletteFor(AppNotificationType type) {
    return switch (type) {
      AppNotificationType.success => const AppNotificationPalette(
        background: AppColors.surface,
        foreground: AppColors.textPrimary,
        accent: AppColors.success,
        actionSurface: AppColors.surfaceVariant,
        border: AppColors.border,
      ),
      AppNotificationType.error => const AppNotificationPalette(
        background: AppColors.surface,
        foreground: AppColors.error,
        accent: AppColors.error,
        actionSurface: AppColors.surfaceVariant,
        border: AppColors.border,
      ),
      AppNotificationType.warning => const AppNotificationPalette(
        background: AppColors.surface,
        foreground: AppColors.textPrimary,
        accent: AppColors.warning,
        actionSurface: AppColors.surfaceVariant,
        border: AppColors.border,
      ),
      AppNotificationType.info => const AppNotificationPalette(
        background: AppColors.surface,
        foreground: AppColors.textPrimary,
        accent: AppColors.info,
        actionSurface: AppColors.surfaceVariant,
        border: AppColors.border,
      ),
    };
  }

  static IconData iconFor(AppNotificationType type) {
    return switch (type) {
      AppNotificationType.success => Icons.check_circle_outline,
      AppNotificationType.error => Icons.error_outline,
      AppNotificationType.warning => Icons.warning_amber_rounded,
      AppNotificationType.info => Icons.info_outline,
    };
  }
}

class _AppNotificationOverlay extends StatefulWidget {
  const _AppNotificationOverlay({
    required this.type,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
    required this.duration,
    required this.onDismissed,
  });

  final AppNotificationType type;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Duration? duration;
  final VoidCallback onDismissed;

  @override
  State<_AppNotificationOverlay> createState() =>
      _AppNotificationOverlayState();
}

class _AppNotificationOverlayState extends State<_AppNotificationOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  Timer? _dismissTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: AppDurations.slow);
    final entrance = CurvedAnimation(
      parent: _controller,
      curve: AppEasing.decelerate,
    );
    _fade = entrance;
    _slide = Tween<Offset>(
      begin: const Offset(0, -0.4),
      end: Offset.zero,
    ).animate(entrance);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) widget.onDismissed();
    });
    _controller.forward();

    final hold = widget.duration;
    if (hold != null) {
      _dismissTimer = Timer(hold, () {
        if (mounted) _controller.reverse();
      });
    } else {
      _dismissTimer = Timer(const Duration(minutes: 1), () {
        if (mounted) _controller.reverse();
      });
    }
  }

  void _dismiss() {
    _dismissTimer?.cancel();
    if (mounted) _controller.reverse();
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.paddingOf(context).top + AppSpacing.sm,
      left: AppSpacing.md,
      right: AppSpacing.md,
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: FadeTransition(
            opacity: _fade,
            child: SlideTransition(
              position: _slide,
              child: AppNotificationCard(
                type: widget.type,
                title: widget.title,
                message: widget.message,
                actionLabel: widget.actionLabel,
                onAction: () {
                  widget.onAction?.call();
                  _dismiss();
                },
                onClose: widget.actionLabel == null ? _dismiss : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
