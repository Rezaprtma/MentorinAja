import 'package:flutter/material.dart';

/// Custom icon asset paths and [IconData] registry.
///
/// Provides two things:
/// 1. Asset paths for custom SVG/PNG icons under `assets/icons/`
/// 2. An [IconData] registry that maps custom icons to codepoints for
///    use with Flutter's [Icon] widget
///
/// When a custom icon font is added, register its codepoints here.
/// When SVG icons are added, register their paths here.
///
/// Asset files do not exist yet. Add them under `assets/icons/` and the
/// constants resolve automatically.
abstract final class AppIconPaths {
  const AppIconPaths._();

  // -------------------------------------------------------------------------
  // Navigation icons
  // -------------------------------------------------------------------------

  static const String home = 'assets/icons/home.png';
  static const String homeFilled = 'assets/icons/home_filled.png';
  static const String explore = 'assets/icons/explore.png';
  static const String exploreFilled = 'assets/icons/explore_filled.png';
  static const String courses = 'assets/icons/courses.png';
  static const String coursesFilled = 'assets/icons/courses_filled.png';
  static const String profile = 'assets/icons/profile.png';
  static const String profileFilled = 'assets/icons/profile_filled.png';
  static const String progress = 'assets/icons/progress.png';
  static const String progressFilled = 'assets/icons/progress_filled.png';

  // -------------------------------------------------------------------------
  // Action icons
  // -------------------------------------------------------------------------

  static const String bookmark = 'assets/icons/bookmark.png';
  static const String bookmarkFilled = 'assets/icons/bookmark_filled.png';
  static const String like = 'assets/icons/like.png';
  static const String likeFilled = 'assets/icons/like_filled.png';
  static const String share = 'assets/icons/share.png';
  static const String download = 'assets/icons/download.png';
  static const String downloadFilled = 'assets/icons/download_filled.png';

  // -------------------------------------------------------------------------
  // Feature icons
  // -------------------------------------------------------------------------

  static const String certificate = 'assets/icons/certificate.png';
  static const String achievement = 'assets/icons/achievement.png';
  static const String streak = 'assets/icons/streak.png';
  static const String leaderboard = 'assets/icons/leaderboard.png';
  static const String mentor = 'assets/icons/mentor.png';
  static const String quiz = 'assets/icons/quiz.png';
  static const String lesson = 'assets/icons/lesson.png';
  static const String video = 'assets/icons/video.png';
  static const String audio = 'assets/icons/audio.png';
  static const String document = 'assets/icons/document.png';

  // -------------------------------------------------------------------------
  // Technology icons
  // -------------------------------------------------------------------------

  static const String techPython = 'assets/icons/python.svg';
  static const String techPhp = 'assets/icons/php.svg';
  static const String techMysql = 'assets/icons/mysql.svg';
  static const String techJavascript = 'assets/icons/javascript.svg';
  static const String techTypescript = 'assets/icons/typescript-icon.svg';
  static const String techCss = 'assets/icons/css.svg';
  static const String techLaravel = 'assets/icons/laravel.svg';
  static const String techFlutter = 'assets/icons/flutter.svg';
  static const String techDart = 'assets/icons/dart.svg';
  static const String techCpp = 'assets/icons/c++.svg';
  static const String techJava = 'assets/icons/java.svg';
  static const String techCsharp = 'assets/icons/C#.svg';
  static const String techKotlin = 'assets/icons/kotlin.svg';
  static const String techSwift = 'assets/icons/swift.svg';
  static const String techNodejs = 'assets/icons/nodejs-logo.svg';
  static const String techGo = 'assets/icons/go.svg';
  static const String techPostgresql = 'assets/icons/postgresql.svg';
  static const String techSqllite = 'assets/icons/sqllite.svg';

  // -------------------------------------------------------------------------
  // Hero banner artwork
  // -------------------------------------------------------------------------

  /// Discovery illustration used on the Home hero carousel.
  static const String banner3 = 'assets/icons/banner3.svg';

