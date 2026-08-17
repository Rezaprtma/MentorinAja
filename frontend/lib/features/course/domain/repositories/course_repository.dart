import '../entities/course_detail.dart';

/// Data source seam for course detail records.
///
/// Screens depend on this interface instead of the mock catalog so a real
/// backend repository can replace it later without touching presentation.
abstract class CourseRepository {
  /// Resolves a course by its stable [id]; null when unknown.
  CourseDetail? findById(String id);

  /// Resolves a course by title lookup (used by legacy entry points).
  CourseDetail? findByTitle(String title);

  /// All courses belonging to a learning [category].
  List<CourseDetail> coursesInCategory(String category);

  /// Every course in the catalog (used by surfaces that enumerate progress).
  List<CourseDetail> all();
}
