import '../domain/entities/course_detail.dart';
import '../domain/repositories/course_repository.dart';
import 'mock_course_catalog.dart';

/// In-memory [CourseRepository] backed by [MockCourseCatalog].
///
/// Replaced by a backend repository in a later phase without touching screens.
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
