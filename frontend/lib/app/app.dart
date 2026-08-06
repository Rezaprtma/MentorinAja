import 'package:flutter/material.dart';

import 'package:frontend/core/core.dart';
import 'package:frontend/features/auth/auth.dart';
import 'package:frontend/features/onboarding/onboarding.dart';
import 'package:frontend/features/splash/splash.dart';
import 'package:frontend/shared/design_system/design_system.dart';
import 'package:frontend/shared/widgets/widgets.dart';

import '../routing/route_names.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MentorinAja',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
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
        return const Scaffold(body: Center(child: Text('Home')));
      case AppRoutes.courses:
        return const Scaffold(body: Center(child: Text('Courses')));
      case AppRoutes.courseDetail:
        return const Scaffold(body: Center(child: Text('Course Detail')));
      default:
        return const Scaffold(body: Center(child: Text('Not Found')));
    }
  }
}
