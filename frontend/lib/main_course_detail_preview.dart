//**
// frontend/main_course_detail_preview.dart
//
// frontend:
// Development preview entrypoint. Untuk preview UI secara standalone.
//
// backend:
// File ini tidak memiliki dependency langsung terhadap backend.
//
// api:
// File ini tidak mendefinisikan atau memanggil API secara langsung.
//
// qa:
// QA perlu memvalidasi preview rendering.
//**
import 'package:flutter/material.dart';

import 'package:frontend/core/theme/theme.dart';
import 'package:frontend/features/course/course.dart';
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
        home: const CourseDetailPage(courseId: 'dasar-python'),
      ),
    ),
  );
}
