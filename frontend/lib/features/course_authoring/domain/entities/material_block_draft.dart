/// A single material block inside a lesson draft.
library;

import 'package:frontend/features/lesson/domain/entities/lesson_content.dart';

class MaterialBlockDraft {
  const MaterialBlockDraft({
    required this.id,
    required this.type,
    this.text,
    this.label,
    this.items = const [],
    this.order = 0,
  });

  final String id;
  final LessonContentBlockType type;
  final String? text;
  final String? label;
  final List<String> items;
  final int order;

  MaterialBlockDraft copyWith({
    String? id,
    LessonContentBlockType? type,
    String? text,
    String? label,
    List<String>? items,
    int? order,
  }) {
    return MaterialBlockDraft(
      id: id ?? this.id,
      type: type ?? this.type,
      text: text ?? this.text,
      label: label ?? this.label,
      items: items ?? this.items,
      order: order ?? this.order,
    );
  }
}
