/// Editable list of answer choices for authored games and exercises.
///
/// Renders one row per choice: a text field for the label and a checkbox to
/// mark the correct answer, with a remove action. Adding a choice appends a
/// new blank row. The widget is fully controlled — [choices] and [onChanged]
/// drive the state so the parent persists every edit.
library;

import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';

import '../../domain/entities/game_choice_draft.dart';

class ChoiceListEditor extends StatelessWidget {
  const ChoiceListEditor({
    super.key,
    required this.choices,
    required this.onChanged,
    this.addLabel = 'Tambah Pilihan',
  });

  final List<GameChoiceDraft> choices;
  final ValueChanged<List<GameChoiceDraft>> onChanged;
  final String addLabel;

  void _update(int index, GameChoiceDraft choice) {
    final updated = [...choices];
    updated[index] = choice;
    onChanged(updated);
  }

  void _remove(int index) {
    final updated = [...choices]..removeAt(index);
    onChanged(updated);
  }

  void _add() {
    onChanged([
      ...choices,
      const GameChoiceDraft(label: 'Pilihan baru', isCorrect: false),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < choices.length; i++) ...[
          _ChoiceRow(
            choice: choices[i],
            onChanged: (choice) => _update(i, choice),
            onRemove: () => _remove(i),
          ),
          if (i < choices.length - 1) const SizedBox(height: AppSpacing.xs),
        ],
        const SizedBox(height: AppSpacing.xs),
        AppButton(
          label: addLabel,
          leadingIcon: Icons.add,
          variant: AppButtonVariant.outlined,
          size: AppButtonSize.small,
          onPressed: _add,
        ),
      ],
    );
  }
}

class _ChoiceRow extends StatelessWidget {
  const _ChoiceRow({
    required this.choice,
    required this.onChanged,
    required this.onRemove,
  });

  final GameChoiceDraft choice;
  final ValueChanged<GameChoiceDraft> onChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return AppBaseCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      elevation: 0,
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.outlineVariant,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            initialValue: choice.label,
            label: 'Label pilihan',
            onChanged: (value) => onChanged(choice.copyWith(label: value)),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Row(
            children: [
              Expanded(
                child: AppCheckbox(
                  value: choice.isCorrect,
                  label: 'Jadikan jawaban benar',
                  onChanged: (value) =>
                      onChanged(choice.copyWith(isCorrect: value ?? false)),
                ),
              ),
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
        ],
      ),
    );
  }
}
