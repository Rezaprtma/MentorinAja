/// Editable list of exercises attached to an authored lesson.
///
/// Each exercise card lets the mentor pick a [LessonExerciseType] and edit the
/// prompt plus type-specific payload: token options for code completion, the
/// corrected code for code correction, and answer choices for explanation
/// exercises. Adding an exercise appends a code completion default. The widget
/// is fully controlled — [exercises] and [onChanged] drive the state.
library;

import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';
import 'package:frontend/shared/enums/enums.dart';

import '../../domain/entities/blank_draft.dart';
import '../../domain/entities/exercise_draft.dart';
import 'choice_list_editor.dart';

class ExerciseEditor extends StatelessWidget {
  const ExerciseEditor({
    super.key,
    required this.exercises,
    required this.onChanged,
  });

  final List<ExerciseDraft> exercises;
  final ValueChanged<List<ExerciseDraft>> onChanged;

  void _update(int index, ExerciseDraft exercise) {
    final updated = [...exercises];
    updated[index] = exercise;
    onChanged(updated);
  }

  void _remove(int index) {
    final updated = [...exercises]..removeAt(index);
    onChanged(updated);
  }

  void _add() {
    onChanged([
      ...exercises,
      ExerciseDraft(
        id: 'ex-${DateTime.now().millisecondsSinceEpoch}',
        type: LessonExerciseType.codeCompletion,
        options: const ['print'],
        order: exercises.length,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < exercises.length; i++) ...[
          _ExerciseCard(
            key: ValueKey(exercises[i].id),
            exercise: exercises[i],
            onChanged: (exercise) => _update(i, exercise),
            onRemove: () => _remove(i),
          ),
          if (i < exercises.length - 1) const SizedBox(height: AppSpacing.sm),
        ],
        const SizedBox(height: AppSpacing.sm),
        AppButton(
          label: 'Tambah Latihan',
          leadingIcon: Icons.add,
          variant: AppButtonVariant.outlined,
          size: AppButtonSize.small,
          onPressed: _add,
        ),
      ],
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  const _ExerciseCard({
    super.key,
    required this.exercise,
    required this.onChanged,
    required this.onRemove,
  });

  final ExerciseDraft exercise;
  final ValueChanged<ExerciseDraft> onChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return AppBaseCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AppDropdownField<LessonExerciseType>(
                  initialValue: exercise.type,
                  label: 'Jenis Latihan',
                  items: LessonExerciseType.values
                      .map(
                        (type) => DropdownMenuItem(
                          value: type,
                          child: Text(_exerciseTypeLabel(type)),
                        ),
                      )
                      .toList(),
                  onChanged: (type) {
                    if (type == null) return;
                    onChanged(exercise.copyWith(type: type));
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              IconButton(
                icon: Icon(
                  Icons.close_rounded,
                  size: AppIconSizes.sm,
                  color: Theme.of(context).colorScheme.error,
                ),
                onPressed: onRemove,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          AppTextField(
            initialValue: exercise.title ?? '',
            label: 'Judul',
            onChanged: (value) => onChanged(exercise.copyWith(title: value)),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppTextField(
            initialValue: exercise.instruction ?? '',
            label: 'Instruksi',
            maxLines: 3,
            minLines: 1,
            onChanged: (value) =>
                onChanged(exercise.copyWith(instruction: value)),
          ),
          if (exercise.type != LessonExerciseType.codeWriting) ...[
            const SizedBox(height: AppSpacing.sm),
            AppTextField(
              initialValue: exercise.code ?? '',
              label: 'Kode Awal',
              maxLines: 5,
              minLines: 2,
              onChanged: (value) => onChanged(exercise.copyWith(code: value)),
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          _renderTypeSpecific(),
        ],
      ),
    );
  }

  Widget _renderTypeSpecific() {
    switch (exercise.type) {
      case LessonExerciseType.codeCompletion:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              initialValue: exercise.options.join('\n'),
              label: 'Token Pilihan (satu per baris)',
              maxLines: 4,
              minLines: 1,
              onChanged: (value) =>
                  onChanged(exercise.copyWith(options: _lines(value))),
            ),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(
              initialValue: exercise.blanks.map((b) => b.token).join(', '),
              label: 'Jawaban Benar (token, pisah koma)',
              hint: 'Contoh: print',
              onChanged: (value) => onChanged(
                exercise.copyWith(
                  blanks: _tokens(
                    value,
                  ).map((token) => BlankDraft(token: token)).toList(),
                ),
              ),
            ),
          ],
        );
      case LessonExerciseType.codeCorrection:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              initialValue: exercise.correctedCode ?? '',
              label: 'Kode yang Benar',
              maxLines: 5,
              minLines: 2,
              onChanged: (value) =>
                  onChanged(exercise.copyWith(correctedCode: value)),
            ),
            const SizedBox(height: AppSpacing.sm),
            ChoiceListEditor(
              choices: exercise.choices,
              onChanged: (choices) =>
                  onChanged(exercise.copyWith(choices: choices)),
              addLabel: 'Tambah Pilihan',
            ),
          ],
        );
      case LessonExerciseType.codeExplanation:
        return ChoiceListEditor(
          choices: exercise.choices,
          onChanged: (choices) =>
              onChanged(exercise.copyWith(choices: choices)),
          addLabel: 'Tambah Pilihan',
        );
      case LessonExerciseType.codeWriting:
        return AppTextField(
          initialValue: exercise.correctedCode ?? '',
          label: 'Kode Contoh Jawaban',
          maxLines: 5,
          minLines: 2,
          onChanged: (value) =>
              onChanged(exercise.copyWith(correctedCode: value)),
        );
    }
  }
}

/// Splits newline-separated input into trimmed non-empty values.
List<String> _lines(String value) {
  return value
      .split('\n')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();
}

/// Parses a comma-separated list of answer tokens.
List<String> _tokens(String value) {
  return value
      .split(',')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();
}

/// Human-readable Bahasa Indonesia label for an exercise type.
String _exerciseTypeLabel(LessonExerciseType type) {
  return switch (type) {
    LessonExerciseType.codeCompletion => 'Lengkapi Kode',
    LessonExerciseType.codeCorrection => 'Perbaiki Kode',
    LessonExerciseType.codeExplanation => 'Jelaskan Kode',
    LessonExerciseType.codeWriting => 'Menulis Kode',
  };
}