  // -------------------------------------------------------------------------
  // UI icons
  // -------------------------------------------------------------------------

  static const String sun = 'assets/icons/sun.png';
  static const String moon = 'assets/icons/moon.png';
  static const String settings = 'assets/icons/settings.png';
  static const String notification = 'assets/icons/notification.png';
  static const String search = 'assets/icons/search.png';
  static const String filter = 'assets/icons/filter.png';
  static const String sort = 'assets/icons/sort.png';
  static const String calendar = 'assets/icons/calendar.png';
  static const String clock = 'assets/icons/clock.png';
  static const String check = 'assets/icons/check.png';
  static const String close = 'assets/icons/close.png';
  static const String arrowLeft = 'assets/icons/arrow_left.png';
  static const String arrowRight = 'assets/icons/arrow_right.png';
  static const String chevronDown = 'assets/icons/chevron_down.png';
}

/// Registry of custom [IconData] for use with Flutter's [Icon] widget.
///
/// When a custom icon font is added (e.g. from a design tool export),
/// register its codepoints here. The font family name must match the
/// family declared in `pubspec.yaml` under `flutter/fonts`.
///
/// Usage:
/// ```dart
/// Icon(AppIcons.customBookmark, size: 24);
/// ```
abstract final class AppIcons {
  const AppIcons._();

  // -------------------------------------------------------------------------
  // Placeholder — will be populated when custom icon font is added
  // -------------------------------------------------------------------------

  // Example (uncomment when icon font is registered):
  // static const IconData customBookmark = IconData(
  //   0xe001,
  //   fontFamily: 'AppCustomIcons',
  //   fontPackage: null,
  // );

  // -------------------------------------------------------------------------
  // Material icon aliases for convenience
  // -------------------------------------------------------------------------

  static const IconData homeOutlined = Icons.home_outlined;
  static const IconData homeFilled = Icons.home;
  static const IconData exploreOutlined = Icons.explore_outlined;
  static const IconData exploreFilled = Icons.explore;
  static const IconData schoolOutlined = Icons.school_outlined;
  static const IconData schoolFilled = Icons.school;
  static const IconData personOutlined = Icons.person_outlined;
  static const IconData personFilled = Icons.person;
  static const IconData barChartOutlined = Icons.bar_chart_outlined;
  static const IconData barChartFilled = Icons.bar_chart;
  static const IconData bookmarkOutlined = Icons.bookmark_outline;
  static const IconData bookmarkFilled = Icons.bookmark;
  static const IconData favoriteBorder = Icons.favorite_border;
  static const IconData favoriteFilled = Icons.favorite;
  static const IconData shareOutlined = Icons.share_outlined;
  static const IconData downloadOutlined = Icons.download_outlined;
  static const IconData downloadDone = Icons.download_done;
  static const IconData playCircle = Icons.play_circle_outline;
  static const IconData pauseCircle = Icons.pause_circle_outline;
  static const IconData checkCircle = Icons.check_circle_outline;
  static const IconData checkCircleFilled = Icons.check_circle;
  static const IconData errorOutline = Icons.error_outline;
  static const IconData wifiOff = Icons.wifi_off_outlined;
  static const IconData construction = Icons.construction;
  static const IconData search = Icons.search;
  static const IconData filterList = Icons.filter_list;
  static const IconData sort = Icons.sort;
  static const IconData calendarToday = Icons.calendar_today;
  static const IconData schedule = Icons.schedule;
  static const IconData settings = Icons.settings;
  static const IconData notifications = Icons.notifications_none;
  static const IconData darkMode = Icons.dark_mode;
  static const IconData lightMode = Icons.light_mode;
  static const IconData arrowBack = Icons.arrow_back_ios;
  static const IconData arrowForward = Icons.arrow_forward_ios;
  static const IconData chevronLeft = Icons.chevron_left;
  static const IconData chevronRight = Icons.chevron_right;
  static const IconData expandMore = Icons.expand_more;
  static const IconData expandLess = Icons.expand_less;
}
