//**
// frontend/features/lesson/presentation/widgets/games/output_prediction_game.dart
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

class OutputPredictionGame extends StatefulWidget {
  const OutputPredictionGame({
    super.key,
    required this.exercise,
    this.selfEvaluate = false,
    this.gameCounter,
  });

  final LessonExercise exercise;
  final bool selfEvaluate;
  final String? gameCounter;

  @override
  State<OutputPredictionGame> createState() => _OutputPredictionGameState();
}

class _OutputPredictionGameState extends State<OutputPredictionGame> {
  int? _selectedIndex;
  bool _submitted = false;
  bool _correct = false;
  bool _showHint = false;

  late final List<ExerciseChoice> _choices;

  @override
  void initState() {
    super.initState();

    final exercise = widget.exercise;
    if (exercise.choices.isNotEmpty) {
      _choices = exercise.choices;
    } else {
      final expected = exercise.expectedAnswer ?? '';
      final options = exercise.options;
      _choices = [
        ExerciseChoice(label: expected, isCorrect: true),
        ...options
            .where((opt) => opt != expected)
            .map((opt) => ExerciseChoice(label: opt, isCorrect: false)),
      ]..shuffle();
    }
  }

  void _select(int index) {
    if (_submitted && _correct) return;
    setState(() {
      _selectedIndex = index;
      if (widget.selfEvaluate) {
        _submitted = true;
        _correct = _choices[index].isCorrect;
      }
    });
  }

  void _submit() {
    if (_selectedIndex == null) return;
    setState(() {
      _submitted = true;
      _correct = _choices[_selectedIndex!].isCorrect;
    });
  }

  void _retry() {
    setState(() {
      _selectedIndex = null;
      _submitted = false;
      _correct = false;
      _showHint = false;
    });
  }

  void _revealHint() => setState(() => _showHint = true);

  @override
  Widget build(BuildContext context) {
    final exercise = widget.exercise;
    final ext = context.appColors;
    final scheme = Theme.of(context).colorScheme;

    return ExerciseCard(
      exercise: exercise,
      isGame: true,
      gameCounter: widget.gameCounter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (exercise.code != null && exercise.code!.isNotEmpty) ...[
            _CodeSurface(code: exercise.code!),
            const SizedBox(height: AppSpacing.md),
          ],
          Text(
            'Apa output dari program di atas?',
            style: AppTypeScale.labelMedium.copyWith(
              color: ext.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          ...List.generate(_choices.length, (index) {
            final choice = _choices[index];
            final isSelected = _selectedIndex == index;
            final isCorrect = choice.isCorrect;

            Color borderColor = ext.border;
            Color bgColor = ext.card;
            Color textColor = ext.textPrimary;
            IconData? trailingIcon;

            if (_submitted && isSelected) {
              if (isCorrect) {
                borderColor = ext.success;
                bgColor = ext.successContainer;
                textColor = ext.onSuccessContainer;
                trailingIcon = Icons.check_circle_rounded;
              } else {
                borderColor = scheme.error;
                bgColor = scheme.errorContainer;
                textColor = scheme.onErrorContainer;
                trailingIcon = Icons.cancel_rounded;
              }
            } else if (_submitted && isCorrect) {
              borderColor = ext.success;
              bgColor = ext.successContainer.withValues(alpha: 0.4);
              textColor = ext.onSuccessContainer;
              trailingIcon = Icons.check_circle_outline_rounded;
            } else if (isSelected) {
              borderColor = scheme.primary;
              bgColor = scheme.primaryContainer;
              textColor = scheme.onPrimaryContainer;
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Semantics(
                button: true,
                selected: isSelected,
                label: 'Output: ${choice.label}',
                child: InkWell(
                  onTap: _submitted && _correct ? null : () => _select(index),
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                  child: AnimatedContainer(
                    duration: AppDurations.fast,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                      border: Border.all(color: borderColor, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            choice.label,
                            style: AppTypeScale.code.copyWith(
                              color: textColor,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                        if (trailingIcon != null) ...[
                          const SizedBox(width: AppSpacing.xs),
                          Icon(
                            trailingIcon,
                            color: textColor,
                            size: AppIconSizes.md,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: AppSpacing.xs),
          if (!widget.selfEvaluate && !_submitted)
            AppButton(
              label: 'Periksa Jawaban',
              isFullWidth: true,
              onPressed: _selectedIndex != null ? _submit : null,
            ),
          if (_submitted) ...[
            const SizedBox(height: AppSpacing.sm),
            ExerciseFeedbackPanel(
              isCorrect: _correct,
              message: _correct
                  ? 'Tepat sekali! Output program tersebut benar.'
                  : 'Jawaban salah. Perhatikan baik-baik jalannya program.',
              explanation: _correct ? exercise.explanation : null,
              hint: exercise.hint,
              onShowHint: _showHint ? null : _revealHint,
            ),
            if (!_correct && _showHint && exercise.hint != null) ...[
              const SizedBox(height: AppSpacing.sm),
              ExerciseHintView(hint: exercise.hint!),
            ],
            if (!_correct) ...[
              const SizedBox(height: AppSpacing.sm),
              AppButton(
                label: 'Coba Lagi',
                variant: AppButtonVariant.outlined,
                isFullWidth: true,
                onPressed: _retry,
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _CodeSurface extends StatelessWidget {
  const _CodeSurface({required this.code});

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
      decoration: BoxDecoration(
        color: codeBg,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: codeBorderColor),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(
          code,
          style: AppTypeScale.code.copyWith(color: codeTextColor),
        ),
      ),
    );
  }
}
