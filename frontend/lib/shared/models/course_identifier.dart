//**
// frontend/shared/models/course_identifier.dart
//
// frontend:
// Shared model. Menyediakan common data structures.
//
// backend:
// File ini tidak memiliki dependency langsung terhadap backend.
//
// api:
// File ini tidak mendefinisikan atau memanggil API secara langsung.
//
// qa:
// QA perlu memvalidasi model validation dan edge cases.
//**
library;

abstract final class CourseIdentifier {
  CourseIdentifier._();

  static String slug(String title) {
    return title
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
  }
}
