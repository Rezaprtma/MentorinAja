/// A selectable answer choice inside a game draft.
library;

class GameChoiceDraft {
  const GameChoiceDraft({required this.label, required this.isCorrect});

  final String label;
  final bool isCorrect;

  GameChoiceDraft copyWith({String? label, bool? isCorrect}) {
    return GameChoiceDraft(
      label: label ?? this.label,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }
}
