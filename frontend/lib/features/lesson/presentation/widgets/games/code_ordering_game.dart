/// Code Ordering Game — an interactive game where the learner rearranges
/// code blocks/tokens into the correct order.
library;

import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';

import '../../../domain/entities/lesson_exercise.dart';
import '../exercises/exercise_card.dart';
import '../exercises/exercise_feedback.dart';

/// Code Ordering Game for the Game stage.
///
/// The learner must arrange tokens in the correct order to form the intended
/// code snippet.
class CodeOrderingGame extends StatefulWidget {
  const CodeOrderingGame({
    super.key,
    required this.exercise,
    this.selfEvaluate = false,
  });

  final LessonExercise exercise;
  final bool selfEvaluate;

  @override
  State<CodeOrderingGame> createState() => _CodeOrderingGameState();
}

class _CodeOrderingGameState extends State<CodeOrderingGame> {
  final List<int> _selectedIndices = [];
  bool _submitted = false;
  bool _correct = false;
  bool _showHint = false;

  bool get _complete =>
      _selectedIndices.length == widget.exercise.options.length;

  bool get _orderIsCorrect {
    final correctOrder = widget.exercise.correctOrder;
    if (correctOrder == null) return false;
    for (int i = 0; i < correctOrder.length; i++) {
      if (_selectedIndices[i] != correctOrder[i]) return false;
    }
    return true;
  }

  void _toggleToken(int index) {
    if (_submitted && _correct) return;
    setState(() {
      if (_selectedIndices.contains(index)) {
        _selectedIndices.remove(index);
      } else {
        _selectedIndices.add(index);
      }
      if (widget.selfEvaluate) {
        _submitted = _complete;
        _correct = _complete && _orderIsCorrect;
      }
    });
  }

  void _submit() {
    setState(() {
      _submitted = true;
      _correct = _orderIsCorrect;
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _CodeSurface(code: exercise.code ?? ''),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Susun kode',
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
              for (int i = 0; i < exercise.options.length; i++)
                _TokenChip(
                  token: exercise.options[i],
                  isSelected: _selectedIndices.contains(i),
                  onTap: () => _toggleToken(i),
                  disabled: _submitted && _correct,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Urutan kamu:',
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
              for (final index in _selectedIndices)
                _TokenChip(
                  token: exercise.options[index],
                  isSelected: true,
                  onTap: () => _toggleToken(index),
                  disabled: _submitted && _correct,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          if (!widget.selfEvaluate)
            AppButton(
              label: 'Periksa Jawaban',
              isFullWidth: true,
              onPressed: _complete ? _submit : null,
            ),
          if (_submitted) ...[
            const SizedBox(height: AppSpacing.sm),
            ExerciseFeedbackPanel(
              isCorrect: _correct,
              message: _correct
                  ? 'Benar. Kamu menyusun kodenya dengan tepat.'
                  : 'Belum tepat. Coba susun kembali kode tersebut.',
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
}

class _CodeSurface extends StatelessWidget {
  const _CodeSurface({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: ext.border),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Text(
        code,
        style: AppTypeScale.code.copyWith(color: ext.textPrimary),
      ),
    );
  }
}

class _TokenChip extends StatelessWidget {
  const _TokenChip({
    required this.token,
    required this.isSelected,
    required this.onTap,
    required this.disabled,
  });

  final String token;
  final bool isSelected;
  final VoidCallback onTap;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final scheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: disabled ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: isSelected ? scheme.primaryContainer : ext.card,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(
            color: isSelected ? scheme.primary : ext.border,
            width: 1.4,
          ),
        ),
        child: Text(
          token,
          style: AppTypeScale.code.copyWith(
            color: isSelected ? scheme.onPrimaryContainer : ext.textPrimary,
          ),
        ),
      ),
    );
  }
}
