/// An interactive game attached to a lesson draft.
library;

import 'package:frontend/shared/enums/enums.dart';

import 'blank_draft.dart';
import 'game_choice_draft.dart';

class GameDraft {
  const GameDraft({
    required this.id,
    required this.gameType,
    this.instruction,
    this.code,
    this.options = const [],
    this.correctOrder,
    this.blanks = const [],
    this.choices = const [],
    this.expectedAnswer,
    this.hint,
    this.explanation,
    this.order = 0,
  });

  final String id;
  final GameType gameType;
  final String? instruction;
  final String? code;
  final List<String> options;
  final List<int>? correctOrder;
  final List<BlankDraft> blanks;
  final List<GameChoiceDraft> choices;
  final String? expectedAnswer;
  final String? hint;
  final String? explanation;
  final int order;

  GameDraft copyWith({
    String? id,
    GameType? gameType,
    String? instruction,
    String? code,
    List<String>? options,
    List<int>? correctOrder,
    List<BlankDraft>? blanks,
    List<GameChoiceDraft>? choices,
    String? expectedAnswer,
    String? hint,
    String? explanation,
    int? order,
  }) {
    return GameDraft(
      id: id ?? this.id,
      gameType: gameType ?? this.gameType,
      instruction: instruction ?? this.instruction,
      code: code ?? this.code,
      options: options ?? this.options,
      correctOrder: correctOrder ?? this.correctOrder,
      blanks: blanks ?? this.blanks,
      choices: choices ?? this.choices,
      expectedAnswer: expectedAnswer ?? this.expectedAnswer,
      hint: hint ?? this.hint,
      explanation: explanation ?? this.explanation,
      order: order ?? this.order,
    );
  }
}
