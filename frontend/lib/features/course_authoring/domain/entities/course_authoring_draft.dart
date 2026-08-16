/// Full course draft used by the authoring experience.
library;

import 'draft_status.dart';
import 'lesson_draft.dart';

class CourseAuthoringDraft {
  const CourseAuthoringDraft({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.language,
    required this.level,
    this.estimatedMinutes,
    this.thumbnailPath,
    this.objectives = const [],
    required this.targetAudience,
    this.status = DraftStatus.draft,
    required this.updatedAt,
    this.lessons = const [],
  });

  final String id;
  final String title;
  final String description;
  final String category;
  final String language;
  final String level;
  final int? estimatedMinutes;
  final String? thumbnailPath;
  final List<String> objectives;
  final String targetAudience;
  final DraftStatus status;
  final DateTime updatedAt;
  final List<LessonDraft> lessons;

  CourseAuthoringDraft copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? language,
    String? level,
    int? estimatedMinutes,
    String? thumbnailPath,
    List<String>? objectives,
    String? targetAudience,
    DraftStatus? status,
    DateTime? updatedAt,
    List<LessonDraft>? lessons,
  }) {
    return CourseAuthoringDraft(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      language: language ?? this.language,
      level: level ?? this.level,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      objectives: objectives ?? this.objectives,
      targetAudience: targetAudience ?? this.targetAudience,
      status: status ?? this.status,
      updatedAt: updatedAt ?? this.updatedAt,
      lessons: lessons ?? this.lessons,
    );
  }
}
