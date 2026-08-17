/// Editable list of games attached to an authored lesson.
///
/// Each game card lets the mentor pick a [GameType] and edit the shared prompt
/// plus type-specific payload: ordered code lines for code ordering, options
/// and answer choices for choice-based types, and a predicted output for the
/// output prediction game. Adding a game appends a code ordering default. The
/// widget is fully controlled — [games] and [onChanged] drive the state.
library;

import 'package:flutter/material.dart';

import 'package:frontend/shared/design_system/design_system.dart';
import 'package:frontend/shared/enums/enums.dart';

import '../../domain/entities/blank_draft.dart';
import '../../domain/entities/game_draft.dart';
import 'choice_list_editor.dart';

class GameEditor extends StatelessWidget {
  const GameEditor({super.key, required this.games, required this.onChanged});

  final List<GameDraft> games;
  final ValueChanged<List<GameDraft>> onChanged;

  void _update(int index, GameDraft game) {
    final updated = [...games];
    updated[index] = game;
    onChanged(updated);
  }

  void _remove(int index) {
    final updated = [...games]..removeAt(index);
    onChanged(updated);
  }

  void _add() {
    onChanged([
      ...games,
      GameDraft(
        id: 'game-${DateTime.now().millisecondsSinceEpoch}',
        gameType: GameType.codeOrdering,
        options: const ['print', '"Halo"'],
        correctOrder: const [0, 1],
        order: games.length,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < games.length; i++) ...[
          _GameCard(
            key: ValueKey(games[i].id),
            game: games[i],
            onChanged: (game) => _update(i, game),
            onRemove: () => _remove(i),
          ),
          if (i < games.length - 1) const SizedBox(height: AppSpacing.sm),
        ],
        const SizedBox(height: AppSpacing.sm),
        AppButton(
          label: 'Tambah Game',
          leadingIcon: Icons.add,
          variant: AppButtonVariant.outlined,
          size: AppButtonSize.small,
          onPressed: _add,
        ),
      ],
    );
  }
}

class _GameCard extends StatelessWidget {
  const _GameCard({
    super.key,
    required this.game,
    required this.onChanged,
    required this.onRemove,
  });

  final GameDraft game;
  final ValueChanged<GameDraft> onChanged;
  final VoidCallback onRemove;

  bool get _hasCode =>
      game.gameType == GameType.tokenCompletion ||
      game.gameType == GameType.identifyError ||
      game.gameType == GameType.outputPrediction ||
      game.gameType == GameType.codeOrdering;

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
                child: AppDropdownField<GameType>(
                  initialValue: game.gameType,
                  label: 'Jenis Game',
                  items: GameType.values
                      .map(
                        (type) => DropdownMenuItem(
                          value: type,
                          child: Text(_gameTypeLabel(type)),
                        ),
                      )
                      .toList(),
                  onChanged: (type) {
                    if (type == null) return;
                    onChanged(game.copyWith(gameType: type));
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
            initialValue: game.instruction ?? '',
            label: 'Instruksi',
            maxLines: 3,
            minLines: 1,
            onChanged: (value) => onChanged(game.copyWith(instruction: value)),
          ),
          if (_hasCode) ...[
            const SizedBox(height: AppSpacing.sm),
            AppTextField(
              initialValue: game.code ?? '',
              label: 'Kode',
              maxLines: 5,
              minLines: 2,
              onChanged: (value) => onChanged(game.copyWith(code: value)),
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          _renderTypeSpecific(),
        ],
      ),
    );
  }

  Widget _renderTypeSpecific() {
    switch (game.gameType) {
      case GameType.codeOrdering:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              initialValue: game.options.join('\n'),
              label: 'Potongan Kode (satu per baris)',
              maxLines: 5,
              minLines: 2,
              onChanged: (value) =>
                  onChanged(game.copyWith(options: _lines(value))),
            ),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(
              initialValue: game.correctOrder?.join(', ') ?? '',
              label: 'Urutan Benar (indeks, pisah koma)',
              hint: 'Contoh: 0, 1, 2, 3',
              onChanged: (value) =>
                  onChanged(game.copyWith(correctOrder: _parseIndices(value))),
            ),
          ],
        );
      case GameType.tokenCompletion:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              initialValue: game.options.join('\n'),
              label: 'Token Pilihan (satu per baris)',
              maxLines: 4,
              minLines: 1,
              onChanged: (value) =>
                  onChanged(game.copyWith(options: _lines(value))),
            ),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(
              initialValue: game.blanks.map((b) => b.token).join(', '),
              label: 'Jawaban Benar (token, pisah koma)',
              hint: 'Contoh: print',
              onChanged: (value) => onChanged(
                game.copyWith(
                  blanks: _parseTokens(
                    value,
                  ).map((token) => BlankDraft(token: token)).toList(),
                ),
              ),
            ),
          ],
        );
      case GameType.multipleChoice:
      case GameType.identifyError:
        return ChoiceListEditor(
          choices: game.choices,
          onChanged: (choices) => onChanged(game.copyWith(choices: choices)),
          addLabel: 'Tambah Pilihan',
        );
      case GameType.outputPrediction:
        return AppTextField(
          initialValue: game.expectedAnswer ?? '',
          label: 'Jawaban yang Diharapkan',
          hint: 'Contoh: 8',
          onChanged: (value) => onChanged(game.copyWith(expectedAnswer: value)),
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

/// Parses a comma-separated list of indices into an ordered integer list.
List<int>? _parseIndices(String value) {
  final parsed = value
      .split(',')
      .map((e) => int.tryParse(e.trim()))
      .whereType<int>()
      .toList();
  return parsed.isEmpty ? null : parsed;
}

/// Parses a comma-separated list of answer tokens.
List<String> _parseTokens(String value) {
  return value
      .split(',')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();
}

/// Human-readable Bahasa Indonesia label for a game type.
String _gameTypeLabel(GameType type) {
  return switch (type) {
    GameType.codeOrdering => 'Susun Kode',
    GameType.tokenCompletion => 'Lengkapi Token',
    GameType.multipleChoice => 'Pilihan Ganda',
    GameType.identifyError => 'Cari Kesalahan',
    GameType.outputPrediction => 'Tebak Output',
  };
}
