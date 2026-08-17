import 'package:flutter/material.dart';

import 'package:frontend/core/theme/theme.dart';
import 'package:frontend/features/tutor/tutor.dart';
import 'package:frontend/shared/design_system/design_system.dart';

void main() {
  runApp(
    ListenableBuilder(
      listenable: ThemeModeController.instance,
      builder: (context, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: ThemeModeController.instance.mode,
        home: Scaffold(
          body: AiTutorPanel(
            controller: TutorController(
              context: const TutorLessonContext(
                courseId: 'dasar-python',
                courseTitle: 'Dasar Python',
                lessonId: 'lesson-13',
                lessonTitle: 'Modularitas dan Import',
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
