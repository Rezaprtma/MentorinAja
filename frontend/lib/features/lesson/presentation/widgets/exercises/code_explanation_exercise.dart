//**
// frontend/features/lesson/presentation/widgets/exercises/code_explanation_exercise.dart
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

class CodeExplanationExercise extends StatefulWidget {
  const CodeExplanationExercise({
    super.key,
    required this.exercise,
    this.selfEvaluate = false,
  });

  final LessonExercise exercise;
  final bool selfEvaluate;

  @override
  State<CodeExplanationExercise> createState() =>
      _CodeExplanationExerciseState();
}

class _CodeExplanationExerciseState extends State<CodeExplanationExercise> {
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
          _CodeSnippet(code: exercise.code ?? ''),
          const SizedBox(height: AppSpacing.md),
          for (var i = 0; i < exercise.choices.length; i++) ...[
            _AnswerRow(
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
                  ? 'Tepat. Kamu menangkap maksud kode ini.'
                  : 'Belum tepat. Coba hubungkan baris kode dengan hasilnya.',
              explanation: _correct ? exercise.explanation : null,
              hint: exercise.hint,
              onShowHint: () => setState(() => _showHint = true),
            ),
          ],
        ],
      ),
    );
  }
}

class _CodeSnippet extends StatelessWidget {
  const _CodeSnippet({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
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
        color: codeBg,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: codeBorderColor),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Text(
          code,
          style: AppTypeScale.code.copyWith(color: codeTextColor),
        ),
      ),
    );
  }
}

class _AnswerRow extends StatelessWidget {
  const _AnswerRow({
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
                    style: AppTypeScale.bodyMedium.copyWith(
                      color: fg,
                      fontWeight: selected || correct
                          ? FontWeight.w700
                          : FontWeight.w500,
                      height: 1.45,
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
