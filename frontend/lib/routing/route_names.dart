/// Centralized route path constants for MentorinAja.
///
/// Every navigable destination has a named constant here. Screens never
/// hardcode route strings — they reference these constants so renames are
/// a single-file change and broken routes are caught at compile time.
///
/// Paths follow a `/feature/screen` convention. Parameterized routes use
/// a `{param}` placeholder (e.g. `/course/{courseId}`).
abstract final class AppRoutes {
  AppRoutes._();

  // -------------------------------------------------------------------------
  // Root
  // -------------------------------------------------------------------------

  static const String splash = '/splash';
  static const String onboarding = '/onboarding';

  // -------------------------------------------------------------------------
  // Auth
  // -------------------------------------------------------------------------

  static const String authentication = '/authentication';
  static const String createAccount = '/create-account';
  static const String signIn = '/sign-in';
  static const String otpVerification = '/verification';

  // -------------------------------------------------------------------------
  // Main shell (bottom navigation)
  // -------------------------------------------------------------------------

  static const String home = '/home';
  static const String explore = '/explore';
  static const String courses = '/courses';
  static const String progress = '/progress';
  static const String profile = '/profile';

  // -------------------------------------------------------------------------
  // Course
  // -------------------------------------------------------------------------

  static const String courseDetail = '/course/{courseId}';
  static const String lessonDetail = '/course/{courseId}/lesson/{lessonId}';
  static const String courseCompleted = '/course/{courseId}/completed';
  static const String quiz = '/course/{courseId}/quiz/{quizId}';

  // -------------------------------------------------------------------------
  // Feature screens
  // -------------------------------------------------------------------------

  static const String notifications = '/notifications';
  static const String categoryDetail = '/category/{category}';
  static const String feedback = '/support/feedback';
  static const String helpCenter = '/support/help';
  static const String about = '/support/about';
  static const String privacyPolicy = '/legal/privacy';
  static const String userPolicy = '/legal/terms';
  static const String editProfile = '/profile/edit';
  static const String settings = '/settings';
  static const String practice = '/practice';
  static const String tutor = '/tutor';
  static const String conversation = '/conversation';
  static const String camera = '/camera';
  static const String voice = '/voice';

  // -------------------------------------------------------------------------
  // Mentor course authoring
  // -------------------------------------------------------------------------

  static const String mentorCourses = '/mentor/courses';
  static const String mentorCourseCreate = '/mentor/courses/create';
  static const String mentorCourseEditor = '/mentor/courses/{courseId}';
  static const String mentorLessonEditor =
      '/mentor/courses/{courseId}/lessons/{lessonId}';

  // -------------------------------------------------------------------------
  // Helpers
  // -------------------------------------------------------------------------

  /// Replaces `{param}` placeholders with actual values.
  ///
  /// ```dart
  /// AppRoutes.resolve(AppRoutes.courseDetail, {'courseId': '42'})
  /// // → '/course/42'
  /// ```
  static String resolve(String path, [Map<String, String> params = const {}]) {
    var resolved = path;
    for (final entry in params.entries) {
      resolved = resolved.replaceAll('{${entry.key}}', entry.value);
    }
    return resolved;
  }
}
