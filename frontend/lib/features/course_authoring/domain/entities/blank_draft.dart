/// A fill-in-the-blank slot inside a game draft.
library;

class BlankDraft {
  const BlankDraft({required this.token, this.accept = const []});

  final String token;
  final List<String> accept;

  BlankDraft copyWith({String? token, List<String>? accept}) {
    return BlankDraft(
      token: token ?? this.token,
      accept: accept ?? this.accept,
    );
  }
}
