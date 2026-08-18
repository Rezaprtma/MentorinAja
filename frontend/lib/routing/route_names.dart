//**
// frontend/routing/route_names.dart
//
// frontend:
// Routing. Menyediakan route definitions dan navigation logic.
//
// backend:
// File ini tidak memiliki dependency langsung terhadap backend.
//
// api:
// File ini tidak mendefinisikan atau memanggil API secara langsung.
//
// qa:
// QA perlu memvalidasi routing behavior dan deep linking.
//**
abstract final class AppRoutes {
  AppRoutes._();

  static const String splash = '/splash';
  static const String onboarding = '/onboarding';

  static const String authentication = '/authentication';
  static const String createAccount = '/create-account';
  static const String signIn = '/sign-in';
  static const String otpVerification = '/verification';

  static const String home = '/home';
  static const String explore = '/explore';
  static const String courses = '/courses';
  static const String progress = '/progress';
  static const String profile = '/profile';

  static const String courseDetail = '/course/{courseId}';
  static const String lessonDetail = '/course/{courseId}/lesson/{lessonId}';
  static const String courseCompleted = '/course/{courseId}/completed';
  static const String quiz = '/course/{courseId}/quiz/{quizId}';

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

  static const String mentorCourses = '/mentor/courses';
  static const String mentorCourseCreate = '/mentor/courses/create';
  static const String mentorCourseEditor = '/mentor/courses/{courseId}';
  static const String mentorLessonEditor =
      '/mentor/courses/{courseId}/lessons/{lessonId}';
  static const String mentorCoursePreview =
      '/mentor/courses/{courseId}/preview';
  static const String mentorLessonPreview =
      '/mentor/courses/{courseId}/preview/{lessonId}';

  static String resolve(String path, [Map<String, String> params = const {}]) {
    var resolved = path;
    for (final entry in params.entries) {
      resolved = resolved.replaceAll('{${entry.key}}', entry.value);
    }
    return resolved;
  }
}
