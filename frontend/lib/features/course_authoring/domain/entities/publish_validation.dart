//**
// frontend/features/course_authoring/domain/entities/publish_validation.dart
//
// frontend:
// Entity/model. Mendefinisikan data structures untuk feature.
//
// backend:
// Future: akan sesuai dengan backend data models.
//
// api:
// Future: akan menjadi frontend expected contract untuk APIs.
//
// qa:
// QA perlu memvalidasi data validation dan edge cases.
//**
library;

import 'course_authoring_draft.dart';
import 'lesson_draft.dart';

class PublishValidationItem {
  const PublishValidationItem({required this.label, required this.isValid});

  final String label;
  final bool isValid;
}

class PublishValidation {
  const PublishValidation({required this.items});

  final List<PublishValidationItem> items;

  bool get isValid => items.every((item) => item.isValid);
}

abstract final class PublishValidator {
  static PublishValidation validate(CourseAuthoringDraft draft) {
    final lessons = _ordered(draft.lessons);
    final items = <PublishValidationItem>[
      PublishValidationItem(
        label: 'Judul course terisi',
        isValid: draft.title.trim().isNotEmpty,
      ),
      PublishValidationItem(
        label: 'Deskripsi course terisi',
        isValid: draft.description.trim().isNotEmpty,
      ),
      PublishValidationItem(
        label: 'Tujuan pembelajaran tidak kosong',
        isValid: draft.objectives.isNotEmpty,
      ),
      PublishValidationItem(
        label: 'Minimal satu modul pelajaran',
        isValid: lessons.isNotEmpty,
      ),
    ];

    for (var i = 0; i < lessons.length; i++) {
      final lesson = lessons[i];
      final number = i + 1;
      items.addAll([
        PublishValidationItem(
          label: 'Modul $number memiliki judul',
          isValid: lesson.title.trim().isNotEmpty,
        ),
        PublishValidationItem(
          label: 'Modul $number memiliki dokumen materi PDF',
          isValid:
              lesson.materialPdfPath != null &&
              lesson.materialPdfPath!.trim().isNotEmpty,
        ),
      ]);
    }

    return PublishValidation(items: items);
  }

  static List<LessonDraft> _ordered(List<LessonDraft> lessons) {
    return [...lessons]..sort((a, b) => a.order.compareTo(b.order));
  }
}
