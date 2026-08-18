//**
// frontend/features/lesson/presentation/widgets/games/code_ordering_game.dart
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

class CodeOrderingGame extends StatefulWidget {
  const CodeOrderingGame({
    super.key,
    required this.exercise,
    this.selfEvaluate = false,
    this.gameCounter,
  });

  final LessonExercise exercise;
  final bool selfEvaluate;
  final String? gameCounter;

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
    if (_selectedIndices.length != correctOrder.length) return false;
    for (int i = 0; i < correctOrder.length; i++) {
      if (_selectedIndices[i] != correctOrder[i]) return false;
    }
    return true;
  }

  void _addToken(int index) {
    if (_submitted && _correct) return;
    if (_selectedIndices.contains(index)) return;
    setState(() {
      _selectedIndices.add(index);
      if (widget.selfEvaluate) {
        _submitted = _complete;
        _correct = _complete && _orderIsCorrect;
      }
    });
  }

  void _removeTokenAt(int positionIndex) {
    if (_submitted && _correct) return;
    setState(() {
      _selectedIndices.removeAt(positionIndex);
      _submitted = false;
      _correct = false;
      _showHint = false;
    });
  }

  void _reset() {
    if (_submitted && _correct) return;
    setState(() {
      _selectedIndices.clear();
      _submitted = false;
      _correct = false;
      _showHint = false;
    });
  }

  void _submit() {
    setState(() {
      _submitted = true;
      _correct = _orderIsCorrect;
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
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppRadius.large),
              border: Border.all(
                color: _submitted
                    ? (_correct ? ext.success : scheme.error)
                    : scheme.primary.withValues(alpha: 0.5),
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'URUTAN KODE KAMU:',
                        style: AppTypeScale.labelSmall.copyWith(
                          color: ext.textSecondary,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                    if (_selectedIndices.isNotEmpty &&
                        !(_submitted && _correct))
                      InkWell(
                        onTap: _reset,
                        child: Text(
                          'Reset',
                          style: AppTypeScale.labelSmall.copyWith(
                            color: scheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                if (_selectedIndices.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.sm,
                    ),
                    child: Text(
                      'Ketuk potongan kode di bawah untuk menyusun...',
                      style: AppTypeScale.bodySmall.copyWith(
                        color: ext.textDisabled,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  )
                else
                  Wrap(
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xs,
                    children: [
                      for (int pos = 0; pos < _selectedIndices.length; pos++)
                        _TokenChip(
                          token: exercise.options[_selectedIndices[pos]],
                          isSelected: true,
                          positionBadge: '${pos + 1}',
                          onTap: () => _removeTokenAt(pos),
                          disabled: _submitted && _correct,
                        ),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          Text(
            'POTONGAN KODE (PILIH UNTUK MENYUSUN):',
            style: AppTypeScale.labelSmall.copyWith(
              color: ext.textSecondary,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              for (int i = 0; i < exercise.options.length; i++)
                if (!_selectedIndices.contains(i))
                  _TokenChip(
                    token: exercise.options[i],
                    isSelected: false,
                    onTap: () => _addToken(i),
                    disabled: _submitted && _correct,
                  ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),
          if (!widget.selfEvaluate && !_submitted)
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
                  ? 'Benar! Kodenya tersusun dengan urutan yang tepat.'
                  : 'Belum tepat. Coba ketuk token untuk mengatur ulang.',
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
                onPressed: _reset,
              ),
            ],
          ],
        ],
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
    this.positionBadge,
  });

  final String token;
  final bool isSelected;
  final VoidCallback onTap;
  final bool disabled;
  final String? positionBadge;

  @override
  Widget build(BuildContext context) {
    final ext = context.appColors;
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: disabled ? null : onTap,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: isSelected ? scheme.primaryContainer : ext.card,
            borderRadius: BorderRadius.circular(AppRadius.medium),
            border: Border.all(
              color: isSelected ? scheme.primary : ext.border,
              width: 1.4,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (positionBadge != null) ...[
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: scheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    positionBadge!,
                    style: AppTypeScale.labelSmall.copyWith(
                      color: scheme.onPrimary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.xxs),
              ],
              Flexible(
                child: Text(
                  token,
                  style: AppTypeScale.code.copyWith(
                    color: isSelected
                        ? scheme.onPrimaryContainer
                        : ext.textPrimary,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
