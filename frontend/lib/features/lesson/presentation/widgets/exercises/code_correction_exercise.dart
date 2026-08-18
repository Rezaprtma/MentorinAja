//**
// frontend/features/lesson/presentation/widgets/exercises/code_correction_exercise.dart
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
import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';

import '../../../domain/entities/lesson_exercise.dart';
import 'exercise_card.dart';
import 'exercise_feedback.dart';

class CodeCorrectionExercise extends StatefulWidget {
  const CodeCorrectionExercise({
    super.key,
    required this.exercise,
    this.selfEvaluate = false,
  });

  final LessonExercise exercise;
  final bool selfEvaluate;

  @override
  State<CodeCorrectionExercise> createState() => _CodeCorrectionExerciseState();
}

class _CodeCorrectionExerciseState extends State<CodeCorrectionExercise> {
  int? _selected;
  bool _submitted = false;
  bool _correct = false;
  bool _showHint = false;

  void _select(int index) {
    if (_submitted && _correct) return;
    setState(() {
      _selected = index;
      _showHint = false;
      if (widget.selfEvaluate) {
        _submitted = true;
        _correct = widget.exercise.choices[index].isCorrect;
      } else {
        _submitted = false;
        _correct = false;
      }
    });
  }

  void _submit() {
    final selected = _selected;
    if (selected == null) return;
    setState(() {
      _submitted = true;
      _correct = widget.exercise.choices[selected].isCorrect;
    });
  }

  @override
  Widget build(BuildContext context) {
    final exercise = widget.exercise;

    return ExerciseCard(
      exercise: exercise,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _CodeSurface(code: exercise.code ?? ''),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Pilih perbaikan',
            style: AppTypeScale.labelMedium.copyWith(
              color: context.appColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          for (var i = 0; i < exercise.choices.length; i++) ...[
            _ChoiceRow(
              label: exercise.choices[i].label,
              selected: _selected == i,
              correct: _submitted && exercise.choices[i].isCorrect,
              incorrect:
                  _submitted &&
                  _selected == i &&
                  !exercise.choices[i].isCorrect,
              onTap: () => _select(i),
            ),
            if (i < exercise.choices.length - 1)
              const SizedBox(height: AppSpacing.xs),
          ],
          const SizedBox(height: AppSpacing.lg),
          if (!widget.selfEvaluate)
            AppButton(
              label: _submitted && !_correct
                  ? 'Periksa Lagi'
                  : 'Periksa Jawaban',
              isFullWidth: true,
              onPressed: _selected == null ? null : _submit,
            ),
          if (_showHint && !_correct && exercise.hint != null) ...[
            const SizedBox(height: AppSpacing.sm),
            ExerciseHintView(hint: exercise.hint!),
          ],
          if (_submitted) ...[
            const SizedBox(height: AppSpacing.sm),
            ExerciseFeedbackPanel(
              isCorrect: _correct,
              message: _correct
                  ? 'Benar. Perbaikan ini membuat kode berjalan sesuai tujuan.'
                  : 'Belum tepat. Cari bagian yang membuat kode tidak lengkap.',
              explanation: _correct ? exercise.explanation : null,
              hint: exercise.hint,
              onShowHint: () => setState(() => _showHint = true),
            ),
          ],
          if (_submitted && _correct && exercise.correctedCode != null) ...[
            const SizedBox(height: AppSpacing.sm),
            _CodeSurface(code: exercise.correctedCode!, success: true),
          ],
        ],
      ),
    );
  }
}

class _CodeSurface extends StatelessWidget {
  const _CodeSurface({required this.code, this.success = false});

  final String code;
  final bool success;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final codeBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final codeTextColor = isDark
        ? const Color(0xFFF8FAFC)
        : const Color(0xFF0F172A);
    final codeBorderColor = isDark
        ? const Color(0xFF1E293B)
        : const Color(0xFFE2E8F0);

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: success ? ext.successContainer.withValues(alpha: 0.25) : codeBg,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(
          color: success ? ext.success.withValues(alpha: 0.5) : codeBorderColor,
          width: success ? 1.5 : 1.0,
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Text(
          code,
          style: AppTypeScale.code.copyWith(
            color: success ? ext.onSuccessContainer : codeTextColor,
          ),
        ),
      ),
    );
  }
}

class _ChoiceRow extends StatelessWidget {
  const _ChoiceRow({
    required this.label,
    required this.selected,
    required this.correct,
    required this.incorrect,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool correct;
  final bool incorrect;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final scheme = Theme.of(context).colorScheme;
    final bg = correct
        ? ext.successContainer
        : incorrect
        ? scheme.errorContainer
        : selected
        ? scheme.primaryContainer
        : ext.card;
    final border = correct
        ? ext.success
        : incorrect
        ? scheme.error
        : selected
        ? scheme.primary
        : ext.border;
    final fg = correct
        ? ext.onSuccessContainer
        : incorrect
        ? scheme.onErrorContainer
        : selected
        ? scheme.onPrimaryContainer
        : ext.textPrimary;
    final icon = correct
        ? Icons.check_circle_rounded
        : incorrect
        ? Icons.error_rounded
        : selected
        ? Icons.radio_button_checked_rounded
        : Icons.radio_button_unchecked_rounded;

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          child: AnimatedContainer(
            duration: AppDurations.fast,
            constraints: const BoxConstraints(minHeight: 48),
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(AppRadius.medium),
              border: Border.all(
                color: border,
                width: selected || correct || incorrect ? 1.4 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(icon, size: AppIconSizes.md, color: fg),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    label,
                    style: AppTypeScale.code.copyWith(
                      color: fg,
                      fontWeight: selected || correct
                          ? FontWeight.w700
                          : FontWeight.w400,
                    ),
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
