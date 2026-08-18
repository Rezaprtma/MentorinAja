//**
// frontend/features/lesson/presentation/widgets/games/token_completion_game.dart
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

import 'package:frontend/shared/design_system/design_system.dart';

import '../../../domain/entities/lesson_exercise.dart';
import '../exercises/exercise_card.dart';
import '../exercises/exercise_feedback.dart';

class TokenCompletionGame extends StatefulWidget {
  const TokenCompletionGame({
    super.key,
    required this.exercise,
    this.selfEvaluate = false,
    this.gameCounter,
  });

  final LessonExercise exercise;
  final bool selfEvaluate;
  final String? gameCounter;

  @override
  State<TokenCompletionGame> createState() => _TokenCompletionGameState();
}

class _TokenCompletionGameState extends State<TokenCompletionGame> {
  late final List<String?> _answers = List<String?>.filled(
    widget.exercise.blanks.length,
    null,
  );
  bool _submitted = false;
  bool _correct = false;
  bool _showHint = false;

  bool get _complete => _answers.every((answer) => answer != null);

  bool get _answersAreCorrect {
    final blanks = widget.exercise.blanks;
    return List.generate(blanks.length, (i) {
      final answer = _answers[i];
      return answer == blanks[i].token || blanks[i].accept.contains(answer);
    }).every((value) => value);
  }

  void _tapOption(String token) {
    if (_submitted && _correct) return;

    final firstEmpty = _answers.indexWhere((answer) => answer == null);
    if (firstEmpty < 0) return;

    setState(() {
      _answers[firstEmpty] = token;
      if (widget.selfEvaluate) {
        _submitted = _complete;
        _correct = _complete && _answersAreCorrect;
      } else {
        _submitted = false;
        _correct = false;
      }
    });
  }

  void _clearBlank(int index) {
    if (_submitted && _correct) return;
    setState(() {
      _answers[index] = null;
      _submitted = false;
      _correct = false;
      _showHint = false;
    });
  }

  void _submit() {
    if (!_complete) return;
    setState(() {
      _submitted = true;
      _correct = _answersAreCorrect;
    });
  }

  void _revealHint() {
    setState(() => _showHint = true);
  }

  @override
  Widget build(BuildContext context) {
    final exercise = widget.exercise;
    final ext = context.appColors;

    return ExerciseCard(
      exercise: exercise,
      isGame: true,
      gameCounter: widget.gameCounter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _GameCodeSurface(
            code: exercise.code ?? '',
            blanks: exercise.blanks,
            answers: _answers,
            onClear: _clearBlank,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Pilih token',
            style: AppTypeScale.labelMedium.copyWith(
              color: ext.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              for (final token in exercise.options)
                _TokenChip(
                  token: token,
                  usage: _usageOf(token),
                  onTap: () => _tapOption(token),
                  disabled: _submitted && _correct,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          if (!widget.selfEvaluate)
            AppButton(
              label: _submitted && !_correct ? 'Periksa Lagi' : 'Selesai',
              isFullWidth: true,
              onPressed: _complete ? _submit : null,
            ),
          if (_submitted) ...[
            const SizedBox(height: AppSpacing.sm),
            ExerciseFeedbackPanel(
              isCorrect: _correct,
              message: _correct
                  ? 'Tepat sekali! Kode kamu benar.'
                  : 'Belum tepat. Coba perhatikan token yang kamu tempatkan.',
              explanation: _correct ? exercise.explanation : null,
              hint: exercise.hint,
              onShowHint: _showHint ? null : _revealHint,
            ),
            if (!_correct && _showHint && exercise.hint != null) ...[
              const SizedBox(height: AppSpacing.sm),
              ExerciseHintView(hint: exercise.hint!),
            ],
          ],
        ],
      ),
    );
  }

  int _usageOf(String token) =>
      _answers.where((answer) => answer == token).length;
}

class _GameCodeSurface extends StatelessWidget {
  const _GameCodeSurface({
    required this.code,
    required this.blanks,
    required this.answers,
    required this.onClear,
  });

  final String code;
  final List<CodeCompletionBlank> blanks;
  final List<String?> answers;
  final ValueChanged<int> onClear;

  @override
  Widget build(BuildContext context) {
    final segments = code.split('____');
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final codeBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final codeTextColor = isDark
        ? const Color(0xFFF8FAFC)
        : const Color(0xFF0F172A);
    final codeBorderColor = isDark
        ? const Color(0xFF1E293B)
        : const Color(0xFFE2E8F0);

    final spans = <InlineSpan>[];
    for (var i = 0; i < segments.length; i++) {
      if (segments[i].isNotEmpty) {
        spans.add(TextSpan(text: segments[i]));
      }
      if (i < blanks.length) {
        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: _BlankSlot(
              token: answers[i],
              onTap: answers[i] == null ? null : () => onClear(i),
            ),
          ),
        );
      }
    }

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: codeBg,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: codeBorderColor),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Text.rich(
          TextSpan(
            style: AppTypeScale.code.copyWith(color: codeTextColor),
            children: spans,
          ),
        ),
      ),
    );
  }
}

class _BlankSlot extends StatelessWidget {
  const _BlankSlot({required this.token, this.onTap});

  final String? token;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final scheme = Theme.of(context).colorScheme;
    final filled = token != null;
    final borderColor = filled ? ext.success : scheme.outline;
    final textColor = filled ? ext.onSuccessContainer : ext.textDisabled;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          constraints: const BoxConstraints(minWidth: 40, minHeight: 26),
          padding: const EdgeInsets.symmetric(horizontal: 6),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: filled ? ext.successContainer : ext.card,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: borderColor, width: filled ? 1.4 : 1),
          ),
          child: Text(
            filled ? token! : '····',
            style: AppTypeScale.code.copyWith(
              color: textColor,
              fontWeight: filled ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}

class _TokenChip extends StatelessWidget {
  const _TokenChip({
    required this.token,
    required this.usage,
    required this.onTap,
    required this.disabled,
  });

  final String token;
  final int usage;
  final VoidCallback onTap;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final scheme = Theme.of(context).colorScheme;
    final used = usage > 0;

    return Semantics(
      button: true,
      label: 'Token $token${used ? ', terpakai $usage kali' : ''}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: disabled ? null : onTap,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          child: AnimatedContainer(
            duration: AppDurations.fast,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: used ? scheme.primaryContainer : ext.card,
              borderRadius: BorderRadius.circular(AppRadius.pill),
              border: Border.all(
                color: used ? scheme.primary : scheme.outline,
                width: used ? 1.4 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (used) ...[
                  Icon(
                    Icons.check_rounded,
                    size: AppIconSizes.xs,
                    color: scheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: AppSpacing.xxs),
                ],
                Text(
                  usage > 1 ? '$token ×$usage' : token,
                  style: AppTypeScale.code.copyWith(
                    color: used ? scheme.onPrimaryContainer : ext.textPrimary,
                    fontWeight: used ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
