//**
// frontend/app/app.dart
//
// frontend:
// Root MaterialApp widget. Configures theme, routing, error handling, dan initial route.
//
// backend:
// File ini tidak memiliki dependency langsung terhadap backend karena hanya bertanggung jawab terhadap konfigurasi Flutter app.
//
// api:
// File ini tidak mendefinisikan atau memanggil API secara langsung. Integration terjadi melalui routing dan controllers.
//
// qa:
// QA perlu memvalidasi theme rendering, routing behavior, dan error handling.
//**
import 'package:flutter/material.dart';

import 'package:frontend/core/core.dart';
import 'package:frontend/features/auth/auth.dart';
import 'package:frontend/features/course/course.dart';
import 'package:frontend/features/course_authoring/course_authoring.dart';
import 'package:frontend/features/explore/explore.dart';
import 'package:frontend/features/lesson/lesson.dart';
import 'package:frontend/features/notifications/notifications.dart';
import 'package:frontend/features/onboarding/onboarding.dart';
import 'package:frontend/features/profile/profile.dart';
import 'package:frontend/features/splash/splash.dart';
import 'package:frontend/shared/design_system/design_system.dart';
import 'package:frontend/shared/widgets/widgets.dart';

import 'main_shell.dart';
import '../routing/route_names.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeModeController.instance,
      builder: (context, child) => MaterialApp(
        title: 'MentorinAja',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: ThemeModeController.instance.mode,
        scrollBehavior: AppScrollBehavior(),
        builder: (context, child) =>
            AppShell(child: child ?? const SizedBox.shrink()),
        initialRoute: AppRoutes.splash,
        onGenerateRoute: (settings) {
          final routeName = settings.name ?? AppRoutes.home;
          return MaterialPageRoute(
            settings: settings,
            builder: (context) => _resolvePage(routeName),
          );
        },
      ),
    );
  }

  Widget _resolvePage(String routeName) {
    switch (routeName) {
      case AppRoutes.splash:
        return const SplashScreen();
      case AppRoutes.onboarding:
        return const OnboardingScreen();
      case AppRoutes.authentication:
        return const AuthenticationScreen();
      case AppRoutes.createAccount:
        return const CreateAccountScreen();
      case AppRoutes.signIn:
        return const SignInScreen();
      case AppRoutes.otpVerification:
        return const OtpVerificationScreen();
      case AppRoutes.home:
        return const MainShell();
      case AppRoutes.explore:
        return const ExplorePage();
      case AppRoutes.courses:
        return const Scaffold(body: Center(child: Text('Courses')));
      case AppRoutes.notifications:
        return const NotificationPage();
      case AppRoutes.feedback:
        return const FeedbackPage();
      case AppRoutes.helpCenter:
        return const HelpCenterPage();
      case AppRoutes.about:
        return const AboutPage();
      case AppRoutes.privacyPolicy:
        return const PrivacyPolicyPage();
      case AppRoutes.userPolicy:
        return const UserPolicyPage();
      case AppRoutes.editProfile:
        return const EditProfilePage();
      case AppRoutes.mentorCourses:
        return const CourseListPage();
      case AppRoutes.mentorCourseCreate:
        return const CourseCreatePage();
      case _ when routeName.startsWith('/mentor/courses/'):
        final parts = routeName.split('/');
        if (parts.length > 4 && parts[4] == 'preview') {
          final lessonId = parts.length > 5 ? parts[5] : '';
          return _buildCoursePreview(parts[2], lessonId);
        }
        if (parts.length > 4 && parts[4] == 'lessons') {
          return LessonEditorPage(courseId: parts[2], lessonId: parts[5]);
        }
        return CourseEditorPage(courseId: parts[2]);
      case _ when routeName.contains('/lesson/'):
        final parts = routeName.split('/');
        return CoursePlayerPage(
          courseId: parts.length > 2 ? parts[2] : '',
          lessonId: parts.length > 4 ? parts[4] : '',
        );
      case _ when routeName.endsWith('/completed'):
        final parts = routeName.split('/');
        return CourseCompletedPage(courseId: parts.length > 2 ? parts[2] : '');
      case _ when routeName.startsWith('/course/'):
        final id = routeName.replaceFirst(RegExp(r'^/course/'), '');
        return CourseDetailPage(courseId: id);
      case _ when routeName.startsWith('/category/'):
        final name = routeName.replaceFirst(RegExp(r'^/category/'), '');
        return CategoryDetailPage(categoryName: name);
      default:
        return const Scaffold(body: Center(child: Text('Not Found')));
    }
  }

  Widget _buildCoursePreview(String courseId, String lessonId) {
    final draft = MockCourseAuthoringRepository.instance.findDraft(courseId);
    if (draft == null) {
      return const Scaffold(
        body: Center(child: Text('Course Tidak Ditemukan')),
      );
    }
    final preview = const AuthoringPreviewAdapter().toPreview(draft);
    final resolvedLesson = lessonId.isEmpty
        ? (preview.lessons.isEmpty ? '' : preview.lessons.first.id)
        : lessonId;
    return CoursePlayerPage(
      courseId: courseId,
      lessonId: resolvedLesson,
      preview: preview,
    );
  }
}
