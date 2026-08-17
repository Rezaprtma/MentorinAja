/// Shared helper for referencing courses across the app.
///
/// Every course is identified by a stable slug derived from its title so all
/// entry points (Home, Explore, Progress, Category, Notifications) resolve to
/// the same CourseDetailPage for the same course. Mock models expose this slug
/// through a `courseId` getter; a future repository replaces it with a server
/// id without changing screens.
library;

abstract final class CourseIdentifier {
  CourseIdentifier._();

  /// Lowercase, hyphen-separated slug for a course title.
  ///
  /// ```dart
  /// CourseIdentifier.slug('HTML & CSS Modern') // → 'html-css-modern'
  /// ```
  static String slug(String title) {
    return title
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
  }
}
