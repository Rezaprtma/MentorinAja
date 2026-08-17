import 'dart:async';

import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';

/// Floating icon-only control bar for the learning workspace.
///
/// Carries the session controls — previous, next, voice and leave — that float
/// above the lesson content. The previous/next pair uses matching navigation
/// arrows, voice exposes on/off states through its icon, and the leave control
/// carries the destructive red treatment as the rightmost endpoint. The bar
/// auto-hides after a short period of inactivity; a tap on the lesson content
/// or the collapsed [↑] affordance restores it.
class LearningNavigationBar extends StatefulWidget {
  const LearningNavigationBar({
    super.key,
    required this.stageIndex,
    required this.stageCount,
    required this.hasPrevious,
    required this.isLast,
    required this.isDone,
    this.onUndo,
    this.onNext,
    this.onEnd,
  });

  /// Index of the active stage inside the player flow.
  final int stageIndex;

  /// Total number of stages in the flow.
  final int stageCount;

  /// Whether a previous lesson exists.
  final bool hasPrevious;

  /// Whether this is the last lesson of the course.
  final bool isLast;

  /// Whether the current lesson is already completed.
  final bool isDone;

  /// Moves back: previous stage when possible, previous lesson otherwise.
  final VoidCallback? onUndo;

  /// Moves forward: next stage when possible, completes the lesson otherwise.
  final VoidCallback? onNext;

  /// Ends the session with a confirmation.
  final VoidCallback? onEnd;

  /// Vertical space the floating bar reserves at the bottom of lesson content
  /// so exercises, feedback and inputs are never hidden behind it.
  static const double reservedContentSpace = 96;

  @override
  State<LearningNavigationBar> createState() => LearningNavigationBarState();
}

/// State for [LearningNavigationBar]; public so the lesson player can reset
/// the inactivity timer when the learner interacts with the lesson content.
class LearningNavigationBarState extends State<LearningNavigationBar> {
  /// Idle time before the control bar hides itself.
  static const Duration inactivityDelay = Duration(seconds: 4);

  bool _visible = true;
  bool _voiceOn = false;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    _startHideTimer();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  /// Brings the controls back (when hidden) and restarts the inactivity timer.
  void poke() {
    _hideTimer?.cancel();
    if (!_visible) {
      setState(() => _visible = true);
    }
    _startHideTimer();
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(inactivityDelay, () {
      if (!mounted) return;
      setState(() => _visible = false);
    });
  }

  void _toggleVoice() => setState(() => _voiceOn = !_voiceOn);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: AppSafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: AppSpacing.md),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: AnimatedSwitcher(
              duration: AppDurations.fast,
              layoutBuilder: (currentChild, previousChildren) => Stack(
                alignment: Alignment.bottomCenter,
                children: [...previousChildren, ?currentChild],
              ),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.4),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              ),
              child: _visible
                  ? KeyedSubtree(
                      key: const ValueKey('learning-controls'),
                      child: _buildControlBar(context),
                    )
                  : KeyedSubtree(
                      key: const ValueKey('learning-restore'),
                      child: _buildRestoreControl(context),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildControlBar(BuildContext context) {
    final ext = context.appColors;

    return Material(
      color: ext.card,
      elevation: AppElevation.md,
      shadowColor: Colors.black.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xxs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _controlButton(
              icon: Icons.arrow_back_rounded,
              tooltip: 'Pelajaran sebelumnya',
              onPressed: widget.onUndo,
            ),
            const SizedBox(width: AppSpacing.xxs),
            _controlButton(
              icon: Icons.arrow_forward_rounded,
              tooltip: 'Pelajaran berikutnya',
              onPressed: widget.onNext,
            ),
            _groupDivider(context),
            _controlButton(
              icon: _voiceOn ? Icons.mic_rounded : Icons.mic_off_rounded,
              tooltip: _voiceOn ? 'Microphone aktif' : 'Microphone nonaktif',
              onPressed: _toggleVoice,
              active: _voiceOn,
            ),
            _groupDivider(context),
            _endButton(context),
          ],
        ),
      ),
    );
  }

  Widget _groupDivider(BuildContext context) {
    final ext = context.appColors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      child: Container(width: 1, height: AppIconSizes.lg, color: ext.divider),
    );
  }

  Widget _controlButton({
    required IconData icon,
    required String tooltip,
    VoidCallback? onPressed,
    bool active = false,
  }) {
    final scheme = Theme.of(context).colorScheme;

    return IconButton(
      onPressed: onPressed == null
          ? null
          : () {
              onPressed();
              _startHideTimer();
            },
      tooltip: tooltip,
      icon: Icon(icon, size: AppIconSizes.lg),
      color: active ? scheme.onSecondaryContainer : scheme.onSurfaceVariant,
      style: active
          ? IconButton.styleFrom(
              backgroundColor: scheme.secondaryContainer,
              shape: const CircleBorder(),
            )
          : null,
    );
  }

  Widget _endButton(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return IconButton(
      onPressed: () {
        widget.onEnd?.call();
        _startHideTimer();
      },
      tooltip: 'Akhiri sesi belajar',
      icon: const Icon(Icons.logout_rounded, size: AppIconSizes.lg),
      color: scheme.onError,
      style: IconButton.styleFrom(
        backgroundColor: scheme.error,
        shape: const CircleBorder(),
      ),
    );
  }

  Widget _buildRestoreControl(BuildContext context) {
    final ext = context.appColors;

    return IconButton(
      onPressed: poke,
      tooltip: 'Tampilkan kontrol belajar',
      icon: const Icon(Icons.keyboard_arrow_up_rounded),
      style: IconButton.styleFrom(
        backgroundColor: ext.card,
        foregroundColor: ext.textPrimary,
        elevation: AppElevation.md,
        shadowColor: Colors.black.withValues(alpha: 0.12),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
