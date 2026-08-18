//**
// frontend/features/tutor/presentation/widgets/ai_tutor_panel.dart
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
library;

import 'package:flutter/material.dart';

import 'package:frontend/core/assets/app_logo.dart';
import 'package:frontend/shared/design_system/design_system.dart';
import 'package:frontend/shared/widgets/widgets.dart';

import '../../application/tutor_controller.dart';
import '../../domain/entities/tutor_message.dart';

Future<void> showAiTutorPanel(
  BuildContext context, {
  required TutorLessonContext lessonContext,
}) {
  final controller = TutorController(context: lessonContext);
  final width = MediaQuery.sizeOf(context).width;
  if (width >= 720) {
    return showDialog<void>(
      context: context,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.all(AppSpacing.xl),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520, maxHeight: 720),
          child: AiTutorPanel(controller: controller),
        ),
      ),
    );
  }

  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => FractionallySizedBox(
      heightFactor: 0.92,
      child: AiTutorPanel(controller: controller, embeddedInSheet: true),
    ),
  );
}

class AiTutorPanel extends StatefulWidget {
  const AiTutorPanel({
    super.key,
    required this.controller,
    this.embeddedInSheet = false,
  });

  final TutorController controller;
  final bool embeddedInSheet;

  @override
  State<AiTutorPanel> createState() => _AiTutorPanelState();
}

class _AiTutorPanelState extends State<AiTutorPanel> {
  final TextEditingController _input = TextEditingController();

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  Future<void> _send([String? override]) async {
    final text = (override ?? _input.text).trim();
    if (text.isEmpty) return;
    _input.clear();
    await widget.controller.send(text);
  }

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final bottomInset = widget.embeddedInSheet
        ? MediaQuery.viewInsetsOf(context).bottom
        : 0.0;

    return Material(
      color: ext.card,
      borderRadius: widget.embeddedInSheet
          ? BorderRadius.zero
          : BorderRadius.circular(AppRadius.extraLarge),
      child: SafeArea(
        top: !widget.embeddedInSheet,
        bottom: true,
        child: AnimatedPadding(
          duration: AppDurations.fast,
          padding: EdgeInsets.only(bottom: bottomInset),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.md,
              widget.embeddedInSheet ? AppSpacing.sm : AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md,
            ),
            child: ListenableBuilder(
              listenable: Listenable.merge([widget.controller, _input]),
              builder: (context, _) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _Header(
                    contextTitle: widget.controller.contextTitle,
                    onClose: () => Navigator.of(context).maybePop(),
                  ),
                  Expanded(
                    child: ListView(
                      reverse: true,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.md,
                      ),
                      children: [
                        if (widget.controller.isThinking) ...[
                          const _ThinkingBubble(),
                          const SizedBox(height: AppSpacing.sm),
                        ],
                        for (final message
                            in widget.controller.messages.reversed) ...[
                          _MessageBubble(message: message),
                          const SizedBox(height: AppSpacing.sm),
                        ],
                      ],
                    ),
                  ),
                  if (!widget.controller.conversationStarted) ...[
                    _SuggestedPrompts(onTap: _send),
                    const SizedBox(height: AppSpacing.sm),
                  ],
                  _Composer(
                    controller: _input,
                    canSend: _input.text.trim().isNotEmpty,
                    onSend: () => _send(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.contextTitle, required this.onClose});

  final String contextTitle;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final scheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: scheme.primary,
            shape: BoxShape.circle,
          ),
          child: const AppSvg(
            AppLogo.onBrand,
            width: 30,
            height: 30,
            fit: BoxFit.contain,
            semanticsLabel: 'Mentorin AI',
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mentorin AI',
                style: AppTypeScale.titleMedium.copyWith(
                  color: ext.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                contextTitle,
                style: AppTypeScale.bodySmall.copyWith(
                  color: ext.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        AppIconButton(
          icon: Icons.close_rounded,
          tooltip: 'Tutup Mentorin AI',
          onPressed: onClose,
        ),
      ],
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final TutorMessage message;

  void _copy(BuildContext context, String code) {
    AppToast.show(
      context,
      title: 'Kode Disalin',
      message: 'Kode sudah ada di clipboard.',
      severity: AppFeedbackSeverity.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final scheme = Theme.of(context).colorScheme;
    final learner = message.role == TutorMessageRole.learner;

    return Column(
      crossAxisAlignment: learner
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Align(
          alignment: learner ? Alignment.centerRight : Alignment.centerLeft,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: learner ? scheme.primary : scheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(AppRadius.large).copyWith(
                  bottomRight: learner
                      ? const Radius.circular(AppRadius.small)
                      : null,
                  bottomLeft: learner
                      ? null
                      : const Radius.circular(AppRadius.small),
                ),
              ),
              child: Text(
                message.text,
                style: AppTypeScale.bodyMedium.copyWith(
                  color: learner ? scheme.onPrimary : ext.textPrimary,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ),
        if (message.code != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Align(
            alignment: Alignment.centerLeft,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: AppCodeBlock(
                code: message.code!,
                label: message.codeLabel ?? 'Kode',
                onCopy: (code) => _copy(context, code),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _ThinkingBubble extends StatelessWidget {
  const _ThinkingBubble();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(AppRadius.large),
        ),
        child: const Text(
          'Mentorin AI sedang menyusun jawaban...',
          style: AppTypeScale.bodySmall,
        ),
      ),
    );
  }
}

class _SuggestedPrompts extends StatelessWidget {
  const _SuggestedPrompts({required this.onTap});

  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final prompt in TutorController.suggestedPrompts) ...[
            ActionChip(label: Text(prompt), onPressed: () => onTap(prompt)),
            const SizedBox(width: AppSpacing.xs),
          ],
        ],
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer({
    required this.controller,
    required this.canSend,
    required this.onSend,
  });

  final TextEditingController controller;
  final bool canSend;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            minLines: 1,
            maxLines: 3,
            decoration: const InputDecoration(hintText: 'Tanya Mentorin AI...'),
            textInputAction: TextInputAction.send,
            onSubmitted: (_) {
              if (canSend) onSend();
            },
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        AppIconButton(
          icon: Icons.send_rounded,
          tooltip: 'Kirim pertanyaan',
          color: canSend ? scheme.onPrimary : scheme.onSurfaceVariant,
          backgroundColor: canSend
              ? scheme.primary
              : scheme.surfaceContainerHighest,
          onPressed: canSend ? onSend : null,
        ),
      ],
    );
  }
}
