//**
// frontend/features/course/data/mock_course_repository.dart
//
// frontend:
// Mock data. Menyediakan sample data untuk development dan testing.
//
// backend:
// File ini tidak memiliki dependency langsung terhadap backend karena hanya menyediakan mock data.
//
// api:
// File ini tidak mendefinisikan atau memanggil API secara langsung. Integration terjadi melalui repositories.
//
// qa:
// QA perlu memvalidasi mock data coverage dan edge cases.
//**
import '../domain/entities/course_detail.dart';
import '../domain/repositories/course_repository.dart';
import 'mock_course_catalog.dart';

class MockCourseRepository implements CourseRepository {
  @override
  CourseDetail? findById(String id) {
    for (final course in MockCourseCatalog.courses) {
      if (course.id == id) return course;
    }
    return null;
  }

  @override
  CourseDetail? findByTitle(String title) {
    for (final course in MockCourseCatalog.courses) {
      if (course.title == title) return course;
    }
    return null;
  }

  @override
  List<CourseDetail> coursesInCategory(String category) {
    return MockCourseCatalog.courses
        .where((course) => course.category == category)
        .toList();
  }

  @override
  List<CourseDetail> all() => MockCourseCatalog.courses;
}
