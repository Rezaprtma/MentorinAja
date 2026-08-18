//**
// frontend/features/course/domain/repositories/course_repository.dart
//
// frontend:
// Repository interface. Mendefinisikan kontrak data untuk feature.
//
// backend:
// Future: akan diimplementasikan dengan real backend calls.
//
// api:
// Future: akan menjadi integration point untuk backend APIs.
//
// qa:
// QA perlu memvalidasi data flow dan error handling.
//**
import '../entities/course_detail.dart';

abstract class CourseRepository {
  CourseDetail? findById(String id);

  CourseDetail? findByTitle(String title);

  List<CourseDetail> coursesInCategory(String category);

  List<CourseDetail> all();
}
