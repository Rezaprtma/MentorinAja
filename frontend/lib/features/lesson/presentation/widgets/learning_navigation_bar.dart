//**
// frontend/features/lesson/presentation/widgets/learning_navigation_bar.dart
//
// frontend:
// Reusable widget. Menampilkan komponen UI yang dapat digunakan di berbagai places.
//
// backend:
// File ini tidak memiliki dependency langsung terhadap backend.
//
// api:
// File ini tidak mendefinisikan atau memanggil API secara langsung.
//
// qa:
// QA perlu memvalidasi widget rendering, responsiveness, dan accessibility.
//**
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';

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

  final int stageIndex;

  final int stageCount;

  final bool hasPrevious;

  final bool isLast;

  final bool isDone;

  final VoidCallback? onUndo;

  final VoidCallback? onNext;

  final VoidCallback? onEnd;

  static const double reservedContentSpace = 96;

  @override
  State<LearningNavigationBar> createState() => LearningNavigationBarState();
}

class LearningNavigationBarState extends State<LearningNavigationBar> {
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
    final isKeyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;
    if (isKeyboardOpen) {
      return const SizedBox.shrink();
    }

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
    final ext = context.appColors;

    return IconButton(
      onPressed: () {
        widget.onEnd?.call();
        _startHideTimer();
      },
      tooltip: 'Akhiri sesi belajar',
      icon: const Icon(Icons.logout_rounded, size: AppIconSizes.lg),
      color: widget.isDone ? ext.onSuccess : scheme.onError,
      style: IconButton.styleFrom(
        backgroundColor: widget.isDone ? ext.success : scheme.error,
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
